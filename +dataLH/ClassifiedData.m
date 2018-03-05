% Stats for weighted data that are divided into classes
%{
For data that are continuous but will be divided into classes.

DiscreteData class handles data that are discrete from the outset

For efficiency: data are not stored in the object

NaN handling controlled by 'omitnan'
%}
classdef ClassifiedData < handle
   
properties
%    xV  double
%    wtV  double
%    classV uint16
   nClasses  uint16
   
   % False: NaN values lead to NaN results
   omitNaN  logical = false
   
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
   
   
   %% Assign classes
   % Matrices are flattened
   function classV = assign_classes(cdS, xV, wtV, ubV)
      if any(isnan(xV(:)))  ||  any(isnan(wtV(:)))
         % Handle NaN values
         classV = nan(numel(xV), 1);
         if cdS.omitNaN
            % NaNs are omitted
            useV = ~isnan(xV(:))  &  (wtV(:) > 0);
            if length(useV) > cdS.nClasses
               classV(useV) = distribLH.class_assign(xV(useV), wtV(useV), ubV, cdS.dbg);
            end
         %else
         %  everything NaN
         end
      else
         % No NaN values
         classV = distribLH.class_assign(xV(:), wtV(:), ubV, cdS.dbg);
      end
   end
   
   
   %% Class means, given classes
   function meanV = class_means(cdS, xV, wtV, classV)
      if ~cdS.omitNaN  ||  ~any(isnan(xV(:)))
         % No NaNs to omit
         classWtV = accumarray(classV(:), wtV(:), [cdS.nClasses, 1], @sum);
         classTotalV = accumarray(classV(:), xV(:) .* wtV(:), [cdS.nClasses, 1], @sum);
         meanV = classTotalV ./ classWtV;
      else
         % Some NaN to omit
         useV = ~isnan(xV(:));
         if any(useV)
            classWtV = accumarray(classV(useV), wtV(useV), [cdS.nClasses, 1], @sum);
            classTotalV = accumarray(classV(useV), xV(useV) .* wtV(useV), [cdS.nClasses, 1], @sum);
            meanV = classTotalV ./ classWtV;
         else
            % Only NaN
            meanV = nan(cdS.nClasses, 1);
         end
         
      end
   end
   
   
   %% Class std deviations, given classes
   %{
   OUT
      stdV  ::  double
         weighted std dev in each x class
      meanV  ::  double
         weighted mean in each x class
      Both are NaN for empty classes
   %}
   function [xStdV, xMeanV] = class_std(cdS, xV, wtV, classV)
      xMeanV = nan(cdS.nClasses, 1);
      xStdV  = nan(cdS.nClasses, 1);
%       yMeanV = nan(cdS.nClasses, 1);
%       yStdV  = nan(cdS.nClasses, 1);
      
      for ic = 1 : cdS.nClasses
         % Observations in class
         cIdxV = find(classV == ic);
         if ~isempty(cIdxV)
            % Drop Nan x's (should not exist, really)
            if any(isnan(xV(cIdxV)))
               if cdS.omitNaN
                  cIdxV(isnan(xV(cIdxV))) = [];
               else
                  cIdxV = [];
               end
            end
            if ~isempty(cIdxV)
               [xStdV(ic), xMeanV(ic)] = statsLH.std_w(xV(cIdxV), wtV(cIdxV), cdS.dbg);
               
%                % Now the same for y
%                if any(isnan(yV(cIdxV)))
%                   % Drop Nan y's
%                   if cdS.omitNan
%                      cIdxV(isnan(yV(cIdxV))) = [];
%                   else
%                      cIdxV = [];
%                   end
%                   if ~isempty(cIdxV)
%                      [yStdV(ic), yMeanV(ic)] = statsLH.std_w(yV(cIdxV), wtV(cIdxV), cdS.dbg);
%                   end
%                end
            end
         end
      end      
   end
   
   
   %% Class means, given bounds
   %{
   Assign observations into classes given percentile upper bounds
   Compute mean of classifying variable and another variable for each class
   
   If there are any NaN in xV or wtV: return all NaN (unless omitNaN)
   
   Example: Wish to plot mean(y) against mean(x) where data are grouped into x classes
   
   IN
      yV  ::  double
      xV  ::  double
         means are computed for x classes for x and y
      wtV  ::  double
         weights; required
   %}
   function [yMeanV, xMeanV] = means_from_bounds(cdS, yV, xV, wtV, ubV)
      assert(isequal(length(ubV), cdS.nClasses));
      
      if ~cdS.omitNaN
         if any(isnan(xV(:)))  ||  any(isnan(wtV))
            % Cannot assign classes. Return all NaN
            yMeanV = nan(cdS.nClasses, 1);
            xMeanV = nan(cdS.nClasses, 1);
         else
            % Assign classes
            classV = distribLH.class_assign(xV(:), wtV(:), ubV, cdS.dbg);
            xMeanV = cdS.class_means(xV, wtV, classV);
            if ~isempty(yV)
               yMeanV = cdS.class_means(yV, wtV, classV);
            else
               yMeanV = [];
            end
         end
         
      else
         % Assign classes
         useV = ~isnan(xV)  &  ~isnan(wtV);
         if ~isempty(yV)
            useV(isnan(yV)) = false;
         end
         
         if any(useV)
            classV = distribLH.class_assign(xV(useV), wtV(useV), ubV, cdS.dbg);
            xMeanV = cdS.class_means(xV(useV), wtV(useV), classV);
            if ~isempty(yV)
               yMeanV = cdS.class_means(yV(useV), wtV(useV), classV);
            else
               yMeanV = [];
            end
         else
            yMeanV = nan(cdS.nClasses, 1);
            xMeanV = nan(cdS.nClasses, 1);
         end
      end
   end
   
end
   
end