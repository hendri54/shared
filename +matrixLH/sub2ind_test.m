classdef sub2ind_test < matlab.unittest.TestCase
    
properties (TestParameter)
   % No of matrix dimensions
   nDim = {2, 4, 5};
end

methods (Test)
   function oneTest(tS, nDim)
      rng('default');
      dbg = 111;
      % Size of x matrix
      xSizeV = 3 + (1 : nDim);
      %xM = round(100 .* rand(xSizeV));

      n = 80;
      idxM = zeros([n, nDim]);
      for iDim = 1 : nDim
         idxM(:, iDim) = max(1, round(rand([n, 1]) .* xSizeV(iDim)));
      end

      outV = matrixLH.sub2ind(xSizeV, uint16(idxM), dbg);


      % Compare with direct calculation
      if nDim == 2
         out2V = sub2ind(xSizeV, idxM(:,1), idxM(:,2));
      elseif nDim == 3
         out2V = sub2ind(xSizeV, idxM(:,1), idxM(:,2), idxM(:,3));
      elseif nDim == 4
         out2V = sub2ind(xSizeV, idxM(:,1), idxM(:,2), idxM(:,3), idxM(:, 4));
      elseif nDim == 5
         out2V = sub2ind(xSizeV, idxM(:,1), idxM(:,2), idxM(:,3), idxM(:, 4), idxM(:,5));
      else
         error('Invalid ndim');
      end

      tS.verifyEqual(out2V, outV, 'AbsTol', 1e-8);



%       % *********  speed test
%       if nDim == 5  &&  01
%          disp('Speed test');
%          nTry = 1e4;
% 
%          disp('sub2ind');
%          tic 
%          for i1 = 1 : nTry
%             out2V = sub2ind(xSizeV, idxM(:,1), idxM(:,2), idxM(:,3), idxM(:, 4), idxM(:,5));
%          end
%          toc
% 
%          disp('sub2ind_lh2');
%          tic 
%          for i1 = 1 : nTry
%             % Need to include time to construct index matrix
%             tmpM = [idxM(:,1), idxM(:,2), idxM(:,3), idxM(:,4), idxM(:,5)];
%             outV = sub2ind_lh2(xSizeV, tmpM, 0);
%          end
%          toc
% 
%       end

   end
end
   
end

