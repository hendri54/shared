function prob_check(xM, probTol)
% Check that a vector or matrix contains valid probabilities
%{
IN
   probTol :: Double
      when checking whether probs sum to 1 (by column!)
      what is the tolerance permitted?
      may be []
%}

validateattributes(xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1})

if ~isempty(probTol)
   % This automatically handles vectors correctly
   prSumV = sum(xM);
   if any(abs(prSumV(:) - 1) > probTol)
      pMin = min(prSumV(:));
      pMax = max(prSumV(:));
      error('Probs do not sum to 1.  Range %f to %f', pMin, pMax);
   end
end


end