function m = m_normalize(mIn, sumValue, sumDim, dbg)
% Normalize a matrix so that "row" i (sumDim-th dimension of the matrix)
% sums to sumV(i)
%{
E.g.: If sumDim == 2
    sum(m(i1,:,i3,i4)) == sumValue

If the input is a vector: simply rescale so that it sums
to sumValue (no matter whether it is a row or column vector)

If any sum equals 0: return NaN for that dimension

IN:
   mIn            Matrix of up to four dimensions
   sumValue       Values the elements should sum to.
   sumDim         Dimension of mIn for which sum equals sumValue

OUT:
   m              
      Normalized matrix
%}

mSizeV = size(mIn);
nDim = length(mSizeV);


%% ***  Input check  ***
if nDim < 1
   error([ mfilename, ': mIn must be a matrix or vector' ]);
end
if nDim > 5
   error([ mfilename, ': Not implemented for more than 5 dimensions' ]);
end
if sumDim > nDim
   error([ mfilename, ':  sumDim > nDim' ]);
end



%%  VECTORS
% Row or column vectors
if isvector(mIn)
   m = mIn ./ sum(mIn) .* sumValue;
   return
end



%% Matrices

if sumDim > 1
   % Shift the right dim to front
   %     cannot use shiftdim b/c it attaches leading singleton dimensions
   orderV = [sumDim : nDim, (1 : (sumDim - 1))];
   shiftM = permute(mIn, orderV);
else
   shiftM = mIn;
end

% Sum over first dim
sum2M = sum(shiftM);

% Divide by sum and multiply by desired sum
m = shiftM ./ repmat(sum2M, [size(shiftM, 1), ones(1, nDim-1)]) .* sumValue;

% Shift back to original order
if sumDim > 1
   m = ipermute(m, orderV);
end



end
