function tests = rescale_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   inV = [3.3, 1.2, 2.1, 4.9];
   xMin = 3.1;
   xMax = 6.3;
   outV = vectorLH.rescale(inV, xMin, xMax, true);
   
   tS.verifyTrue(all(outV >= xMin));
   tS.verifyTrue(all(outV <= xMax));
   tS.verifyEqual([xMin, xMax],  [min(outV), max(outV)],  'AbsTol', 1e-10);
   
   sortM = sortrows([inV(:), outV(:)]);
   tS.verifyTrue(all(diff(sortM(:,2)) > 0));
end