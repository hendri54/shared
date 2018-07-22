% Latex preamble
%{
Creates a file with a latex preamble (a collection of newcommand statements)

Writing to the preamble from many places is confusing.

The approach is therefore: 
- initialize preamble (create new text file)
- append entries (lines in text file)
- close file
This is really just a TextFile object with the ability to write latex newcommands
%}
classdef Preamble < handle
   properties (SetAccess = private)
      tFile  filesLH.TextFile
   end
   
   methods
      %% Constructor
      function pS = Preamble(fileName)
         pS.tFile = filesLH.TextFile(fileName);
      end
      
      %% Initialize file
      function initialize(pS)
         pS.tFile.clear;
      end
      
      %% Open file
      function open(pS)
         pS.tFile.open('a');
      end
      
      %% Close file
      function close(pS)
         pS.tFile.close;
      end
      
      
      %% Add a newcommand line to an existing preamble
      %{
      IN
         commentStr
            can be omitted
            comment above new command
      File remains open after writing
      %}
      function append(pS, fieldName, commandStr, commentStr)
         if nargin < 3
            commentStr = [];
         end

         % Open file, if needed
         pS.open;

         % Write comment, if any
         if ~isempty(commentStr)
            % Replace single \ with double for fprintf
            commentStr = regexprep(commentStr, '\\{1}', '\\\\');
            pS.tFile.write_strings(['% ',  commentStr]);
            %fprintf(fp, ['%% ',  commentStr,  '\n']);
         end
         
         % Write newcommand
         fieldName = latexLH.make_command_valid(fieldName);
         % Replace single \ with double for fprintf
         commandStr = regexprep(commandStr, '\\{1}', '\\\\');
         pS.tFile.write_strings(['\newcommand{\',  fieldName,  '}{', commandStr, '}']);         
      end

      
      %% Extract commands and values from preamble file
      %{
      Given a preamble file with comment lines and \newcommand lines.
      Make a list of commands and their values
      Purpose: Be able to replace the commands with their values for publication
      
      OUT:
         cmdV
            list of commands defined by newcommand
            including leading '\'
      %}
      function [cmdV, valueV] = extract_commands(pS)
         % Load file into cell array
         lineV = pS.tFile.load;
         assert(~isempty(lineV),  'Cannot load file');
         
         % Allocate vectors for commands and values
         cmdV = cell(size(lineV));
         valueV = cell(size(lineV));
         
         % Search via regex
         ir = 0;
         for i1 = 1 : length(lineV)
            % Omit comments
            lineStr = lineV{i1};
            if ~isempty(lineStr)  &&  (lineStr(1) ~= '%')
               % Get the command and the value
               outV = regexp(lineStr,  '\\newcommand{(.+)}{(.+)}',  'tokens');
               if ~isempty(outV)
                  outV = outV{1};
                  ir = ir + 1;
                  cmdV{ir} = outV{1};
                  valueV{ir} = outV{2};
               end
            end
         end
         
         % Drop excess elements
         cmdV((ir+1) : end) = [];
         valueV((ir+1) : end) = [];
      end
      
      
      %% Compare two preamble files
      %{
      Used to see how results have changed relative to earlier run. Or to compare two model versions
      %}
      function compare(pS, p2S)
         [cmd1V, value1V] = pS.extract_commands;
         [cmd2V, value2V] = p2S.extract_commands;
         
         % All field names
         cmdV = unique([cmd1V(:); cmd2V(:)]);

         % Find which ones are common / only in one preamble
         in1V = ismember(cmdV, cmd1V);
         in2V = ismember(cmdV, cmd2V);
         
         % Show commands in only one preamble
         for iCase = 1 : 2
            switch iCase
               case 1
                  idxV = find(in1V  &  ~in2V);
               case 2
                  idxV = find(in2V  &  ~in1V);
               otherwise
                  error('Invalid');
            end
            
            if ~isempty(idxV)
               fprintf('Commands only in preamble %i:  \n', iCase);
               for i1 = idxV(:)'
                  fprintf('    %s',  cmdV{i1});
               end
               fprintf('\n');
            end
         end

         % Show commands in both preambles
         idxV = find(in1V  &  in2V);
         if ~isempty(idxV)
            fprintf('Commands in both preambles \n');
            for i1 = idxV(:)'
               idx1 = find(strcmp(cmdV{i1}, cmd1V), 1, 'first');
               idx2 = find(strcmp(cmdV{i1}, cmd2V), 1, 'first');
               if ~isequal(value1V{idx1}, value2V{idx2})
                  fprintf('%s    %s    %s \n',  cmdV{i1}, value1V{idx1}, value2V{idx2});
               end
            end
         end
      end
   end
   
end
