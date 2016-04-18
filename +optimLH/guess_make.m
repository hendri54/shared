function outV = guess_make(guessV, lbV, ubV, optS)
% Take an input vector. Transform it so that acceptable values are 
% mapped into a fixed interval
%{
IN
   optS
      rescale
         rescale when out of bounds
         default: 1
      guessMin, guessMax
         range of scaled guesses
%}
% ------------------------------------------------------------

% ******  Set options
if ~isfield(optS, 'rescale')
   rescale = true;
else
   rescale = optS.rescale;
end
if ~isfield(optS, 'guessMin')
   guessMin = 1;
   guessMax = 2;
else
   guessMin = optS.guessMin;
   guessMax = optS.guessMax;
end

if any(guessV < lbV)  ||  any(guessV > ubV)
   if rescale
      guessV = max(lbV, min(ubV, guessV));
   else
      error('Guesses out of bounds');
   end
end

% Scale all guesses to lie between 1 and 2
outV = guessMin + (guessV - lbV) .* (guessMax - guessMin) ./ (ubV - lbV);


end