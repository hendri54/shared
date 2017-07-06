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
         % First token: \d+ = numbers
         % Second token: anything in between single quotes = label
         [x, ~] = regexp(lineV{i1},  '(\d+)\s+\''([^'']+)\''',  'tokens',  'match');

         labelV{i1} = x{1}{2};
         valueV(i1) = str2double(x{1}{1});
      end
   end
   
   
   %% Read value labels from codebook
   %{
   If variable not found: return []
   
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

      lineV(1:10)

      % Find the value labels line
      iLine1 = NaN;
      for i1 = 1 : length(lineV)
         if strcmp(lineV{i1}, ['value labels ', varName])
            iLine1 = i1;
            break;
         end
      end
      
      if isnan(iLine1)
         % Not found
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
end
   
end
