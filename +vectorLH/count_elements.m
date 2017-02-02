function cntV = count_elements(inV, elemV)
% Count how often each INTEGER element in elemV occurs in inV
%{
Could be inefficient when elemV is not sequential and contains large numbers
%}

% Count sequential elements
cnt1V = accumarray(inV, 1);

maxElem = max(elemV);

n = length(cnt1V);

if n > maxElem
   % All elemV were counted
   cntV = cnt1V(elemV);
else
   % These were counted. The rest occurred 0 times
   idxV = find(elemV <= n);
   cntV = zeros(size(elemV),  class(inV));
   if ~isempty(idxV)
      cntV(idxV) = cnt1V(elemV(idxV));
   end
end

validateattributes(cntV, {class(inV)}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 0, 'size', size(elemV)})


end