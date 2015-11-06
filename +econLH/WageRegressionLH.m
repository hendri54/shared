% Code for wage regressions
%{
Regress log wages on some combination of
- age dummies
- age polynomial
- cohort dummies
- year dummies

Conventions:
Indexing order: age, school, year  [a,s,t]
%}
classdef WageRegressionLH < handle
   
properties
   % Weighted regression?
   useWeights
   % Use cohort effects (with 0 trend)?
   % useCohortEffects
   % Age range to use for each school group
   ageRange_asM
   % Year range
   yearV
   % Data
   logWage_astM
   wt_astM
   % Fitted models
   modelV
end



methods
   %% Constructor
   function wrS = WageRegressionLH(logWage_astM, wt_astM, ageRange_asM, yearV, useWeights)
      wrS.logWage_astM = logWage_astM;
      wrS.wt_astM = wt_astM;
      wrS.ageRange_asM = ageRange_asM;
      wrS.yearV = yearV(:);
      wrS.useWeights = useWeights;
      %wrS.useCohortEffects = useCohortEffects;
      
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
         end

         age_atM = ageV(:) * ones([1, ny]);
         if ~isequal(size(age_atM), size(logWage_atM))
            error('Invalid');
         end

         year_atM = ones([nAge,1]) * wrS.yearV(:)';
         if ~isequal(size(age_atM), size(year_atM))
            error('Invalid');
         end
         
%          % Birth years
%          if wrS.useCohortEffects
%             bYear_atM = year_atM - age_atM + 1;
%             % Impose 0 trend by setting first and last birth years to same values
%             byMin = min(bYear_atM(:));
%             byMax = max(bYear_atM(:));
%             bYear_atM(bYear_atM == byMax) = byMin;
%          end
         
         % Valid observations
         valid_atM = ~isnan(logWage_atM);
         if wrS.useWeights
            valid_atM(isnan(wt_atM)) = false;
         end

         vIdxV = find(valid_atM == 1);
         if length(vIdxV) < 50
            error('Too few obs');
         end

         % **** Linear model
         
         xM = [age_atM(vIdxV), year_atM(vIdxV)];
         
%          if wrS.useCohortEffects
%             xM = [xM, bYear_atM(vIdxV)];
%          end
         
         if wrS.useWeights
            mdl = fitlm(xM, logWage_atM(vIdxV), ...
               'CategoricalVars', [1 2], 'Weights', wt_atM(vIdxV));
         else
            mdl = fitlm(xM, logWage_atM(vIdxV), ...
               'CategoricalVars', [1 2]);
         end
         wrS.modelV{iSchool} = mdl;
      end
   end
   
      
   %% Extract age and year effects
   %  Meaningless scales
   function profileV = age_year_effects(wrS)
      nSchool = size(wrS.logWage_astM, 2);
      % Evaluate for this year (must be in range of dummies
      ny = length(wrS.yearV);
      refYear = wrS.yearV(round(ny / 2));
      
      profileV = cell([nSchool, 1]);
      for iSchool = 1 : nSchool
         clear regrS;
         regrS.ageValueV = wrS.ageRange_asM(1, iSchool) : wrS.ageRange_asM(2, iSchool);
         nAge = length(regrS.ageValueV);
         regrS.ageDummyV = feval(wrS.modelV{iSchool}, [regrS.ageValueV(:), refYear .* ones([nAge,1])]);

         regrS.yearValueV = wrS.yearV(:);
         ny = length(regrS.yearValueV);
         refAge = regrS.ageValueV(round(nAge / 2));
         regrS.yearDummyV = feval(wrS.modelV{iSchool}, [refAge .* ones([ny,1]), regrS.yearValueV]);
         
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
         age_atM = repmat(ageV(:), [1, ny]);
         year_atM = repmat(wrS.yearV(:)', [length(ageV), 1]);
         
         predV = wrS.modelV{iSchool}.feval(age_atM(:),  year_atM(:));
         pred_astM(ageV,iSchool,:) = reshape(predV,  [nAge, ny]);
      end
   end


end
   
  
   
end