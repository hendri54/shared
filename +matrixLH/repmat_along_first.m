function z = repmat_along_first(x, n)
% Replicate a matrix such that z(j,:,:) = x

sizeV = size(x);
nd = length(sizeV);

z = permute(repmat(x, [ones(1, nd), n]), [nd+1, 1 : nd]);


end

