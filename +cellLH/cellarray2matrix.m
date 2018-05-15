function outM = cellarray2matrix(cellM, fieldName, dbg)
% Take a cell array of struct. Extract 1 field. Place it into a matrix
%{
Approach
   Make a vector that contains all elements of all fieldName matrices
   Reshape it into a matrix of the right size
   Test that the reshaping has not altered the order of elements

IN
   cellM(n1, ..., nN)
      cell array
      each entry is [] or a struct with field `fieldName`
      fieldName is (m1, ..., mM)
OUT
   outM(m1, ..., mM,  n1, ..., nN)
      NaN when a cellM entry is missing
%}

nV = size(cellM);
n = prod(nV);

outM = [];

% Loop over elements in cell array
for i1 = 1 : n
   if ~isempty(cellM{i1})
      if ~isempty(cellM{i1}.(fieldName))
         if isempty(outM)
            % Allocate output matrix
            mV = size(cellM{i1}.(fieldName));
            outM = nan([mV, nV]);
   %          m = prod(mV);
   %          out2M = nan(n * m, 1);
         end

         % Size must match
         m2V = size(cellM{i1}.(fieldName));
         assert(isequal(m2V, mV));

         % Get indices of first / last elements in this submatrix
         nIdxV = lightspeed.ind2subv(nV, i1);
         idx1  = lightspeed.subv2ind([mV, nV], [ones(1, length(mV)), nIdxV]);
         idx2  = lightspeed.subv2ind([mV, nV], [mV, nIdxV]);

         outM(idx1 : idx2) = cellM{i1}.(fieldName);

   %       idxV = m * (i1-1) + (1 : m);
   %       out2M(idxV) = cellM{i1}.(fieldName);
      end
   end
end

% out2M = reshape(out2M, [mV, nV]);
% 
% checkLH.approx_equal(out2M, outM, 1e-8, []);


%% Output check
if dbg
   validateattributes(outM, {'double'}, {'real', 'size', [mV, nV]})
end


end