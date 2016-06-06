% Regress a variable on age / school / year dummies
%{
%}
classdef RegrAgeSchoolYear

properties
   weighted    logical
   ageRangeV   uint8
   yearRangeV  uint16
   schoolRangeV   uint8
end


methods
   %% Constructor
   function rS = RegrAgeSchoolYear(ageRangeV, schoolRangeV, yearRangeV, weighted)
      rS.weighted = weighted;
      validateattributes(ageRangeV(:), {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', ...
         '<', 120, 'size', [2,1]})
      rS.ageRangeV = uint8(ageRangeV(:));

      validateattributes(schoolRangeV(:), {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 0, ...
         '<', 35, 'size', [2,1]})
      rS.schoolRangeV = uint8(schoolRangeV(:));
      
      validateattributes(yearRangeV(:), {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1600, ...
         '<', 2050, 'size', [2,1]})
      rS.yearRangeV = uint16(yearRangeV(:));
   end
   
   
   %% Regression
   %{
   OUT
      ageDummy, schoolDummyV, yearDummyV
         meaningless scales
      mdl
         linear model with regressors: age, school, year, x
         can be used to get predicted wages easily:
            feval(mdl, [40, 12, 1998, 1.234])
   %}
   function outS = regress(rS, y_astM, x_astM, wt_astM)
      nAge = diff(rS.ageRangeV) + 1;
      nSchool = diff(rS.schoolRangeV) + 1;
      nYear = diff(rS.yearRangeV) + 1;
      
      valid_astM = ~isnan(y_astM);
      if rS.weighted
         valid_astM(wt_astM <= 0) = false;
      end
      if ~isempty(x_astM)
         valid_astM(isnan(x_astM)) = false;
      end
      vIdxV = find(valid_astM(:));
      nObs = length(vIdxV);
      
      ageV = rS.ageRangeV(1) : rS.ageRangeV(2);
      a_astM = repmat(ageV(:), [1, nSchool, nYear]);
      assert(isequal(size(a_astM), size(y_astM)));
      assert(all(abs(a_astM(:,2,2) - ageV(:)) < 1e-8));
      
      schoolV = rS.schoolRangeV(1) : rS.schoolRangeV(2);
      s_astM = permute(repmat(schoolV(:), [1, nAge, nYear]), [2, 1, 3]);
      assert(isequal(size(s_astM), size(y_astM)));
      assert(all(abs(squeeze(s_astM(2,:,2)) - schoolV) < 1e-8));
      
      yearV = rS.yearRangeV(1) : rS.yearRangeV(2);
      t_astM = permute(repmat(yearV(:), [1, nAge, nSchool]), [2, 3, 1]);
      assert(isequal(size(t_astM), size(y_astM)));
      assert(all(abs(squeeze(t_astM(2,2,:)) - yearV(:)) < 1e-8));
      
      
      % ****  Regression

      xM = [double(a_astM(vIdxV)),  double(s_astM(vIdxV)),  double(t_astM(vIdxV))];
      if ~isempty(x_astM)
         xM = [xM, x_astM(vIdxV)];
      end
         
      if rS.weighted
         outS.mdl = fitlm(double(xM), double(y_astM(vIdxV)), 'Weights', wt_astM(vIdxV), 'CategoricalVars', [1,2,3]);
      else
         outS.mdl = fitlm(double(xM), double(y_astM(vIdxV)), 'CategoricalVars', [1,2,3]);
      end
      
      
      % ****  Recover dummies
      
      x2M = repmat(xM(1,:), [nAge, 1]);
      x2M(:,1) = ageV;
      outS.ageDummyV = feval(outS.mdl, x2M);
      
      x2M = repmat(xM(1,:), [nSchool, 1]);
      x2M(:,2) = schoolV;
      outS.schoolDummyV = feval(outS.mdl, x2M);
      
      x2M = repmat(xM(1,:), [nYear, 1]);
      x2M(:,3) = yearV;
      outS.yearDummyV = feval(outS.mdl, x2M);
   end
end


end