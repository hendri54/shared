% Info about a data variable
classdef Variable < handle

properties
   % Name in dataset
   nameStr  char
   % Min, max values
   minVal   double
   maxVal   double
   % Limited set of valid values
   validValueV    double
   % Missing value codes
   missValCodeV   double
   % These values indicate top codes
   topCodeV    double
   
   % Other properties, stored as name/value pairs (cell array)
   otherV   cell
end


methods
   %% Constructor
   function vS = Variable(nameStr, varargin)
      vS.nameStr = nameStr;
      
      n = length(varargin);
      if n > 0
         for i1 = 1 : 2 : (n-1)
            vS.(varargin{i1}) = varargin{i1+1};
         end
      end
      
      vS.validate;
   end
   
   
   %% Validate
   function validate(vS)
      if ~isempty(vS.minVal)
         validateattributes(vS.minVal, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      end
      if ~isempty(vS.maxVal)
         validateattributes(vS.maxVal, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      end
   end
   
   
   %% Retrieve a property stored in otherV
   %{
   OUT
      outVal
         [] if property does not exist
   %}
   function outVal = other(vS, otherName)
      outVal = [];
      n = length(vS.otherV);
      if n >= 2
         pIdx = find(strcmp(vS.otherV(1 : 2 : (n-1)),  otherName));
         if length(pIdx) == 1
            outVal = vS.otherV{pIdx+1};
         end
      end
   end
   
   
   %% Check that an input has codes consistent with that variable
   function [out1, outMsg] = is_valid(vS, inV)
      out1 = true;
      outMsg = 'valid';
      
      if ~isempty(vS.minVal)
         if any(inV < vS.minVal)
            out1 = false;
            outMsg = 'values below minimum';
            return;
         end
      end
      if ~isempty(vS.maxVal)
         if any(inV > vS.maxVal)
            out1 = false;
            outMsg = 'values above maximum';
            return;
         end
      end
   end
end
   
end