function outV = sub2ind_lh2(xSizeV, idxM, dbg)
% Replacement for sub2ind. Faster
%{
% IN:
%  size of data matrix, up to 6 dim
%  idxM
%     column vectors with indices
      may be integer type

% OUT:
%  outV (double)
%     xM(outV(i1)) = xM(idxM(i1,1), ..., idxM(i1, 5))

% Based on http://tipstrickshowtos.blogspot.com/2010/02/fast-replacement-for-sub2ind.html
%}
% ------------------------------------

%xSizeV = size(xM);
nDim = length(xSizeV);
iSizeV = size(idxM);

if iSizeV(2) ~= nDim
   error('Wrong index dimension');
end

if dbg > 10
   for iDim = 1 : nDim
      if any(idxM(:,iDim) < 1)  ||  any(idxM(:,iDim) > xSizeV(iDim))
         error('Invalid idxM');
      end
   end
end


% One could write general code here, but that would be slower
cumSizeV = cumprod(xSizeV);
if nDim == 2
   outV = double(idxM(:,1)) + double(idxM(:,2)-1) * xSizeV(1);
elseif nDim == 3
   outV = double(idxM(:,1)) + double(idxM(:,2)-1) * xSizeV(1) + double(idxM(:,3)-1) * cumSizeV(2);
elseif nDim == 4
   outV = double(idxM(:,1)) + double(idxM(:,2)-1) * xSizeV(1) + double(idxM(:,3)-1) * cumSizeV(2) + ...
      double(idxM(:,4)-1) * cumSizeV(3);
elseif nDim == 5
   outV = double(idxM(:,1)) + double(idxM(:,2)-1) * xSizeV(1) + double(idxM(:,3)-1) * cumSizeV(2) + ...
      double(idxM(:,4)-1) * cumSizeV(3) + double(idxM(:,5)-1) * cumSizeV(4);
elseif nDim == 6
   outV = double(idxM(:,1)) + double(idxM(:,2)-1) * xSizeV(1) + double(idxM(:,3)-1) * cumSizeV(2) + ...
      double(idxM(:,4)-1) * cumSizeV(3) + double(idxM(:,5)-1) * cumSizeV(4) + double(idxM(:,6)-1) * cumSizeV(5);
else
   error('Invalid dimension');
end





end