function outV = guess_extract(guessV, lbV, ubV, optS)
% Extract guesses scaled by guess_make_lh
% ---------------------------------------

% Default options
if ~isfield(optS, 'guessMin')
   guessMin = 1;
   guessMax = 2;
else
   guessMin = optS.guessMin;
   guessMax = optS.guessMax;
end
if ~isfield(optS, 'dbg')
   dbg = 0;
else
   dbg = optS.dbg;
end
if ~isfield(optS, 'rescale')
   rescale = true;
else
   rescale = optS.rescale;
end

% *****  Input check
if dbg > 10
   if any(ubV <= lbV)
      error('bounds invalid');
   end
   if any(guessV(:) < guessMin - 1e-6)
      error('guesses too low');
   end
   if any(guessV(:) > guessMax + 1e-6)
      error('guesses too high');
   end
end

if rescale
   guessV = min(guessMax, max(guessMin, guessV));
end

% Unscale guesses
%  inputs are scaled to lie between 1 and 2 (for solver benefit)
outV = lbV  +  (guessV(:) - guessMin) .* (ubV - lbV) ./ (guessMax - guessMin);

end