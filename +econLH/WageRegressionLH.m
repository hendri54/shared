% Code for wage regressions
%{
Regress log wages on some combination of
- age dummies
- year dummies
- cohort dummies
- other regressors

Conventions:
Indexing order: age, school, year  [a,s,t]

Change:
   test wtih cohort effects +++++
   when constructing coefficients: may get NaN when a cohort has no dummies (or an age)
%}
classdef WageRegressionLH < handle
   
properties
   % Weighted regression?
   useWeights
   % Use cohort effects (with 0 trend)?
   useCohortEffects
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
   % Fitted models
   modelV
end


properties (Dependent)
   % Names of "other" regressors (if any)
   xNameV
end



methods
   %% Constructor
   function wrS = WageRegressionLH(logWage_astM, x_astvM, wt_astM, ageRange_asM, yearV, useWeights, useCohortEffects)
      wrS.logWage_astM = logWage_astM;
      wrS.x_astvM = x_astvM;
      wrS.wt_astM = wt_astM;
      wrS.ageRange_asM = ageRange_asM;
      wrS.yearV = yearV(:);
      wrS.useWeights = useWeights;
      wrS.useCohortEffects = useCohortEffects;
      
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
   end
   
   
   function xNameV = get.xNameV(wrS)
      if isempty(wrS.x_astvM)
         xNameV = [];
      else
         nVar = size(wrS.x_astvM, 4);
         xNameV = string_lh.vector_to_string_array(1 : nVar, 'x%i');
      end
   end
   
   
   %% Run regression
   %{
   One school group
   %}
   function regress(wrS)
      [~, nSchool, ny] = size(wrS.logWage_astM);

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
         
         tbM = table(logWage_atM(:), nominal(age_atM(:)), nominal(year_atM(:)), ...
            'VariableNames', {'logWage', 'age', 'year'});
         modelStr = 'logWage~1+age+year';
         
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
         else
            %xOther_atvM = [];
            nVar = 0;
         end
         
        
         % **** Linear model
         
         wrS.modelV{iSchool} = fitlm(tbM, modelStr, 'Weights', wt_atM(:));
         
      end
   end
   
      
   %% Extract age and year effects
   %  Meaningless scales
   function profileV = age_year_effects(wrS, dbg)
      nSchool = size(wrS.logWage_astM, 2);     
      profileV = cell([nSchool, 1]);
      
      for iSchool = 1 : nSchool
         clear regrS;
         regrS.ageValueV = wrS.ageRange_asM(1, iSchool) : wrS.ageRange_asM(2, iSchool);
         
         [~, regrS.ageDummyV] = regressLH.dummy_pointers(wrS.modelV{iSchool}, 'age', regrS.ageValueV, dbg);
         
         regrS.yearValueV = wrS.yearV(:);
         [~, regrS.yearDummyV] = regressLH.dummy_pointers(wrS.modelV{iSchool}, 'year', regrS.yearValueV, dbg);
         
         if wrS.useCohortEffects
            bYearMin = wrS.yearV(1) - regrS.ageValueV(end) + 1;
            bYearMax = wrS.yearV(end) - regrS.ageValueV(1) + 1;
            regrS.bYearValueV = (bYearMin : bYearMax)';
            [~, regrS.bYearDummyV] = regressLH.dummy_pointers(wrS.modelV{iSchool}, 'bYear', regrS.bYearValueV, dbg);
         end
                  
         profileV{iSchool} = regrS;
      end
   end
   
   
   
   %% Make predicted log wages by [age, school, year]
   function pred_astM = predict_ast(wrS)
      ageMax = max(wrS.ageRange_asM(:));
      ny = length(wrS.yearV);
      nSchool = size(wrS.logWage_astM, 2);
      
      pred_astM = nan([ageMax, nSchool, ny]);
      for iSchool = 1 : nSchool
         ageV = wrS.ageRange_asM(1, iSchool) : wrS.ageRange_asM(2, iSchool);
         nAge = length(ageV);
%          age_atM = repmat(ageV(:), [1, ny]);
%          year_atM = repmat(wrS.yearV(:)', [length(ageV), 1]);

         predV = wrS.modelV{iSchool}.Fitted;
%          if wrS.useCohortEffects
%             bYear_atM = year_atM - age_atM + 1;
%             predV = wrS.modelV{iSchool}.feval(age_atM(:),  year_atM(:));
%          else
%             predV = wrS.modelV{iSchool}.feval(age_atM(:),  year_atM(:),  bYear_atM(:));
%          end
         
         pred_astM(ageV,iSchool,:) = reshape(predV,  [nAge, ny]);
      end
   end


end
   
  
   
end