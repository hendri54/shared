function [hM, lM, wageM, earnM] = solve(bpS, h1V, pProductV, dbg)
% Solve Ben-Porath model, given h1, w(t), production function parameters
%{
Uses generalization of Huggett/Ventura/Yaron (JME 2006) closed form
solution that allows for time varying wages

h(t+1) = (1-ddh) h(t) + pProduct * (h(t) l(t)) ^ pAlpha

Assumption:
- alpha = beta

Corners: 
   simply set training time to max, but not imposed in the computation of h
   this should keep results continuous in parameters, but it yields the
   wrong results if the constraints ever bind!

This must be efficient


IN:
   h1V
      h(1), by person
   pProductV
      productivity parameter, includes ability and A
      by person
   bpS
      BenPorathLH object with params

OUT:
   hM(i, t)
      age profiles of all individuals i
      age 1 is first age of work
   lM
      study times
   wageM
      observed wage per unit of market time
   earnM
      wage * time endowment

Test: t_solve

Change:
%}


%%  Input check

n = length(h1V);
T = length(bpS.wageV);
ddh = bpS.ddh;
pAlpha = bpS.pAlpha;

if dbg > 10
   % Check BP parameters
   bpS.validate;
end



%%  Precompute values that are common to all agents

ddhV = (1 - ddh) .^ (0 : (T-1))';
RV   = bpS.R .^ (0 : (T-1))';

% The sum of these terms forms HVY's A(age)
%  The wage growth rate appears b/c model wages are detrended
discV = ddhV ./ RV;

C1 = pAlpha ./ bpS.R;
wlV = bpS.wageV .* bpS.tEndowV;

dV = zeros([T, 1]);
xV = zeros([T, 1]);
for t = 1 : (T-1)
   dV(t) = C1 ./ bpS.wageV(t) .* sum(wlV(t+1 : T) .* discV(1 : (T-t)));
   
   xV(t+1) = sum(dV(1 : t) .^ (pAlpha ./ (1-pAlpha))  .*  ddhV(t : -1 : 1));
end



%%  Individual specific

AV = (pProductV(:) .^ (1/(1-pAlpha)));

hM = h1V(:) * ddhV'  +  AV * xV';
if any(hM(:) > bpS.hMax)
   hM = min(hM, bpS.hMax);
end


lM = (AV * (dV' .^ (1 / (1-pAlpha)))) ./ hM;

% This line is expensive
%l2M = (pProductV(:) * dV') .^ (1 / (1-pAlpha)) ./ hM;
% if max(abs(l2M(:) - lM(:)) > 1e-8)
%    error('wrong');
% end

tEndowM = ones([n,1]) * bpS.tEndowV(:)';

% Cut of when corners are hit
lM = min(lM,  bpS.trainTimeMax * tEndowM);

earnM = hM .* (tEndowM - lM) .* (ones([n,1]) * bpS.wageV(:)');
wageM = earnM ./ tEndowM;



% Present value, discounted to work start
%pvLty = sum((cS.R .^ (0 : -1 : (1-T)))' .* hV .* (bpS.tEndowV - lV) .* bpS.wageV);


%% *****  Self-test
if dbg > 10
   validateattributes(hM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', [n, T]})
   validateattributes(lM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      'size', [n, T]})
end

end