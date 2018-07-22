function outV = trim_length(inV, maxLen)

% Convert input to string
if isa(inV, 'cell')
   outV = string(inV);
else
   outV = inV;
end

% Trim 
lengthV = strlength(outV);
idxV = find(lengthV > maxLen);
if ~isempty(lengthV)
   for i1 = idxV(:)'
      outV(i1) = extractBefore(outV(i1), maxLen + 1);
   end
end

% Convert output to cell, if input was cell
if isa(inV, 'cell')
   outV = cellstr(outV);
end

end