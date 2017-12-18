function tbM = struct2table(inV, nDigits, onlyCommonFields)
% Make table out of cell array of struct (or user defined objects)
%{
Only keep "small" fields
All structs must contain the same class for each field

IN
   inV  ::  cell array of struct
   nDigits  ::  integer
      number of digits to display
      e.g. with nDigits = 4, 12.34567 becomes '12.34'
   onlyCommonFields  ::  logical
      keep only fields common to all struct?
OUT
   tbM  ::  table
      each row is a struct; each column is a field
%}


% Handle a single struct
if ~isa(inV, 'cell')
   assert(length(inV) == 1);
   inV = {inV};
end


%% Get all field names

[fCommonV, fAllV] = structLH.field_names(inV);

if onlyCommonFields
   fnV = fCommonV;
else
   fnV = fAllV;
end


% tbM = table;
% for i1 = 1 : length(fnV)
%    xV = [];
%    for i_t = 1 : length(inV)
%       if isfield(
%    end
% end


%% Make a cell array from each struct

n = length(inV);
nf = length(fnV);
cellM = cell(nf, n + 1);
% tbM = table;

% Structure name (just its sequence number)
varNameV = stringLH.vector_to_string_array((0 : n)',  'S%i');
varNameV{1} = 'Variable';

% Add each variable
for i1 = 1 : length(fnV)
   fName = fnV{i1};
   cellM{i1, 1} = fName;
   
   % Loop over each table
   for i_t = 1 : n
      valueOut = one_field(inV{i_t}, fName, nDigits);
      cellM{i1, i_t + 1} = valueOut;
   end
end

tbM = cell2table(cellM, 'VariableNames', varNameV);


end



% %% Handle on struct
% %{
% OUT
%    tbM  ::  table
% %}
% function tbM = one_struct(inS, fnV)
%    tbM = table;
%    % fnV = fieldnames(inS);
%    for i1 = 1 : length(fnV)
%       % Handle one field
%       valueOut = one_field(inS, fnV{i1});
%       tbM.(fnV{i1}) = valueOut;
%    end
% end


%% Handle one field
%{
Values that are too large in dimension get codes
[] means value is not numeric or char
%}
function valueOut = one_field(inS, nameStr, nDigits)
   if ~ismember(nameStr, fieldnames(inS))
      valueOut = [];
      return;
   end
   valueOut = inS.(nameStr);
   
   if isnumeric(valueOut)
      if numel(valueOut) > 3
         valueOut = [];
      else
         fmtStr = ['%.', sprintf('%ig, ', nDigits)];
         valueOut = sprintf(fmtStr, valueOut);
         valueOut(end-1 : end) = [];
      end
   elseif ischar(valueOut)
      if length(valueOut) > 10
         valueOut = valueOut(1:10);
      end
   else
      valueOut = [];
   end
end