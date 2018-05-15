function [kPrime_kV, c_kV, v_kV] = BackwardInduction(uFct, bConstraint, kGridV, vPrime_kjM, prob_jV, dbg)
% Solve a generic backward induction problem of the form
%{
V(k,z) = max u(c) + E V'(k', z')
subject to k' = f(k, z) >= kMin

IN:
   uFct(c)
      utility function handle
   bConstraint
      budget constraint object with methods
      c = getc(k')
      [kMin, kMax] = kPrimeRange(k)
   kGridV
      grid for k' and k
   vPrime_kjM
      V'(k', z') on grid
      includes discount factor
   prob_jV
      Pr(z')

OUT
   kPrime_kV, cPrime_kV
      policy rules; on grid
   v_kV
      value function

Change
   Exploit monotonicity of c(k) to make solution more efficient
   It is much more efficient to solve 
      u'(c(k')) - \beta R E dV(k',z')/dk'
   using interpolation (not fzero!) (similar to the Euler equation code for the Huggett model in
   Econ821)
%}


%% Input check

[nk, nj] = size(vPrime_kjM);

if dbg
   checkLH.prob_check(prob_jV, 1e-6);
   assert(length(prob_jV) == nj);
   validateattributes(kGridV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', ...
      'size', [nk, 1]})
   for j = 1 : nj
      validateattributes(vPrime_kjM(:, j), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing'})
   end
   % Check that utility function works
   tmpM = linspace(1, 3, 4)' * linspace(1, 0.8, 3);
   validateattributes(uFct(tmpM), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(tmpM)})
end


%% Main

% Compute EV' on a grid
eVPrime_kV = sum(vPrime_kjM .* repmat(prob_jV(:)', [nk, 1]), 2);
if dbg
   validateattributes(eVPrime_kV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nk, 1]})
end

% Make EV'(k') as a continuous function
EVPrime = griddedInterpolant(kGridV, eVPrime_kV, 'pchip', 'linear');
if dbg
   evPrimeV = EVPrime(linspace(kGridV(1), kGridV(end), 100));
   validateattributes(evPrimeV, {'double'}, ...
      {'finite', 'nonnan', 'nonempty', 'real', 'increasing'})
   % Check concavity
   assert(all(diff(evPrimeV, 2) <= 1e-3));
end


% Find solution for all k
c_kV = nan(nk, 1);
kPrime_kV = nan(nk, 1);
v_kV = nan(nk, 1);

% Optimizer options
optS = optimset('fminbnd');
optS.TolX = 1e-5;

for ik = 1 : length(kGridV)
   [c_kV(ik), kPrime_kV(ik), v_kV(ik)] = find_solution(kGridV(ik),  EVPrime,  uFct,  bConstraint, optS, dbg);
end


%% Output check
if dbg
   validateattributes(v_kV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing'})
   validateattributes(kPrime_kV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing'})
end


end



%% Solve for solution
%{
IN
   k :: scalar
   EVPrime(k')
      function
   uFct :: utility function
      can call u = uFct(c)
   bConstraint :: budget constraint object
%}
function [c, kPrime, vOut] = find_solution(k,  EVPrime,  uFct,  bConstraint, optS, dbg)

% Get range of feasible k' from budget constraint
[kPrimeLow, kPrimeHigh] = bConstraint.kPrimeRange(k);

% Maximize
[kPrime, exitFlag] = fminbnd(@objective, kPrimeLow, kPrimeHigh, optS);

[v, c] = objective(kPrime);
vOut = -v;

if dbg
   validateattributes([c, kPrime, vOut], {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [1, 3]})
end


%% Nested: objective function
   function [v, cNest] = objective(kPrime)
      cNest = bConstraint.getc(k, kPrime);
      v = -(uFct(cNest) + EVPrime(kPrime));
   end

end