function tests = elasticity_substitution_test

tests = functiontests(localfunctions);

end


%% Cobb Douglas
function cobbDouglasTest(tS)
   n = 3;
   xV = linspace(2, 3, n);
   alphaV = linspace(3, 2, n);
   alphaV = alphaV ./ sum(alphaV);

   check_mproducts(xV, alphaV);

      function mpV = local_mp(xV)
         mpV = mproducts(xV, alphaV);
      end

   i1 = 2;
   i2V = 1 : n;
   i2V(i1) = [];
   elastV = econLH.elasticity_substitution(@local_mp, xV, i1, i2V);
   tS.verifyEqual(elastV, ones(size(i2V)), 'AbsTol', 1e-4);
   
   elast1 = econLH.elasticity_substitution(@local_mp, xV, 2, n-1);
   elast2 = econLH.elasticity_substitution(@local_mp, xV, n-1, 2);
   tS.verifyEqual(elast1, elast2, 'AbsTol', 1e-4);
   
   elastM = econLH.elasticity_substitution(@local_mp, xV, 1 : n, 1 : n);
   for i1 = 1 : n
      elastM(i1,i1) = 1;
   end
   tS.verifyEqual(elastM, ones([n, n]), 'AbsTol', 1e-4);
end


%% CES
function cesTest(tS)
   n = 5;
   substElast = 2.7;
   A = 2.1;
   alphaV = linspace(1, 2, n);
   alphaV = alphaV ./ sum(alphaV);
   xV = linspace(3, 2, n);
   fS = ces_lh(substElast, n,   A, alphaV, xV);
   
   function mpV = local_mp(xV)
      mpV = fS.mproducts(A, alphaV, xV);
   end

   i1 = 2;
   i2V = 1 : n;
   i2V(i1) = [];
   elastV = econLH.elasticity_substitution(@local_mp, xV, i1, i2V);
   tS.verifyEqual(elastV, repmat(substElast, size(i2V)), 'AbsTol', 1e-3);

   elast1 = econLH.elasticity_substitution(@local_mp, xV, 2, n-1);
   elast2 = econLH.elasticity_substitution(@local_mp, xV, n-1, 2);
   tS.verifyEqual(elast1, elast2, 'AbsTol', 1e-4);

   % Entire matrix
   elastM = econLH.elasticity_substitution(@local_mp, xV, 1 : n, 1 : n);
   for i1 = 1 : n
      elastM(i1,i1) = substElast;
   end
   tS.verifyEqual(elastM, repmat(substElast, [n, n]), 'AbsTol', 1e-4);
end



%% Cobb Douglas code
function mpV = mproducts(xV, alphaV)
   mpV = output(xV, alphaV) ./ xV .* alphaV;
end


function y = output(xV, alphaV)
   y = prod(xV .^ alphaV);
end


function check_mproducts(xV, alphaV)
   n = length(xV);
   y = output(xV, alphaV);
   mpV = mproducts(xV, alphaV);

   y2V = zeros(size(mpV));
   dx = 1e-5;
   for i1 = 1 : n
      x2V = xV;
      x2V(i1) = xV(i1) + dx;
      y2V(i1) = output(x2V, alphaV);
   end

   mp2V = (y2V - y) ./ dx;
   checkLH.approx_equal(mp2V, mpV, 1e-4);
end