function tests = reindex_2d_test

tests = functiontests(localfunctions);

end

%% All indices are present
function simpleTest(testCase)
   rng('default');
   
   xTgV = 2 : 2 : 14;
   yTgV = 1 : 3 : 9;
   nx = length(xTgV);
   ny = length(yTgV);
   dataM = randi(100, [nx, ny]);
   
   xIdxV = 2 : 2 : nx;
   xV = xTgV(xIdxV);
   yIdxV = 1 : 2 : ny;
   yV = yTgV(yIdxV);
   
   inM = dataM(xIdxV, yIdxV);
   outM = matrixLH.reindex_2d(inM, xV, yV, xTgV, yTgV);
   
   testCase.verifyEqual(dataM(xIdxV, yIdxV), outM(xIdxV, yIdxV));
end


%% Case where some indices are dropped
function dropTest(testCase)
   xAllV = 2 : 2 : 20;
   yAllV = 3 : 3 : 29;
 
   xTgIdxV = 3 : 2 : (length(xAllV));
   yTgIdxV = 4 : 3 : (length(yAllV));
   xTgV = xAllV(xTgIdxV);
   yTgV = yAllV(yTgIdxV);
   
   xIdxV = 1 : 3 : (length(xAllV) - 2);
   yIdxV = 2 : 2 : (length(yAllV) - 1);
   inM = randi(100, [length(xIdxV), length(yIdxV)]);
   xV = xAllV(xIdxV);
   yV = yAllV(yIdxV);
   
   outM = matrixLH.reindex_2d(inM, xV, yV, xTgV, yTgV);
   
   for ix = 1 : length(xTgV)
      xIdx = find(xV == xTgV(ix));
      if isempty(xIdx)
         assert(all(isnan(outM(ix,:))));
      else
         for iy = 1 : length(yTgV)
            yIdx = find(yV == yTgV(iy));
            if isempty(yIdx)
               assert(isnan(outM(ix,iy)));
            else
               assert(isequal(outM(ix,iy),  inM(xIdx,yIdx)));
            end
         end
      end
   end

end