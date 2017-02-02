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
   properties
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

      
      
   end
   
end
