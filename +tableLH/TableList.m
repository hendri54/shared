% List of tables
%{
Add: add tables sequentially +++
%}
classdef TableList < handle
      
properties
   % List of tables to process
   tbV  cell
   % No of tables
   nt  uint16
end

methods
   %% Constructor
   %{
   IN
      at least 2 tables followed by options (name-value pairs)
      list of tables can be passed as cell array
   %}
   function tS = TableList(varargin)
      if isa(varargin{1}, 'cell')
         % Input is a cell array of tables
         tS.tbV = varargin{1};
         tS.nt = length(tS.tbV);
         
         if length(varargin) > 1
            error('Too many inputs');
         end
      else
         % Tables are provided as separate inputs
         classV = cell(nargin, 1);
         % Number of tables
         tS.nt = 0;
         foundTables = false;
         for i1 = 1 : nargin
            classV{i1} = class(varargin{i1});
            if strcmpi(classV{i1}, 'table')
               assert(~foundTables);
               tS.nt = tS.nt + 1;
            else
               foundTables = true;
            end
         end
         assert(tS.nt > 1);

         %tS.tbV = cell(nt, 1);
         tS.tbV = varargin(1 : tS.nt);
      end      
   end
   
   
   %% Get all variable names
   function vnV = get_var_names(tS)
      vnV = tS.tbV{1}.Properties.VariableNames;
      for i1 = 2 : tS.nt
         vnV = union(vnV, tS.tbV{i1}.Properties.VariableNames);
      end
   end
   
   
   %% Get all variable classes (must be same in all tables)
   function classV = get_var_classes(tS)
      vnV = tS.get_var_names;
      classV = cell(size(vnV));
      
      % Loop over tables
      for i1 = 1 : tS.nt
         % Variable names in this table
         tbVnV = tS.tbV{i1}.Properties.VariableNames;
         % Positions in vnV
         [~, idxV] = ismember(tbVnV, vnV);
         assert(all(idxV > 0));
         
         % Loop over variables in table
         for iv = 1 : length(tbVnV)
            vIdx = idxV(iv);
            vClass = class(tS.tbV{i1}.(vnV{vIdx}));
            if isempty(classV{vIdx})
               % First time this variable was seen. Records its class
               classV{vIdx} = vClass;
            else
               % Seen this class before. Check that class is unchanged
               assert(isequal(classV{vIdx}, vClass));
            end
         end
      end
   end
   
   
   %% Vertically concatenate
   %{
   Keep all variables that occur in any table
   %}
   function tbM = vertcat(tS)
      tbM = tS.tbV{1};
      
      for i1 = 2 : tS.nt
         % New table to append
         tb2M = tS.tbV{i1};
         
         % Find variables that need to be added to each table
         [~, inTbV, inTb2V] = tableLH.table_variables(tbM, tb2M.Properties.VariableNames);
         
         if ~isempty(inTbV)
            for j = 1 : length(inTbV)
               varName = inTbV{j};
               tb2M.(varName) = tS.blank_vector(class(tbM.(varName)), size(tb2M, 1));
            end
         end
         
         if ~isempty(inTb2V)
            for j = 1 : length(inTb2V)
               varName = inTb2V{j};
               tbM.(varName) = tS.blank_vector(class(tb2M.(varName)), size(tbM, 1));
            end
         end
         
         tbM = vertcat(tbM, tb2M);
      end
%       % No of rows in each table
%       nRowV = zeros(tS.nt, 1);
%       for i1 = 1 : tS.nt
%          nRowV(i1) = size(tS.tbV{i1}, 1);
%       end
%       
%       classV = tS.get_var_classes;
%       
%       % Initialize blank table
%       tbM = table;
%       for j = 1 : length(classV)
%          switch classV{j}
%             case 'cell'
%                tbM.(vName) = cell([nr, 1]);
%             case 'char'
%                tbM.(vName) = cell([nr, 1]);
%             otherwise
%                tbM.(vName) = nan([nr, 1], classV{j});
%          end
%       end
   end
end


methods (Static)
   function outV = blank_vector(classStr, inLen)
      switch classStr
         case {'cell', 'char'}
            outV = cell(inLen, 1);
         otherwise
            outV = nan([inLen, 1], classStr);
      end
   end
end
   
end
