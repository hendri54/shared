function outV = sequential_bounded(inV, n)
% Take an integer >= 1
% Return a bounded integer in [1, n] with "wrap around"
%{
Application: Index a vector. If index too large, wrap around to the start.
%}

outV = mod(inV, n) + (rem(inV, n) == 0) * n;

end