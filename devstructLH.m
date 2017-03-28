% Class: structure with deviation from cal targets
%{
%}
classdef devstructLH < handle

properties
   name  char     % eg 'fracEnterIq'
   modelV  double   % model values
   dataV  double    % data values
   wtV  double      % relative weights, sum to 1
   scaleFactor  double    % multiply model and data by this when constructing scalarDev
   shortStr  char       % eg 'enter/iq'
   longStr  char        % eg 'fraction entering college by iq quartile'
   fmtStr  char         % for displaying the deviation
end

methods
   % Constructor
   function d = devstructLH(nameStr, shortStr, longStr, modelV, dataV, wtV, scaleFactor, fmtStr)
      d.name = nameStr;
      d.shortStr = shortStr;
      d.longStr = longStr;
      d.modelV = modelV;
      d.dataV = dataV;
      % Expand scalar weights
      if length(wtV) == 1
         wtV = wtV .* ones(size(modelV));
      end
      d.wtV = wtV ./ sum(wtV(:));
      d.scaleFactor = scaleFactor;      
      d.fmtStr = fmtStr;
   end
   
   % Scalar deviation
   % scaleFactor used to be inside the sum of squares
   function [scalarDev, scalarStr] = scalar_dev(d)
      devV = d.wtV(:) .* ((d.modelV(:) - d.dataV(:))) .^ 2;
      scalarDev = d.scaleFactor .* sum(devV);
      scalarStr = sprintf(d.fmtStr, scalarDev);
   end
   
   % Formatted short deviation for display
   function shortStr = short_display(d)
      [~, scalarStr] = scalar_dev(d);
      shortStr = [d.shortStr, ': ', scalarStr];
   end
end

end