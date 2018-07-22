function sIdxV = rand_sample(n, nSample, dbg)
% Given n observations, extract a random sample of length nSample
%{
OUT:
   idxV  ::  uint64
      xV(idxV) is the random sample of length nSample
%}

%% Input check

assert(nargin >= 2);
assert(nSample <= n);
assert(nSample > 0);


%% Main

if nSample == n
   sIdxV = uint64(1 : nSample);
else
   sIdxV = uint64(find(randperm(n) <= nSample));
end

validateattributes(sIdxV, {'uint64'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', '<=', n})

end