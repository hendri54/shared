% Interface for diary
classdef DiaryFile < handle
      
properties
   % Full path of diary file
   fileName  char
end

properties (SetAccess = private)
   fileDir  char
end


methods
   %% Constructor
   %{
   Creates directory if necessary
   
   Optional arguments
      'clear'
         clears existing diary file
   %}
   function dS = DiaryFile(fn, varargin)
      dS.fileName = fn;
      dS.fileDir = fileparts(fn);
      if ~isempty(dS.fileDir)
         filesLH.mkdir(dS.fileDir);
      end
      
      if ~isempty(varargin)
         if ismember(varargin, 'clear')
            dS.clear;
         end
         if ismember(varargin, 'append')
            dS.open('append');
         end
         if ismember(varargin, 'new')
            dS.open('new');
         end
      end
   end
   
   
   %% Close diary file
   function close(dS)
      diary off;
   end
   
   
   %% Open for append or new file
   function open(dS, modeStr)
      if nargin < 2
         modeStr = 'append';
      end
      
      diary off;
      
      if isequal(modeStr, 'append')
         diary(dS.fileName);
      elseif isequal(modeStr, 'new')
         dS.clear;
         diary(dS.fileName);
      else
         error('invalid');
      end
      diary on;
   end
   
   
   %% Clear existing diary file
   function clear(dS)
      diary off;
      if exist(dS.fileName, 'file')
         delete(dS.fileName);
      end
   end
   
   
   %% Strip formatting from a diary file
   %{
   Also closes file
   Removes strings such as <strong>
   %}
   function strip_formatting(dS)
      dS.close;
      tS = filesLH.TextFile(dS.fileName);
      tS.strip_formatting;
   end
end
   
end
