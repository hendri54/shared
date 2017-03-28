function tests = class_assign_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

dbg = 111;
rng(21);

% Test with matrix input
distribLH.class_assign(rand(10, 8), [], linspace(0.3, 1, 3), dbg);


%% Uniform random numbers
if 1
   % classes
   nc = 5;
   clUbV = linspace(0.2, 1, nc);

   % data
   n = 1e4;
   xV  = rand([1,n]);
   wtV = rand([1,n]);
   totalWt = sum(wtV);

   xClV = distribLH.class_assign(xV, wtV, clUbV, dbg);
   validateattributes(xClV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', nc, ...
      'size', [n, 1]})
   
   clProbV = diff([0; clUbV(:)]);
   for ic = 1 : nc
      clProb = sum(wtV(xClV == ic)) ./ totalWt;
      if abs(clProb - clProbV(ic)) > 1e-2
         error('Invalid');
      end
   end
end


%% A few discrete values (with known counts)
% Example does not make sense. Each obs has no unique assignment to a class
if 0
   nc = 4;
   clUbV = linspace(0.2, 1, nc)';   

   % data
   n = 500;
   xV = unidrnd(5, [n, 1]);
   wtV = ones(n, 1);

   xClV = distribLH.class_assign(xV, wtV, clUbV, dbg);
   validateattributes(xClV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', nc, ...
      'size', [n, 1]})
end


%% Test with empty groups
if 1
   clUbV = [0.093; 0.093 + 1e-6; 0.2; 0.5; 1];
   nc = length(clUbV);
   
   n = 100;
   xV = rand([n,1]);
   wtV = ones([n,1]);
   
   xClV = distribLH.class_assign(xV, wtV, clUbV, dbg);
   validateattributes(xClV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', nc, ...
      'size', [n, 1]})

   if sum(xClV == 2) ~= 0
      error('Invalid');
   end
end


end  
