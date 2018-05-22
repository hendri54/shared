function tests = m_normalize_test
   tests = functiontests(localfunctions);
end


%%  2 dimensional matrix 
function twoDTest(tS)
   dbg = 111;
   rng(23);

   mSizeV = [4,3];

   mIn = rand(mSizeV);
   sumValue = 100;

   for sumDim = 1 : 2
      m = matrixLH.m_normalize(mIn, sumValue, sumDim, dbg);

      % check that sums are correct
      sumV = sum(m, sumDim);
      tS.verifyEqual(sumV(:), repmat(sumValue, size(sumV(:))), 'AbsTol', 1e-6);

      % Check that ratios are correct
      if sumDim == 1
         colRatioInM = mIn(2:end,:) ./ mIn(1:end-1,:);
         colRatioM   = m(2:end,:)   ./ m(1:end-1,:);
         devM = colRatioInM ./ colRatioM - 1;
         tS.verifyTrue(all(abs(devM(:)) < 1e-5));
      end
   end
end


%% 3 dimensional matrix
function threeDTest(tS)
   dbg = 111;
   rng(23);
   mSizeV = [4,3,2];
   mIn = rand(mSizeV);
   sumValue = 100;

   for sumDim = 1 : 3
      m = matrixLH.m_normalize(mIn, sumValue, sumDim, dbg);

      valid = true;
      for i2 = 1 : mSizeV(2)
         for i3 = 1 : mSizeV(3)
            % Check that the sums match
            vSum = sum( m, sumDim );
            if abs(vSum - sumValue) > 1e-7
               fprintf('Error:  %i %i   %f  %f \n', i2, i3, vSum, sumValue);
               valid = false;
            end

            % Check that the ratios are all equal
            if sumDim == 1
               vRatio = m(:,i2,i3) ./ mIn(:,i2,i3);
               vDiff  = vRatio ./ vRatio(1) - 1;
               if max(abs(vDiff)) > 1e-5
                  fprintf('Error 2:  %i %i   %f \n', i2, i3, vRatio);
                  valid = false;
               end
            end
         end
      end
      tS.verifyTrue(valid);
   end
end



%%  4 DIMENSIONS
function fourDTest(tS)
   dbg = 111;
   rng('default');
   mSizeV = [5,4,3,2];
   sumValue = 100;
   mIn = rand(mSizeV);

   for sumDim = 1 : 4
      m = matrixLH.m_normalize(mIn, sumValue, sumDim, dbg);
   end
end
