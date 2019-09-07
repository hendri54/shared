% Convert numbers to strings, nicely formatted
%{
Based on
   http://undocumentedmatlab.com/blog/formatting-numbers
Produces output like 123,456.78

Currently does not set groupSeparator, nDecimals
%}
classdef NumberFormat < handle
   
properties
   % Group separator
   groupSeparator  char  = ','
   nDecimals  uint8  = []
   
   % Use options for currency?
   currency  logical = false
   
   % java object that does all the work
   javaS
end

methods
   %% Constructor
   function nfS = NumberFormat(varargin)
      functionLH.varargin_parse(nfS, varargin(:));
      
      if nfS.currency
         nfS.currency_options;
      end
      
      nfS.javaS = java.text.DecimalFormat;
%       nfS.javaS.setDecimalFormatSymbols = nfS.groupS

      if ~isempty(nfS.nDecimals)
         nfS.javaS.setMaximumFractionDigits(nfS.nDecimals);
         nfS.javaS.setMinimumFractionDigits(nfS.nDecimals);
      end      
   end
   
   
   %% Set options for currency
   function currency_options(nfS)
      nfS.groupSeparator = ',';
      nfS.nDecimals = 2;
   end
   
   
   %% Format an array of numbers
   %{
   OUT
      outM
         for a single number: char
         for an array: cell
   %}
   function outM = format(nfS, numberM)
      if numel(numberM) == 1
         outM = char(nfS.javaS.format(double(numberM)));
      else
         outM = cell(size(numberM));
         for ir = 1 : size(numberM, 1)
            for ic = 1 : size(numberM, 2)
               outM{ir, ic} = char(nfS.javaS.format(double(numberM(ir, ic))));
            end
         end
      end
   end
end
   
end