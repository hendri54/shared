function idxV = find_strings(toFindV, cellV)
% Find strings in cell array
%{
NaN for strings that are not found
Case sensitive

IN:
   toFindV  ::  cell or char
      strings to find
OUT:
   idxV  ::  integer
      indices for each string in cellV
      NaN if not found
%}

if isempty(toFindV)  ||  isempty(cellV)
   idxV = [];
   return;
end

if ischar(toFindV)
   toFindV = {toFindV};
end

idxV = nan(size(toFindV));
for i1 = 1 : length(toFindV)
   idx1 = find(ismember(cellV, toFindV{i1}));
   if idx1 > 0
      idxV(i1) = idx1;
   end
end

end