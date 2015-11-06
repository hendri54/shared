% Table with symbols for papers
%{
Purpose is to write a file with newcommands
%}

classdef SymbolTableLH < handle
   
   properties
      % No of symbols stored
      n
      % Names. Must be valid latex commands
      nameV
      % Latex symbols
      symbolV
   end
   
   
   methods
      %% Constructor
      function tS = SymbolTableLH(nameV, symbolV)
         tS.nameV = cell([100, 1]);
         tS.symbolV = cell([100, 1]);
         tS.n = length(nameV);
         tS.nameV(1 : tS.n) = nameV;
         tS.symbolV(1 : tS.n) = symbolV;
         
         tS.validate;
      end
      
      
      %% Validate object
      function validate(tS)
         if tS.n > 0
            for i1 = 1 : tS.n
               tS.sym_validate(tS.symbolV{i1});
            end
         end
      end

      
      %% Validate symbol
      function sym_validate(tS, symbolStr)
         validateattributes(symbolStr, {'char'}, {'nonempty'})
      end
      
      
      %% Add one element
      function add_one(tS, nameStr, symbolStr)
         % Make sure element does not already exist
         if ~isempty(tS.retrieve(nameStr))
            error('Field %s already exists',  nameStr);
         end
         tS.n = tS.n + 1;
         tS.nameV{tS.n} = nameStr;
         tS.symbolV{tS.n} = symbolStr;         
      end
      
      
      %% Add elements
      function add(tS, nameStrV, symbolStrV)
         if ischar(nameStrV)
            tS.add_one(nameStrV, symbolStrV);
         else
            % Add multiple
            nNew = length(nameStrV);
            for i1 = 1 : nNew
               tS.add_one(nameStrV{i1}, symbolStrV{i1});
            end
         end
         
         tS.validate;
      end
      
      
      %% Retrieve by name
      %{
      IN
         mathFormat :: Bool
            add '$' at beginning and end of symbol, if true
      %}
      function symbolStr = retrieve(tS, nameStr, mathFormat)
         if nargin < 3
            mathFormat = false;
         end
         idx1 = find(strcmp(nameStr, tS.nameV));
         if isempty(idx1)
            symbolStr = [];
         else
            symbolStr = tS.symbolV{idx1};
            if mathFormat
               symbolStr = ['$', symbolStr, '$'];
            end
         end
      end
      
      
      %% Write file with newcommands
      function preamble_write(tS, fPath)
         fp = fopen(fPath, 'w');
         if fp <= 0
            error(sprintf('Cannot open file %s', fPath));
         end
         for i1 = 1 : tS.n
            % Escape special latex characters
            % symStr = latex_lh.str_escape(tS.symbolV{i1});
            fprintf(fp,  '\\newcommand{\\%s}{%s} \n',  tS.nameV{i1}, tS.symbolV{i1});
         end
         fclose(fp);
      end
   end
   
end


