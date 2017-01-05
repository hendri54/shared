classdef MatlabEditorState < handle
%{
   This is just a container used by MatlabEditor.
   Save and load methods are there
%}
   
properties
   % Paths of open files
   openFileV  cell
   % Line number for each file
   lineNumberV  double
end
   
methods
   %% Constructor
   function sS = MatlabEditorState
      sS.get_state;
   end
   
   
   %% Get state
   function get_state(sS)
      X = matlab.desktop.editor.getAll;
      n = length(X);
      
      if n > 0
         sS.openFileV = cell(n, 1);
         sS.lineNumberV = ones(n, 1);
         for i1 = 1 : n
            sS.openFileV{i1} = X(i1).Filename;
            sS.lineNumberV(i1) = X(i1).Selection(1);
         end
         
      else
         sS.openFileV = [];
         sS.lineNumberV = [];
      end      
   end
   
   
   %% Restore state
   function restore_state(sS)
      % Open files
      n = length(sS.openFileV);
      if n > 0
         for i1 = 1 : n
            try
               edit(sS.openFileV{i1});
               %matlab.desktop.editor.openAndGoToLine(sS.openFileV{i1}, sS.lineNumberV(i1))
               matlab.desktop.editor.openDocument(sS.openFileV{i1});
               activeDoc = matlab.desktop.editor.getActive;
               activeDoc.goToPositionInLine(sS.lineNumberV(i1), 1);
            catch
               fprintf('Cannot open file  %s \n',  sS.openFileV{i1});
            end
         end
      end
   end
end
   
end