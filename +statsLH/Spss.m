% Class to deal with spss files
classdef Spss < handle
      
properties
end

methods
   %% Constructor
   function spS = Spss
      
   end
   
   
   %% Parse value label lines
   %{
   IN
      lineV
         each line is a value labels line, such as  < 07 '12th grade'>
   OUT
      valueV  ::  double
         values; e.g. 7
      labelV  ::  cell
         labels; e.g. '12th grade'
   %}
   function [valueV, labelV] = parse_value_labels(spS, lineV)
      n = length(lineV);
      valueV = zeros(n, 1);
      labelV = cell(n, 1);
      
      for i1 = 1 : n
         [valueV(i1), labelV{i1}] = spS.parse_line(lineV{i1});
%          % First token: \d+ = numbers
%          % Second token: anything in between single quotes = label
%          [x, ~] = regexp(lineV{i1},  '(\d+)\s+\''([^'']+)\''',  'tokens',  'match');
%          if isempty(x)
%             % Try: second token can be in double quotes
%             [x, ~] = regexp(lineV{i1},  '(\d+)\s+"([^'']+)"',  'tokens',  'match');
%          end
%          if isempty(x)
%             keyboard;   % +++++
%          end
%          assert(~isempty(x));
% 
%          labelV{i1} = x{1}{2};
%          valueV(i1) = str2double(x{1}{1});
      end
   end
   
   
   
   %% Parse one line
   %{
   Parse on line of the form:  309 'Architects'
   with single of double enclosing quotes for the label
   %}
   function [vOut, lOut] = parse_line(spS, inStr)
      inStr = strtrim(inStr);
      lastChar = inStr(end);
%       inStr(end) = [];
      assert(ismember(lastChar, '"'''), 'Last character must be quote');
      % Find first occurrence of quote
      idx1 = strfind(inStr, lastChar);
      assert(~isempty(idx1));
      lOut = inStr((idx1+1) : (end-1));
      vOut = str2double(strtrim(inStr(1 : (idx1-1))));
   end
   
   
   %% Read value labels from codebook
   %{
   If variable not found: return []
   Assumes that the syntax 
      value labels VARNAME
   is used.
   There is another syntax
      value labels
         /VARNAME
   
   IN
      varName
         variable name, such as 'educ99'
   OUT
      valueV  ::  double
         values
      labelV  ::  cell
         labels
   
   Change: using regular expressions would be more efficient
   %}
   function [valueV, labelV] = read_value_labels(spS, varName, codeBookFn)
      valueV = [];
      labelV = [];
      
      if ~exist(codeBookFn, 'file')
         error('Code book file not found');
      end
      
      tS = filesLH.TextFile(codeBookFn);
      lineV = tS.load;

      % lineV(1:10)

      % Find the value labels line
      iLine1 = spS.find_line(lineV, ['value labels ', varName]);     
      if isnan(iLine1)
         % Try alternative syntax
         [valueV, labelV] = spS.read_value_labels_alt(varName, codeBookFn);
         return;
      end

      % Find the subsequent '.' line
      iLine2 = NaN;
      for i1 = (iLine1 + 2) : length(lineV)
         if strcmp(lineV{i1}, '.')
            iLine2 = i1;
            break;
         end
      end

      assert(iLine2 > iLine1,  'Cannot find terminating period');

      [valueV, labelV] = spS.parse_value_labels(lineV((iLine1+1) : (iLine2-1)));
   end
   
   
   
   %% Read value labels. Alternative syntax
   %{
   Expects 
      value labels
         /SCHOOL
            0  "no school"
   %}
   function [valueV, labelV] = read_value_labels_alt(spS, varName, codeBookFn)
      valueV = [];
      labelV = [];
      
      if ~exist(codeBookFn, 'file')
         error('Code book file not found');
      end
      
      tS = filesLH.TextFile(codeBookFn);
      lineV = tS.load;

      % Find the value labels line
      iLine1 = spS.find_line(lineV, 'value labels');
      if isnan(iLine1)
         return;
      end
      
      % Find the line that starts with /VARNAME
      iLine2 = spS.find_line(lineV(iLine1 : end),  ['/', upper(varName)]);
      if isnan(iLine2)
         return;
      end
      iLine2 = iLine2 + iLine1 - 1;
      assert(strcmpi(lineV{iLine2}, ['/', upper(varName)]));
      
      % Find line that is either '.' or starts with '  /'
      iLine3 = spS.find_line_start(lineV((iLine2+1) : end),  '/');
      if isnan(iLine3)
         iLine3 = spS.find_line_start(lineV((iLine2+1) : end),  '.');
      end
      if isnan(iLine3)
         return;
      end
      iLine3 = iLine3 + iLine2;
      lineStr = strtrim(lineV{iLine3});
      assert(isequal(lineStr(1), '/')  ||  isequal(lineStr(1), '.'));
      
      [valueV, labelV] = spS.parse_value_labels(lineV((iLine2+1) : (iLine3-1)));
   end
   
   
   %% Helper: find line that exactly matches a string
   % But deblank
   function iLine1 = find_line(spS, lineV, inStr)
      assert(isa(lineV, 'cell'));
      
      iLine1 = NaN;
      for i1 = 1 : length(lineV)
         if strcmpi(strtrim(lineV{i1}), inStr)
            iLine1 = i1;
            break;
         end
      end
   end
   
   function iLine1 = find_line_start(spS, lineV, inStr)
      assert(isa(lineV, 'cell'));
      
      iLine1 = NaN;
      for i1 = 1 : length(lineV)
         if strncmp(strtrim(lineV{i1}), inStr, length(inStr))
            iLine1 = i1;
            break;
         end
      end
   end
end
   
end
