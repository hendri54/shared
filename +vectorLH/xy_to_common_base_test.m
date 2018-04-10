function tests = xy_to_common_base_test
   tests = functiontests(localfunctions);
end


function oneTest(tS)
   % Make inputs
   dbg = 111;
   rng('default');
   n = 4;
   xV = 43 : 62;
   
   xyV = cell(n, 1);
   for k = 1 : n
      xyV{k} = struct;
      xyV{k}.xV = xV(k : k : length(xV));
      xyV{k}.yV = randi(100, size(xyV{k}.xV));
   end
   
   [x2V, yM] = vectorLH.xy_to_common_base(xyV, dbg);
   
   % Check
   % Loop over dimensions
   for k = 1 : n
      xkV = xyV{k}.xV;
      % Loop over elements
      for i1 = 1 : length(xkV)
         xIdx = find(x2V == xkV(i1));
         assert(length(xIdx) == 1);
         assert(isequal(yM(xIdx, k),  xyV{k}.yV(i1)));
      end
   end
end