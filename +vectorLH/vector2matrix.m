function outM = vector2matrix(v, tgSizeV, vDim)
% Given a vector of length N, tile it into a matrix of size [a,b,N,c,d]
%{
IN
   v
      vector; can be row or column vector
   tgSizeV
      size of outM
      cannot have trailing singleton dimensions
   vDim
      dimension which v is supposed to occupy
      tgSizeV(vDim) must equal length(v)
%}

nDim = length(tgSizeV);
assert(isequal(tgSizeV(vDim), length(v)));
assert(tgSizeV(nDim) > 1);
assert(length(v) > 1);

% Reshape makes a makes an nDim matrix 
rV = ones(1, nDim);
rV(vDim) = length(v);

repSizeV = tgSizeV;
repSizeV(vDim) = 1;
outM = repmat(reshape(v, rV),  repSizeV);

% if ~isequal(size(outM), tgSizeV)
%    tgSizeV
%    size(outM)
%    keyboard;
% end

assert(isequal(size(outM), tgSizeV))

end