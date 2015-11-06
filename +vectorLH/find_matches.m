function idxV = find_matches(xV, yV, dbg)
% Given vectors x and y, find the position of each x in y
%{
Assumes that elements in yV are unique

Example:
   y = [2, 4, 6]
   x = [4, 1]
   output = [2, NaN]

OUT
   idxV
      such that xV = yV(idxV)
      unless there are non-matches
%}

%% Input check
if dbg > 10
   assert(isequal(length(unique(yV)), length(yV)));
end


%% Main

idxV = nan(size(xV));
for i1 = 1 : length(xV)
   idx1 = find(xV(i1) == yV);
   if ~isempty(idx1)
      idxV(i1) = idx1;
   end
end


%% Output check
if dbg > 10
   if ~any(isnan(idxV))
      assert(isequal(xV, yV(idxV)));
   end
   
   if any(isnan(idxV))
      vIdxV = find(~isnan(idxV));
      if ~isempty(vIdxV)
         assert(isequal(xV(vIdxV),  yV(idxV(vIdxV))));
      end
   end
end


end