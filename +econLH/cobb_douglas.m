function [yM, mpkM, mplM] = cobb_douglas(kM, lM, capShare, A, dbg)
% Cobb Douglas production function
%{ 
	yM = A .* kM .^capShare .* lM .^(1-capShare)
IN:
	kM, lM
		Matrices of capital/labor inputs
		Strictly positive
OUT:
	yM
		Output
	mpkM, mplM
		Marginal products of capital/labor
	capShare, A
		parameters
%}

% Input check
if dbg > 10
	validateattributes(capShare, {'double'}, {'real', 'positive', ...
		'nonnan', 'finite', '<', 1, 'scalar'})
end

% Main
yM = A .* kM .^capShare .* lM .^(1-capShare);
mpkM = capShare .* yM ./ kM;
mplM = (1-capShare) .* yM ./ lM;

% Output check
if dbg > 10
	validateattributes(mpkM, {'double'}, {'real', 'positive', ...
		'nonnan', 'finite', 'size', size(kM)})
end


end