% Code for wage regressions
%{
Regress log wages on some combination of
- age dummies or polynomial in experience
- year dummies
- cohort dummies
- other regressors

Important: first and last cohort dummy are set to 0 (by default)

How to recover fitted values and their confidence bands?
- need regressor matrix to get both
- simply return them as outputs when running `regress`

Conventions:
Indexing order: age, school, year  [a,s,t]

Change:
   when constructing coefficients: may get NaN when a cohort has no dummies (or an age)
%}
classdef WageRegressionLH < handle
   
properties
   % Weighted regression?
   useWeights
   % Use cohort effects (with 0 trend)?
   useCohortEffects
   % How to deal with age / experience?
   % possible values: 'ageDummies', 'polyX' (X order polynomial)
   ageTreatment
   % Age range to use for each school group
   ageRange_asM
   % Year range
   yearV
   % Data by [age, school, year]
   %  years in yearV
   %  physical ages
   logWage_astM
   % Other regressors by [age, school, year, variable]
   % can be []
   x_astvM
   % Regression weights
   wt_astM
   % Fitted models. Vector of LinearModel
   modelV
end


properties (Dependent)
   % Names of "other" regressors (if any)
   xNameV
   % Use age dummies?
   useAgeDummies
   % Highest exper power in exper polynomial (if any)
   highestExperPower
end



methods
   %% Constructor
   function wrS = WageRegressionLH(logWage_astM, x_astvM, wt_astM, ageRange_asM, yearV, useWeights, ...
         useCohortEffects, ageTreatment)
      wrS.logWage_astM = logWage_astM;
      wrS.x_astvM = x_astvM;
      wrS.wt_astM = wt_astM;
      wrS.ageRange_asM = ageRange_asM;
      wrS.yearV = yearV(:);
      wrS.useWeights = useWeights;
      wrS.useCohortEffects = useCohortEffects;
      wrS.ageTreatment = ageTreatment;
      
      wrS.validate;
   end
   
   
   %% Validate
   function validate(wrS)
      [nAge, nSchool, ny] = size(wrS.logWage_astM);
      validateattributes(wrS.yearV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'size', [ny, 1]})
      if wrS.useWeights
         validateattributes(wrS.wt_astM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
            'size', size(wrS.logWage_astM)})
      end
      validateattributes(wrS.ageRange_asM, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
         '>', 10, '<', 110,  'size', [2, nSchool]})
      % Age treatment
      if ~strcmpi(wrS.ageTreatment, 'ageDummies')
         if (length(wrS.ageTreatment) ~= 5)  ||  ~strcmpi(wrS.ageTreatment(1:4), 'poly')
            error('Invalid ageTreatment');
         end
      end
      assert(wrS.highestExperPower >= 0);
   end
   
   
   function xNameV = get.xNameV(wrS)
      if isempty(wrS.x_astvM)
         xNameV = [];
      else
         nVar = size(wrS.x_astvM, 4);
         xNameV = string_lh.vector_to_string_array(1 : nVar, 'x%i');
      end
   end
   
   function out1 = get.useAgeDummies(wrS)
      out1 = strcmp(wrS.ageTreatment, 'ageDummies');
   end
   
   function out1 = get.highestExperPower(wrS)
      if strcmp(wrS.ageTreatment(1:4), 'poly')
         out1 = str2double(wrS.ageTreatment(5));
      else
         out1 = 0;
      end
   end
   
   
   %% Run regression
   %{
   OUT
      fitted_astM(age, school, year)
         fitted values
      confIter_ast2M(age, school, year, low/high)
         confidence bands
   %}
   function [fitted_astM, confInt_ast2M] = regress(wrS)
      [ageMax, nSchool, ny] = size(wrS.logWage_astM);
      % Fitted values and confidence bands
      fitted_astM = nan([ageMax, nSchool, ny]);
      confInt_ast2M = nan([ageMax, nSchool, ny, 2]);

      for iSchool = 1 : nSchool
         ageV = wrS.ageRange_asM(1, iSchool) : wrS.ageRange_asM(2, iSchool);
         nAge = length(ageV);

         logWage_atM = squeeze(wrS.logWage_astM(ageV, iSchool, :));
         if wrS.useWeights
            wt_atM = squeeze(wrS.wt_astM(ageV, iSchool, :));
         else
            wt_atM = ones(nAge, ny);
         end

         age_atM = ageV(:) * ones([1, ny]);
         if ~isequal(size(age_atM), size(logWage_atM))
            error('Invalid');
         end

         year_atM = ones([nAge,1]) * wrS.yearV(:)';
         if ~isequal(size(age_atM), size(year_atM))
            error('Invalid');
         end
         
         % Dummy treatment of age, year is automatic b/c they are nominal variables
         tbM = table(logWage_atM(:), nominal(year_atM(:)), ...
            'VariableNames', {'logWage', 'year'});
         modelStr = 'logWage~1+year';
         
         % Age dummies
         if wrS.useAgeDummies
            modelStr = [modelStr, '+age'];
            tbM.age = nominal(age_atM(:));
         end
         
         % Experience polynomial
         if wrS.highestExperPower >= 1
            exper_atM = age_atM - wrS.ageRange_asM(1, iSchool);
            modelStr = [modelStr, '+exper^', sprintf('%i', wrS.highestExperPower)];
            tbM.exper = exper_atM(:);
         end
         
         % Birth years
         if wrS.useCohortEffects
            bYear_atM = year_atM - age_atM + 1;
            % Impose 0 trend by setting first and last birth years to same values
            byMin = min(bYear_atM(:));
            byMax = max(bYear_atM(:));
            bYear_atM(bYear_atM == byMax) = byMin;
            tbM.bYear = nominal(bYear_atM(:));
            modelStr = [modelStr, '+bYear'];
            clear bYear_atM;
         end
         clear logWage_atM age_atM year_atM;
         
         % Other regressors
         %  Added as xNameV{iVar} to the data table tbM
         if ~isempty(wrS.x_astvM)
            nVar = size(wrS.x_astvM, 4);
            xNameV = wrS.xNameV;
            for iVar = 1 : nVar
               %xNameV{iVar} = sprintf('x%i', iVar);
               xNewM = squeeze(wrS.x_astvM(ageV,iSchool,:,iVar));
               tbM.(xNameV{iVar}) = xNewM(:);
               modelStr = [modelStr, '+', xNameV{iVar}];
            end
            %xOther_atvM = reshape(wrS.x_astvM(ageV,iSchool,:,:), [length(ageV), ny, nVar]);
         %else
            %xOther_atvM = [];
            %nVar = 0;
         end
         
        
         % **** Linear model
         
         wrS.modelV{iSchool} = fitlm(tbM, modelStr, 'Weights', wt_atM(:));
         
         % **** Get fitted values and their confidence bands
         [fittedV, ciM] = wrS.modelV{iSchool}.predict(tbM);
         % Reshape into [a,s,t] format
         fitted_astM(ageV, iSchool, :) = reshape(fittedV,  [nAge, ny]);
         for i2 = 1 : 2
            confInt_ast2M(ageV,iSchool,:,i2) = reshape(ciM(:,i2), [nAge, ny]);
         end
      end
   end
   
      
   %% Extract age and year effects
   %{
   If experience polynomial, use it to compute age effects
   Also cohort effects (if any)
   Meaningless scales
   %}
   function profileV = age_year_effects(wrS, dbg)
      nSchool = size(wrS.logWage_astM, 2);     
      profileV = cell([nSchool, 1]);
      
      for iSchool = 1 : nSchool
         clear regrS;
         regrS.ageValueV = (wrS.ageRange_asM(1, iSchool) : wrS.ageRange_asM(2, iSchool))';
         
         if wrS.useAgeDummies
            [~, regrS.ageDummyV] = regressLH.dummy_pointers(wrS.modelV{iSchool}, 'age', regrS.ageValueV, dbg);
         elseif wrS.highestExperPower >= 1
            % Recover from polynomial
            experValueV = regrS.ageValueV - wrS.ageRange_asM(1, iSchool);
            nx = wrS.highestExperPower;
            regrS.ageDummyV = zeros(size(regrS.ageValueV));
            for ix = 1 : nx
               if ix == 1
                  rStr = 'exper';
               else
                  rStr = ['exper^', sprintf('%i', ix)];
               end
               [~, experBeta] = regressLH.find_regressors(wrS.modelV{iSchool}, rStr, dbg);
               validateattributes(experBeta, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
               regrS.ageDummyV = regrS.ageDummyV + (experValueV .^ ix) .* experBeta;
            end
         else
            regrS.ageDummyV = [];
         end
         if ~isempty(regrS.ageDummyV)
            validateattributes(regrS.ageDummyV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
         end
         
         regrS.yearValueV = wrS.yearV(:);
         [~, regrS.yearDummyV] = regressLH.dummy_pointers(wrS.modelV{iSchool}, 'year', regrS.yearValueV, dbg);
         
         if wrS.useCohortEffects
            % Remember that last cohort dummy is not there (imposed that it is 0 in the regression)
            bYearMin = wrS.yearV(1) - regrS.ageValueV(end) + 1;
            bYearMax = wrS.yearV(end) - regrS.ageValueV(1) + 1;
            regrS.bYearValueV = (bYearMin : bYearMax)';
            [~, regrS.bYearDummyV] = regressLH.dummy_pointers(wrS.modelV{iSchool}, 'bYear', regrS.bYearValueV, dbg);
            % Impose last birth year dummy = 0
            if isnan(regrS.bYearDummyV(end))
               regrS.bYearDummyV(end) = 0;
            end
         else
            regrS.bYearDummyV = [];
         end
                  
         profileV{iSchool} = regrS;
      end
   end
   
   
   
   %% Make predicted log wages by [age, school, year]
   %{
   OUT
      pred_astM(age, school, year)
         predicted values
         age dim covers only up to max wrS.ageRange_asM
   %}
   function pred_astM = predict_ast(wrS)
      ageMax = max(wrS.ageRange_asM(:));
      ny = length(wrS.yearV);
      nSchool = size(wrS.logWage_astM, 2);
      
      pred_astM = nan([ageMax, nSchool, ny]);
      for iSchool = 1 : nSchool
         ageV = wrS.ageRange_asM(1, iSchool) : wrS.ageRange_asM(2, iSchool);
         nAge = length(ageV);

         predV = wrS.modelV{iSchool}.Fitted;
         
         pred_astM(ageV,iSchool,:) = reshape(predV,  [nAge, ny]);
      end
   end


end
   
  
   
end