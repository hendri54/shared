function WageRegressionLHtest
%{
Change:
   test with missing values +++
   test recovery of birth year dummies +++
%}

disp('Testing WageRegressionLH');

for useWeights = [false, true]
   for useCohortEffects = [false, true]
      check_one(useWeights, useCohortEffects);
   end
end

end


%% Check one case
function check_one(useWeights, useCohortEffects)
   dbg = 111;
   rng(231);
   ageMax = 65;
   nSchool = 3;
   yearV = 1970 : 1980;
   ny = length(yearV);

   wt_astM = rand([ageMax, nSchool, ny]);
   ageRange_asM = [round(linspace(18, 23, nSchool)); round(linspace(40, 45, nSchool))];

   %% Estimate

   regrV = cell(nSchool, 1);

   logWage_astM = nan([ageMax, nSchool, ny]);
   for iSchool = 1 : nSchool
      regrS.ageV = ageRange_asM(1, iSchool) : ageRange_asM(2, iSchool);
      regrS.ageCoeffV = linspace(iSchool, iSchool+1, length(regrS.ageV));
      regrS.yearCoeffV = linspace(1, -iSchool, ny);
      logWage_astM(regrS.ageV, iSchool, :) = repmat(regrS.ageCoeffV(:), [1, ny]) + ...
         repmat(regrS.yearCoeffV, [length(regrS.ageV), 1]) + randn(length(regrS.ageCoeffV), ny) .* 0.05;
      regrV{iSchool} = regrS;
   end

   x_astvM = [];
   wrS = econLH.WageRegressionLH(logWage_astM, x_astvM, wt_astM, ageRange_asM, yearV, useWeights, useCohortEffects);

   wrS.regress;

   profileV = wrS.age_year_effects(dbg);

   pred_astM = wrS.predict_ast;


   %% Check that age and year coefficients are recovered
   % But with cohort effects the linear trend is not identified

   for iSchool = 1 : nSchool
      profS = profileV{iSchool};
      regrS = regrV{iSchool};

      if useCohortEffects
         m2 = fitlm(regrS.ageCoeffV(:),  profS.ageDummyV(:));
         assert(max(abs(m2.Residuals.Raw)) < 0.05);
      else
         diffAgeV = (profS.ageDummyV(:) - mean(profS.ageDummyV)) - (regrS.ageCoeffV(:) - mean(regrS.ageCoeffV));
         assert(max(abs(diffAgeV)) < 0.05);
      end
      
      if useCohortEffects
         m2 = fitlm(regrS.yearCoeffV(:),  profS.yearDummyV(:));
         assert(max(abs(m2.Residuals.Raw)) < 0.05);
      else
         diffYearV = (profS.yearDummyV(:) - mean(profS.yearDummyV)) - (regrS.yearCoeffV(:) - mean(regrS.yearCoeffV));
         assert(max(abs(diffYearV)) < 0.05);
      end
   end


   %% Check that predicted profiles are close to actual

   ageMax = max(ageRange_asM(:));
   xM = logWage_astM(1 : ageMax, :,:);
%    diff_astM = pred_astM - xM;
%    diff_astM(isnan(xM)) = 0;
%    assert(max(abs(diff_astM(:))) < 0.15);

   % Check 45 degree line
   mdl = fitlm(xM(:),  pred_astM(:));
   betaV = mdl.Coefficients.Estimate;
   seV = mdl.Coefficients.SE;
   assert(all(abs(abs(betaV(:) - [0; 1]) < 2.5 * seV(:))));

end