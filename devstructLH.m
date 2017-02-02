% Class: structure with deviation from cal targets
%{
%}
classdef devstructLH < handle

properties
   name     % eg 'fracEnterIq'
   modelV   % model values
   dataV    % data values
   wtV      % relative weights, sum to 1
   scaleFactor    % multiply model and data by this when constructing scalarDev
   shortStr       % eg 'enter/iq'
   longStr        % eg 'fraction entering college by iq quartile'
   fmtStr         % for displaying the deviation
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
   function [scalarDev, scalarStr] = scalar_dev(d)
      devV = d.wtV(:) .* (d.scaleFactor .* (d.modelV(:) - d.dataV(:))) .^ 2;
      scalarDev = sum(devV);
      scalarStr = sprintf(d.fmtStr, scalarDev);
   end
   
   % Formatted short deviation for display
   function shortStr = short_display(d)
      [~, scalarStr] = scalar_dev(d);
      shortStr = [d.shortStr, ': ', scalarStr];
   end
end

end