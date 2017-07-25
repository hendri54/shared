function [outS, id1V, id2V] = table_to_2d_array(tbM, id1, id2, varNameV)
% Given a table with 2 numeric identifiers, x, and y
% and a list of variable names
% make a set of 2D matrices, each containing one variable by [x,y]
%{
If a single char is provided in varNameV, output is a single matrix

IN
   tbM  ::  table
      contains variables given in id1, id2, varNameV
   id1, id2  ::  char
      variables that are the 2 ids that index each output matrix
   varNameV  ::  cell
      each variable name becomes a matrix in outS

OUT
   outS  ::  struct
      contains one matrix, indexed by [id1, id2], for each variable in varNameV
   id1V, id2V  ::  double
      sorted values that go with rows and columns of output matrices
%}

if isa(varNameV, 'char')
   returnOneMatrix = true;
   varNameV = {varNameV};
else
   returnOneMatrix = false;
end


% List of id's. Sorted
id1V = unique(tbM.(id1));
id2V = unique(tbM.(id2));
n1 = length(id1V);
n2 = length(id2V);


% Convert ids to indices
[~, idx1V] = ismember(tbM.(id1), id1V);
[~, idx2V] = ismember(tbM.(id2), id2V);
assert(all(idx1V >= 1));
assert(all(idx2V >= 1));

% Make sure each (id1, id2) combination occurs only once
assert(isequal(size(unique([idx1V(:), idx2V(:)], 'rows'), 1),  length(idx1V)));

% Row ir now becomes outM(idx1V(ir), idx2V(ir))
idxV = sub2ind([n1, n2], idx1V, idx2V);

nv = length(varNameV);
outS = struct;


%% Loop over variables
for iv = 1 : nv
   outM = nan(n1, n2);
   outM(idxV) = tbM.(varNameV{iv});
   assert(isequal(size(outM),  [n1, n2]));

   if returnOneMatrix
      outS = outM;
   else
      outS.(varNameV{iv}) = outM;
   end
end

end