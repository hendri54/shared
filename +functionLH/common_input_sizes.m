function [commonSizeV, isScalarV] = common_input_sizes(sizeV)
% Given a list of input sizes, return
% - common size of all non-scalar inputs
% - indicators which inputs are scalar
%{
If sizes are not common: error

Purpose: scalar expansion of function inputs

IN
   sizeV
      cell array of row vectors (input sizes)
OUT
   commonSizeV
      vector of common input sizes with scalar expansion
   isScalarV  ::  logical
      which inputs are scalar?
%}

assert(isa(sizeV, 'cell'));

% Which inputs are scalar?
isScalarV = cellfun(@(x)  sum(x),  sizeV) == 2;

if all(isScalarV)
   commonSizeV = [1, 1];
   return;
end

% Unique sizes
% B = cellfun(@(x) num2str(x(:)'),  sizeV,  'UniformOutput',false);
uniqueSizeV = cellLH.uniquecell(sizeV(~isScalarV));

if length(uniqueSizeV) == 1
   commonSizeV = uniqueSizeV{1};
else
   error('No common sizes');
end


end