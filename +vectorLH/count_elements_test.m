function tests = count_elements_test
   tests = functiontests(localfunctions);
end

function oneTest(testCase)
   rng('default');
   
   % Max inV
   nMax = 10;
   n = 30;
   inV = randi(nMax, [n,1]);

   % Max element to be found
   maxElem = max(inV);
   
   % All elements in vector
   run_one(inV, maxElem)
   
   % Not all elements in vector
   run_one(inV, maxElem + 1)
end


function run_one(inV, maxElem)
   % Ensure that maxElem is actually in vector
   nElem = 4;
   elemV = randi(maxElem, [nElem, 1]);
   if all(elemV < maxElem)
      elemV(nElem - 2) = maxElem;
   end
   
   cntV = vectorLH.count_elements(inV, elemV);
   
   for i1 = 1 : length(elemV)
      assert(isequal(cntV(i1),  sum(inV == elemV(i1))));
   end
end