function paramS = input_parse(argListV, paramInS, paramNameV, defaultValueV)
% A better interface for Matlab input parser
%{
All inputs in argListV must be valid fields for paramS

IN
   argListV :: cell array
      this will usually be varargin from a function call
      odd numbers are names, even elements are values
   paramInS :: struct
      structure into which params are to be copied
      can also be an object
      if it is a handle object, it will be modified in place
   paramNameV :: cell arrary
      names of optional parameters
   defaultValueV :: cell array
      default values of those parameters

OUT
   paramS
      copy of paramInS with all fields filled in
      can be ignored if paramInS is handle object
%}


if nargin < 4
   defaultValueV = [];
end
if nargin < 3
   paramNameV = [];
end

paramS = paramInS;


%% Copy defaults into paramS

if ~isempty(paramNameV)
   for i1 = 1 : length(paramNameV)
      paramS.(paramNameV{i1}) = defaultValueV{i1};
   end
end

%% Copy provided inputs into paramS

nInputs = length(argListV);

% Loop over odd entries (parameter names)
for i1 = 1 : 2 : (nInputs-1)
   paramS.(argListV{i1}) = argListV{i1+1};
end


end