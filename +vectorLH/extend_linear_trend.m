function outV = extend_linear_trend(inV, g1, g2, dbg)
% Given a vector inV of length T
% Find the first non-Nan value and extend into the "past" at per period change g1
% Find the last non-Nan value and extend into the "future" at per period change g2
%{
Useful for constant growth extrapolation in logs
%}

outV = inV;
T = length(inV);

%% Input check
if dbg > 10
   validateattributes(g1, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   validateattributes(g2, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end


%% Main

idxV = find(~isnan(inV));

% At the front
if idxV(1) > 1
   % Values to be filled
   idx1V = 1 : idxV(1);
   T1 = length(idx1V);
   outV(idx1V) = inV(idxV(1)) + (g1 .* (-(T1-1) : 0));
end

% Into the future
if idxV(end) < T
   idx2V = idxV(end) : T;
   T2 = length(idx2V);
   outV(idx2V) = inV(idxV(end)) + (g2 .* (0 : (T2-1)));
end


%% Self-test
if dbg > 10
   validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(inV)})
end

end