classdef LinearModelLH < handle
%{
Regress y on non-categorical and categorical x's
Return dummy coefficients and their std errors
%}
properties
   % Dependent
   yV
   % Regressors
   xM
   xCatM
   % Weights
   wtV
   useWeights
end


properties (Dependent)
   nx
   nCat
   xNameV
   catNameV
end
   
methods
   %% Constructor
   function mS = LinearModelLH(yV, xM, xCatM, wtV, useWeights)
      mS.yV = yV;
      mS.xM = xM;
      mS.xCatM = xCatM;
      mS.wtV = wtV;
      mS.useWeights = useWeights;
      
      mS.validate;
   end
   
   
   %% Validate
   function validate(mS)
      nCat = mS.nCat;
      nx = mS.nx;
      n = size(mS.xM, 1);
      if nCat > 0
         validateattributes(mS.xCatM, {'double'}, {'real', 'size', [n, nCat]})
      end
      if nx > 0
         validateattributes(mS.xM, {'double'}, {'real', 'size', [n, nx]})
      end
   end
   
   function nx = get.nx(mS)
      if ~isempty(mS.xM)
         nx = size(mS.xM, 2);
      else
         nx = 0;
      end
   end
   
   function nCat = get.nCat(mS)
      if ~isempty(mS.xCatM)
         nCat = size(mS.xCatM, 2);
      else
         nCat = 0;
      end
   end
   
   % Names of x variables: x_1, ..., x_nx
   function xNameV = get.xNameV(mS)
      if mS.nx > 0
         xNameV = string_lh.vector_to_string_array(1 : mS.nx,  'x_%i');
      else
         xNameV = [];
      end
   end
   
   function catNameV = get.catNameV(mS)
      if mS.nCat > 0
         catNameV = string_lh.vector_to_string_array(1 : mS.nCat,  'cat%i');
      else
         catNameV = [];
      end
   end
   

   %% Build up table with data
   %{
   %}
   function [tbM, modelStr] = make_table(mS)
      tbM = table(mS.yV, 'VariableNames', {'y'});
      modelStr = 'y~1';
      
      % Add non-categorical variables
      if mS.nx > 0
         xNameV = mS.xNameV;
         for ix = 1 : mS.nx
            tbM.(xNameV{ix}) = mS.xM(:, ix);
            modelStr = [modelStr, '+', xNameV{ix}];
         end
      end
      
      % Add categorical variables
      if mS.nCat > 0
         catNameV = mS.catNameV;
         for ix = 1 : mS.nCat
            tbM.(catNameV{ix}) = nominal(mS.xCatM(:, ix));
            modelStr = [modelStr, '+', catNameV{ix}];
         end
      end
   end
   
   
   %% Regression
   %{
   OUT
      mdl :: LinearModel
      dummyV :: cell array
         each entry:
         valueV:  values this dummy takes on
         idxV:    index of regressor corresponding to this dummy (in mdl)
   %}
   function [mdl, dummyV] = regress(mS)
      dbg = 111;
      [tbM, modelStr] = mS.make_table;
      mdl = fitlm(tbM, modelStr);
      
      % Recover dummy coefficient indices
      dummyV = cell(mS.nCat, 1);
      for i1 = 1 : mS.nCat
         clear dS;
         dS.valueV = unique(double(mS.xCatM(:, i1)));
         dS.idxV = regressLH.dummy_pointers(mdl, mS.catNameV{i1}, dS.valueV, dbg);
         dummyV{i1} = dS;
      end
   end
end

end