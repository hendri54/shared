function tests = reshape_2d_test

tests = functiontests(localfunctions);

end


%% Test single cases
function oneTest(testCase)
   A = randi(50, [4,3,2]);
   j = 2;
   B = matrixLH.reshape_2d(A, j);
   
   k = 2;
   A2 = A(:,k,:);
   testCase.verifyEqual(sort(B(:,k)),  sort(A2(:)));
end


%% Test several random cases
function randomTest(testCase)
   rng('default');
   for i1 = 1 : 10
      nd = randi(4) + 1;
      j = randi(nd);
      
      sizeV = randi(6, [1, nd]);
      % Cannot have singleton trailing dimensions in a matlab matrix
      sizeV(end) = max(sizeV(end), 2);
      A = randi(50, sizeV);
      
      B = matrixLH.reshape_2d(A, j);
      
      % Check expected size
      nj = sizeV(j);
      nc = round(prod(sizeV) ./ nj);
      testCase.verifyTrue(isequal(size(B),  [nc, nj]));
      
      % Check that each sub-matrix matches
      % Reshape A so that dimension j is last
      A2 = shiftdim(A,  j);
      
      if ~isequal(size(A2, nd),  sizeV(j))
         keyboard;
      end
      assert(size(A2, nd) == sizeV(j));
      
      allEqual = true;
      for k = 1 : sizeV(j)
         switch nd
            case 2
               AM = A2(:,k);
            case 3
               AM = A2(:,:,k);
            case 4
               AM = A2(:,:,:,k);
            case 5
               AM = A2(:,:,:,:,k);
            otherwise
               error('Invalid');
         end
         if ~isequal(sort(B(:,k)), sort(AM(:)))
            allEqual = false;
            break;
         end
      end
      
      testCase.verifyTrue(allEqual);
   end
end