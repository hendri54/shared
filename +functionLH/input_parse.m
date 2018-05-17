function paramS = input_parse(argListV, paramInS, paramNameV, defaultValueV)
% A better interface for Matlab input parser
%{
All inputs in argListV must be valid fields for paramS

IN
   argListV :: cell array
      this will usually be varargin from a function call
      odd numbers are names, even elements are values
      length must be even
   paramInS :: struct  OR  handle object
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

if ~isempty(argListV)
   assert(isa(argListV, 'cell'),  'Expecting name value pairs as cell array');
end

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
if ~isempty(argListV)
   nInputs = length(argListV);
   assert(mod(nInputs, 2) == 0,  'Number of name-value inputs must be even');

   % Loop over odd entries (parameter names)
   for i1 = 1 : 2 : (nInputs-1)
      paramS.(argListV{i1}) = argListV{i1+1};
   end
end

end