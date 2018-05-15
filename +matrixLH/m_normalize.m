function m = m_normalize(mIn, sumValue, sumDim, dbg)
% Normalize a matrix so that "row" i (sumDim-th dimension of the matrix)
% sums to sumV(i)
%{
E.g.: If sumDim == 2
    sum(m(i1,:,i3,i4)) == sumValue

If the input is a vector: simply rescale so that it sums
to sumValue (no matter whether it is a row or column vector)

IN:
   mIn            Matrix of up to four dimensions
   sumValue       Values the elements should sum to.
   sumDim         Dimension of mIn for which sum equals sumValue

OUT:
   m              Normalized matrix

ERRORS:
   Any row sums to zero: Abort

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
if nDim == 1  ||  (nDim == 2  &&  mSizeV(1) == 1)
   if sum(mIn) < 1e-10
      error([ mfilename, ': mIn sums to zero' ]);
   end
   m = mIn ./ sum(mIn) .* sumValue;
   return
end



%% Matrices

% sumM = sum( mIn, sumDim );

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
if any(sum2M(:) < 1e-10)
   error('Sums equal zero');
end

% Divide by sum and multiply by desired sum
m = shiftM ./ repmat(sum2M, [size(shiftM, 1), ones(1, nDim-1)]) .* sumValue;

% Shift back to original order
if sumDim > 1
   m = ipermute(m, orderV);
end
% shiftM = shiftdim(shiftM, 1 - sumDim);


% % Construct a matrix of sums of same size as mIn
% sumM2 = zeros(size(mIn));
% for i1 = 1 : mSizeV(sumDim)
%    if nDim == 5
%       if sumDim == 1
%          sumM2(i1,:,:,:,:) = sumM;
%       elseif sumDim == 2
%          sumM2(:,i1,:,:,:) = sumM;
%       elseif sumDim == 3
%          sumM2(:,:,i1,:,:) = sumM;
%       elseif sumDim == 4
%          sumM2(:,:,:,i1,:) = sumM;
%       elseif sumDim == 5
%          sumM2(:,:,:,:,i1) = sumM;
%       else
%          abort([ mfilename, ': Invalid sumDim' ]);
%       end
% 
%    elseif nDim == 4
%       if sumDim == 1
%          sumM2(i1,:,:,:) = sumM;
%       elseif sumDim == 2
%          sumM2(:,i1,:,:) = sumM;
%       elseif sumDim == 3
%          sumM2(:,:,i1,:) = sumM;
%       elseif sumDim == 4
%          sumM2(:,:,:,i1) = sumM;
%       else
%          abort([ mfilename, ': Invalid sumDim' ]);
%       end
% 
%    elseif nDim == 3
%       if sumDim == 1
%          sumM2(i1,:,:) = sumM;
%       elseif sumDim == 2
%          sumM2(:,i1,:) = sumM;
%       elseif sumDim == 3
%          sumM2(:,:,i1) = sumM;
%       else
%          abort([ mfilename, ': Invalid sumDim' ]);
%       end
% 
%    elseif nDim == 2
%       if sumDim == 1
%          sumM2(i1,:) = sumM;
%       elseif sumDim == 2
%          sumM2(:,i1) = sumM;
%       else
%          abort([ mfilename, ': Invalid sumDim' ]);
%       end
% 
%    else
%       abort([ mfilename, ': Invalid nDim' ]);
%    end
% end
% 
% m = mIn ./ sumM2 .* sumValue;
% 
% 
% checkLH.approx_equal(shiftM, m, 1e-8, []);


%% Output check
if dbg
   validateattributes(m, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(mIn)})
   pSumM = sum(m, sumDim);
   assert(all(abs(pSumM(:)) - sumValue) < 1e-8);
end

end
