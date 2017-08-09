% Code to read IPUMS codebook
%{
Assumes that table with codes / descriptions / counts has been copied / pasted to a text file
%}
classdef IpumsCodebook < handle
      
properties
   % File name with text format  [code  description  count]
   fn  char
   
   % Header code in output fiel
   headerCode = -1
end

methods
   %% Constructor
   function cbS = IpumsCodebook(fn)
      cbS.fn = fn;
   end
   
   
   %% Load into table
   function lineV = load(cbS)
      assert(exist(cbS.fn, 'file') > 0,  'File not found:  %s',  cbS.fn);
      tS = filesLH.TextFile(cbS.fn);
      lineV = tS.load;
      assert(~isempty(lineV));
   end
   
   
   %% Write to xls file
   %{
   Skip headers or write them with a special code
   %}
   function write_to_file(cbS, outFn, overWrite)
      if ~overWrite  &&  (exist(outFn, 'file') > 0)
         fprintf('Output file already exists \n');
         return;
      end
      
      lineV = cbS.load;
      
      n = length(lineV);
      tbM = table(zeros(n, 1),  cell(n, 1),  zeros(n, 1),  'VariableNames',  {'Code', 'Description', 'Count'});
      ir = 0;
      
      for i1 = 1 : length(lineV)
         lineType = cbS.line_type(lineV{i1});
         switch lineType
            case 'regular'
               ir = ir + 1;
               [tbM.Code(ir), tbM.Description{ir}, tbM.Count(ir)] = cbS.parse_regular_line(lineV{i1});
            case 'header'
               ir = ir + 1;
               tbM.Code(ir) = cbS.headerCode;
               tbM.Description{ir} = strtrim(lineV{i1});
               tbM.Count(ir) = 0;
         end
      end
      
      % Drop excess lines
      if ir < n
         tbM((ir+1) : n,  :) = [];
      end
      
      writetable(tbM, outFn);
   end
   
   
   
   %% Parse regular line
   % Regex not robust
   function [codeOut, descrStr, countOut] = parse_regular_line(cbS, lineStr)
      lineStr = strtrim(lineStr);
      [x, ~] = regexp(lineStr, '(\d+)\s+(.+)',  'tokens',  'match');
      codeOut = str2double(x{1}{1});
      restStr = x{1}{2};
      
      [y, ~] = regexp(strtrim(restStr),  '(.+)[ \t]+([\d,]+)',  'tokens',  'match');
      descrStr = strtrim(y{1}{1});
      countOut = str2double(y{1}{2});
   end
   
   
   %% Determine the type of line
   function lineType = line_type(cbS, lineStr)
      lineStr = strtrim(lineStr);
      n = length(lineStr);
      
      if n == 0
         lineType = 'blank';
      elseif n == 2
         lineType = 'country';
      elseif (n > 4)  &&  strncmpi(lineStr, 'Code', 4)
         % Header line: 'Code Label'
         lineType = 'other';
      else
         isNumberV = ismember(lineStr, '0123456789,.');
         if (n == 4)  &&  all(isNumberV)
            lineType = 'year';
         elseif ~isNumberV(1)
            lineType = 'header';
         elseif isNumberV(1)  &&  isNumberV(end)
            lineType = 'regular';
         else
            lineType = 'other';
         end
      end
   end
end
   
end
