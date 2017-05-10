% Stats for weighted data that are divided into classes
%{
For efficiency: data are not stored in the object

NaN values lead to NaN outputs
%}
classdef ClassifiedData < handle
   
properties
%    xV  double
%    wtV  double
%    classV uint16
   nClasses  uint16
   
   dbg  uint16 = 0
end


methods
   %% Constructor
   function cdS = ClassifiedData(nc)  % (xV, wtV, classV)
      cdS.nClasses = nc;
%       cdS.xV = xV;
%       cdS.wtV = wtV;
%       cdS.classV = uint16(classV);
   end
   
   
   %% Class means
   function meanV = class_means(cdS, xV, wtV, classV)
      meanV = nan([cdS.nClasses, 1]);
      for ic = 1 : cdS.nClasses
         idxV = find(classV == ic);
         if ~isempty(idxV)
            meanV(ic) = sum(xV(idxV) .* wtV(idxV)) ./ sum(wtV(idxV));
         end
      end
   end
   
end
   
end