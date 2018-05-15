function outV = cell2vector(cellM, dbg)
% Take a cell array of arbitrary matrices of numbers
% Convert to a vector that collects all entries

% No of elements in cellM
nc = numel(cellM);

% Find out how many numbers in cellM
n = 0;
for i1 = 1 : nc
   n = n + numel(cellM{i1});
end

outV = zeros(n, 1);

% Loop over cells
ir = 0;
for i1 = 1 : nc
   n1 = numel(cellM{i1});
   if n1 > 0
      outV(ir + (1 : n1)) = cellM{i1}(:);
      ir = ir + n1;
   end
end


%% Output check
if dbg
   validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n, 1]})
end


end