function outM = apply_scalar_function(inM, fHandle, iDim, dbg)
% Apply a scalar function to one dimension of an array of arbitrary size
%{
Example
   apply_scalar_function(inM, @sum, 3, dbg) == sum(inM, 3)
IN
   inM
      n dimensional array, n >= 3
   fHandle
      handle of function that takes vector and outputs scalar
   iDim
      dimension to which fHandle should be applied

OUT
   outM
      n-1 dimensional array
%}


sizeInV = size(inM);
n = length(sizeInV);
assert(n >= 3);

if iDim > 1
   % Make dimension iDim the first
   orderV = [iDim : n, 1 : (iDim-1)];
   inM = permute(inM, orderV);
   sizeV = size(inM);
else
   sizeV = sizeInV;
end


% Size of output matrix flattened into vector
n2 = prod(sizeV(2:n));
outV = zeros(n2, 1);
for i1 = 1 : n2
   % This exploits the fact that calling inM with only 2 indices yields the first dim
   outV(i1) = fHandle(inM(:, i1));
end

outM = reshape(outV, sizeV(2:end));

if iDim > 1
   % Undo dimension shift
   if iDim < n
      newOrderV = [iDim : (n-1), 1 : (iDim-1)];
   else
      newOrderV = 1 : (iDim-1);
   end
   outM = ipermute(outM, newOrderV);
end


%% Output check
if dbg
   outSizeV = sizeInV;
   outSizeV(iDim) = [];
   validateattributes(outM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', outSizeV})
end

end

