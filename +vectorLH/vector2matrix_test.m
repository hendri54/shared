function tests = vector2matrix_test
   tests = functiontests(localfunctions);
end

function oneTest(testCase)
   % Settings
   dbg = 111;
   rng('default');
   
   % Make many random test cases
   for iTest = 1 : 50
      vLen = 1 + randi(7, [1,1]);
      nDim = randi([2, 5], [1,1]);
      tgSizeV = randi(8, [1, nDim]);
      % Cannot have trailing singleton dimensions
      tgSizeV(nDim) = max(2, tgSizeV(nDim));
      vDim = randi(nDim, [1,1]);

      % Vector to be replicated
      v = (2 + (1 : vLen));
      v = v(randperm(vLen));
      tgSizeV(vDim) = vLen;

      outM = vectorLH.vector2matrix(v, tgSizeV, vDim);

      % Extract elements and check that they are correct
      % Loop over elements of v
      for i1 = 1 : vLen
         % Loop over random elements
         for j = 1 : 20
            % Random indices into outM, but pulling out element i1
            idxV = zeros(1, nDim);
            for iDim = 1 : nDim
               idxV(iDim) = randi(tgSizeV(iDim), [1,1]);
            end
            idxV(vDim) = i1;

            % Get that element
            idx1 = sub2ind_lh2(tgSizeV, idxV, dbg);
            assert(isequal(outM(idx1),  v(i1)));
         end
      end   
   end
end

