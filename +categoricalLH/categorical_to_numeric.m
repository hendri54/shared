% Convert a categorical vector into a numeric one
%{
IN
   inV  ::  categorical
      with numeric categories
OUT
   outV  ::  double
      outV(i1) = numeric value of category of inV(i1)
%}
function outV = categorical_to_numeric(inV)

catV = categories(inV);
outV = nan(size(inV));

for i1 = 1 : length(catV)
   catValue = str2double(catV{i1});
   assert(~isnan(catValue)  &&  isscalar(catValue));
   idxV = find(inV == catV{i1});
   if ~isempty(idxV)
      outV(idxV) = catValue;
   end
end

end
