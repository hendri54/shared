% Covariance matrix
%{
Mainly for convenient display
%}
classdef CovMatrix < handle
   
properties
   covM
   varNameV
end

properties (Dependent)
   n
end


methods
   function cM = CovMatrix(covM, varNameV)
      cM.covM = covM;
      cM.varNameV = varNameV;
   end

   function nOut = get.n(cM)
      nOut = length(cM.varNameV);
   end
   
   function validate(cM)
      validateattributes(cM.covM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [cM.n,cM.n]})      
   end
   
   
   %% Convert between corr matrix and cov matrix
   % corrcov does the reverse
   function cov_from_corr(cM, corrM, stdV)
      cM.covM = diag(stdV) * corrM * diag(stdV);
   end
   
   
   %% Make formatted cell array
   function cellM = cell_array(cM, fmtStrIn)
      if isempty(fmtStrIn)
         fmtStr = '%.3g';
      else
         fmtStr = fmtStrIn;
      end
      
      cellM = cell(cM.n + 1, cM.n + 1);
      cellM(1, 2 : end) = cM.varNameV;
      cellM(2 : end, 1) = cM.varNameV;
      cellM(2:end, 2:end) = matrixLH.array2cell(cM.covM, fmtStr);
   end
end
   
end