function tbM = struct2table(inV, onlyCommonFields)
% Make table out of cell array of struct (or user defined objects)
%{
Only keep "small" fields
All structs must contain the same class for each field

IN
   inV  ::  cell array of struct
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


%% Make a table from each struct

n = length(inV);
tbM = table;

% Structure name (just its sequence number)
tbM.Structure = stringLH.vector_to_string_array((1 : n)',  'S%i');

% Add each variable
for i1 = 1 : length(fnV)
   fName = fnV{i1};
   found = false;
   % Loop over each table
   for i_t = 1 : n
      valueOut = one_field(inV{i_t}, fName);
      if ~isempty(valueOut)
         if ~found
            found = true;
            if isnumeric(valueOut)
               tbM.(fName) = nan(n, 1);
            elseif ischar(valueOut)
               tbM.(fName) = cell(n, 1);
            end
         end
         
         if isnumeric(valueOut)
            tbM.(fName)(i1) = valueOut;
         elseif ischar(valueOut)
            tbM.(fName){i1} = valueOut;
         else
            error('Invalid');
         end
      end
      
%       fName
%       valueOut
%       keyboard;
   end
end

% 
% for i1 = 1 : n
%    tb2M = one_struct(inV{i1}, fnV);
%    tb2M.name = sprintf('Tb%i', i1);
%    tbM = join(tbM, tb2M, 'Keys', 'Name');
% end
% 
% % Join the tables
% tbM = tbV{i1};
% for i1 = 2 : n
%    if onlyCommonFields
%       tbM = innerjoin(tbM, tbV{i1}
%    else
%    end
% end

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
function valueOut = one_field(inS, nameStr)
   if ~ismember(nameStr, fieldnames(inS))
      valueOut = [];
      return;
   end
   valueOut = inS.(nameStr);
   
   if isnumeric(valueOut)
      if numel(valueOut) > 3
         valueOut = [];
      end
   elseif ischar(valueOut)
      if length(valueOut) > 10
         valueOut = valueOut(1:10);
      end
   else
      valueOut = [];
   end
end