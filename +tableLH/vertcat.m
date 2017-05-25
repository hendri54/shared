function tbM = vertcat(tbV, varNameInV)
% vertcat for several tables
%{
Only keep fields that are common to all tables  OR
Only keep fields provided in varNameV

IN
   tbV  ::  cell
   varNameV  ::  cell
      optional
%}

nt = length(tbV);
if nt == 1
   % Only 1 table provided. Nothing to do.
   tbM = tbV{1};
   return;
end


%% Find variable names to keep

if isempty(varNameInV)
   varNameV = tbV{1}.Properties.VariableNames;
   for i1 = 2 : nt
      varNameV = intersect(varNameV, tbV{i1}.Properties.VariableNames);
      assert(~isempty(varNameV));
   end
else
   varNameV = varNameInV;
end


%% Concatenate

% Find no of rows in each table
nV = zeros(nt, 1);
for i1 = 1 : nt
   nV(i1) = size(tbV{i1}, 1);
end
nObs = sum(nV);

% Preallocate using the first table's first row
tbM = repmat(tbV{1}(1, find(ismember(tbV{1}.Properties.VariableNames, varNameV))),  [nObs, 1]);
idxLast = 0;

for i1 = 1 : nt
   idxV = idxLast + (1 : nV(i1));
   idxLast = idxLast + nV(i1);
   tbM(idxV,:) = tbV{i1}(:, find(ismember(tbV{i1}.Properties.VariableNames, varNameV)));
end

assert(isequal(size(tbM), [nObs, length(varNameV)]));

end