function [xV, yM] = xy_to_common_base(xyV, dbg)
% Given a set of (x,y) vectors of different dimensions
% Produce a single x vector and a yM matrix such that
% [x, yM(:,j)] match the j-th (x,y) combination
%{
IN
   xyV :: cell vector
      each contains fields xV, yV
      xV are integer vectors with unique elements

OUT
   xV  ::  integer
      vector that ranges from min to max of all x vectors
   yM  ::  double
      yM(j,k) is the element in the k-th y vector that goes with xV(j)
%}


%% Input check

n = length(xyV);

if dbg > 10
   for i1 = 1 : n
      validateattributes(xyV{i1}.xV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer'})
      assert(length(unique(xyV{i1}.xV)) == length(xyV{i1}.xV),  'Values in x vectors must be unique');
   end
end


%% Find the range of x's spanned

xMin = min(xyV{1}.xV);
xMax = max(xyV{1}.xV);

for i1 = 2 : n
   xMin = min(xMin, min(xyV{i1}.xV));
   xMax = max(xMax, max(xyV{i1}.xV));
end

xV = (xMin : xMax)';


%% Index each vector to match xV

yM = nan(length(xV), n);
for i1 = 1 : n
   xIdxV = xyV{i1}.xV(:) - xV(1) + 1;
   yM(xIdxV, i1) = xyV{i1}.yV(:);
end


end