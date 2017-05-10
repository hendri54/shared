% Info about a data variable
classdef Variable < handle

properties
   % Name to be used to save the variable (e.g. 'age')
   nameStr  char
   % Name in original dataset
   origNameStr  char
   
   % Class (e.g. double)
   vClass  char  =  'double'
   
   % Min, max values (not including missing value codes)
   minVal = []   
   maxVal = []  
   % Discrete or continuous
   isDiscrete  logical  = false
   % Limited set of valid values (if discrete)
   validValueV = []   
   % Value labels (if discrete)
   valueLabelV  cell = []
   % Missing value codes
   missValCodeV = []
   % These values indicate top codes
   topCodeV = []   
   
   % Missing value code used to replace variable specific ones
   missingCode = NaN
   % Are NaN values permitted?
   % If not, they generate errors. If yes: they are left alone
   permitNan  logical = true
   
   % Other properties, stored as name/value pairs (cell array)
   otherV   cell
end


methods
   %% Constructor
   function vS = Variable(nameStr, varargin)
      vS.nameStr = nameStr;
      vS.origNameStr = nameStr;
      
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
         validateattributes(vS.minVal, {vS.vClass}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      end
      if ~isempty(vS.maxVal)
         validateattributes(vS.maxVal, {vS.vClass}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      end
%       if vS.isDiscrete
%          % Check that all values are in discrete set
%          assert(all(ismember
%       end
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
   %{
   But ignore missing value codes
   %}
   function [out1, outMsg] = is_valid(vS, inV)
      out1 = true;
      outMsg = 'valid';
      
      if vS.permitNan
         % Only check values that are not NaN
         inV = inV(~isnan(inV));
         if all(isnan(inV))
            return;
         end
      elseif any(isnan(inV))
         out1 = false;
         outMsg = 'NaN encountered';
         return;
      end
      
      % Mark valid observations
      if ~isempty(vS.missValCodeV)
         validV = ~ismember(inV, vS.missValCodeV);
      else
         validV = true(size(inV));
      end
      
      if ~isempty(vS.minVal)
         if any(inV(validV) < vS.minVal)
            out1 = false;
            outMsg = 'values below minimum';
            return;
         end
      end
      if ~isempty(vS.maxVal)
         if any(inV(validV) > vS.maxVal)
            out1 = false;
            outMsg = 'values above maximum';
            return;
         end
      end
      
      if vS.isDiscrete
         % Check that all values are in discrete set
         if any(~ismember(inV,  [vS.validValueV(:); vS.missValCodeV(:)]))
            out1 = false;
            outMsg = 'invalid discrete values';
            return;
         end
      end
   end
   
   
   %% Replace missing value codes with common code (could be NaN)
   %{
   If no missing value codes defined: do nothing
   NaNs are not replaced, unless they are in missValCodeV
   %}
   function outV = replace_missing_values(vS, inV)
      outV = inV;
      if ~isempty(vS.missValCodeV)
         for i1 = 1 : length(vS.missValCodeV)
            outV(inV == vS.missValCodeV(i1)) = vS.missingCode;
         end
      end
   end
   
   
   %% Process one variable during import
   %{
   Check that values match with variable info
   Then make common missing value code
   %}
   function outV = process(varS, xV)
      % Check that it's valid
      if ~varS.is_valid(xV)
         fprintf('Error in variable %s \n',  varS.origNameStr);
         [~, msgStr] = varS.is_valid(xV);
         error(msgStr);
      end

      % Change to expected type
      outV = cast(xV, varS.vClass);

      % Replace missing values with common code
      outV = varS.replace_missing_values(outV);
   end
   
end
   
end