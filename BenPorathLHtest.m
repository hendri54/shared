function BenPorathLHtest
% Test solving Ben-Porath model
%{
%}

fprintf('\nTesting Ben-Porath solution\n');

dbg = 111;


%% Set up Ben-Porath model
% For test to go through, study time must be interior

n = 3;
T = 45;

wV  = linspace(1.2, 1.4, T)';
tEndowV = linspace(1.9, 1.1, T)';
pAlpha = 0.35;
ddh = 0.04;
A = 0.4;
R = 1.04;      

if 0
   disp('Simple special case');
   R = 1;
   ddh = 0;
   tEndowV = ones([T, 1]);
   wV = ones([T, 1]);
end

trainTimeMax = 0.8;
hMax = 100;

bpS = BenPorathLH(wV, tEndowV, pAlpha, ddh, A, R, trainTimeMax, hMax);

trainTimeMax_itM = ones([n,1]) * bpS.tEndowV(:)' * trainTimeMax;


%% Solve

h1V = linspace(2, 3, n)';
pProductV = 0.25 .* linspace(0.25, 0.14, n)';
[hM, lM] = bpS.solve(h1V, pProductV, dbg);

if any(hM(:) > bpS.hMax - 1e-5)
   error('h hits upper bound');
end
if any(lM(:) > trainTimeMax_itM(:) - 1e-5)
   error('l hits upper bound');
end


%% Check against guess for lh
% From guess and verify solution
if 1
   for t = 1 : (T-1)
      tRemainV = (t+1) : T;
      tRemain = length(tRemainV);
      C1 = bpS.pAlpha ./ bpS.R ./ bpS.wageV(t);
      discV = ((1 - bpS.ddh) ./ bpS.R) .^ (0 : (tRemain-1));
      d1 = C1 .* sum(bpS.wageV(tRemainV) .* bpS.tEndowV(tRemainV) .* discV(:));
      rhsV = (pProductV .* d1) .^ (bpS.pAlpha ./ (1 - bpS.pAlpha));
      lhsV = (hM(:,t) .* lM(:,t)) .^ bpS.pAlpha;
      diffV = rhsV - lhsV;
      if any(abs(diffV) > 1e-4)
         error('Guess not satisfied');
      end
   end
end



%%  Check scaling
% This catches when the hMax constraint binds. Not an error, of course.
if 1
   xFactor = 1.2;
   h1NV = h1V .* xFactor;
   pProductNV = pProductV .* (xFactor ^ (1 - bpS.pAlpha));
   [hNM, lNM] = bpS.solve(h1NV, pProductNV, dbg);

   hDiffM = hNM - xFactor .* hM;
   lDiffM = lNM - lM;
   if any(abs(hDiffM(:)) > 1e-4)  ||  any(abs(lDiffM(:)) > 1e-4)
      error('Wrong scaling');
   else
      disp('Scaling ok');
   end
end



%%  Check law of motion
if 1
   iInd = 1;
   h2V = zeros([T+1, 1]);
   h2V(1) = hM(iInd, 1);
   h2V(2 : (T+1)) = bpS.hprime(hM(iInd,:)', lM(iInd,:)', pProductV(iInd), dbg);
   h2V(T+1) = [];
   
   hDiffV = h2V - hM(iInd, :)';
   if max(abs(hDiffV ./ h2V)) > 1e-5
      warning('Law of motion violated');
      keyboard;
   else
      disp('Law of motion is fine');
   end
end



%%  Test optimality: perturb study time path
if 01
   iInd = 1;
   [hV, lV] = bpS.solve(h1V(iInd), pProductV(iInd), dbg);
   
   % For computing present value of earnings
   dFactorV = (1 ./ bpS.R) .^ (1 : T)';
   
   % Age at which lV is changed
   dAge = 10;
   % Amount by which lV is changed up or down
   dlV = -0.03 : 0.01 : 0.03;
   pvV = zeros(size(dlV));
   
   fprintf('Perturbing study time at age %i \n', dAge);

   for i1 = 1 : length(dlV)
      l2V = lV;
      l2V(dAge) = l2V(dAge) + dlV(i1);
      
      h2V = bpS.hpath(hV(1), l2V, pProductV(iInd), dbg);
         
      % Present value of earnings under optimal policy
      earnV = bpS.earnings(h2V(:)', l2V(:)', dbg);
      pvV(i1) = sum(earnV(:) .* dFactorV(:));
      
      %fprintf('  dl = %6.3f   l = %6.3f    pv = %8.4f \n',  dlV(i1), l2V(dAge), pvV(i1));
   end
   
   [~, maxIdx] = max(pvV);
   if maxIdx ~= find(dlV == 0)
      error('Solution not optimal');
   else
      disp('Optimality ok');
   end
end



%%  Solve for many
% For profiling
if true
   n = 1e3;
   h1V = linspace(1, 2, n);
   pProductV = linspace(0.5, 2, n);
   
   fprintf('Solving for %i households \n', n);
   tic
   bpS.solve(h1V, pProductV, dbg);
   toc
end


end