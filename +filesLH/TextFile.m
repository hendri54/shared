% Text file class
%{
Change
   clean up: close the file +++
%}
classdef TextFile < handle
   
properties
   fileName  char
   fid = 0
end

methods
   %% Constructor
   function tS = TextFile(fileName, varargin)
      tS.fileName = fileName;
      
%       if find(strcmp(varargin, 'open'), 1, 'first')
%          tS.open;
%       end
   end
   
   
   %% Basics
   
   % Open
   %{
   %}
   function open(tS, openMode)
      % To get right openMode
      if tS.is_open
         tS.close;
      end
      tS.fid = fopen(tS.fileName, openMode);
      assert(tS.fid > 0,  'Cannot open file');
   end
   
   function isOpen = is_open(tS)
      isOpen = (tS.fid > 0);
   end
   
   function close(tS)
      if tS.is_open
         fclose(tS.fid);
      end
      tS.fid = 0;
   end
   
   % Clear the file
   function clear(tS)
      tS.open('w');
      tS.close;
   end
   
   
   %% Load
   function lineV = load(tS)
      if exist(tS.fileName, 'file')
         tS.open('r');
         lineV = textscan(tS.fid, '%s', 'Delimiter', '\n');
         lineV = lineV{1};
         tS.close;
      else
         lineV = [];
         warning('Cannot load file %s',  tS.fileName);
      end
   end
   
   
   %% Append cell array of strings to file
   %{
   Opens and closes file
   Special characters, such as % and \ are written correctly
   %}
   function write_strings(tS, stringV)
%       wasOpen = tS.is_open;
%       if ~wasOpen
         % Open for append if necessary
         tS.open('a');
%       end
      
      % Write lines
      if ischar(stringV)
         stringV = {stringV};
      end
      for i1 = 1 : length(stringV)
         fprintf(tS.fid,  '%s\n',  stringV{i1});
      end
      
      % Close, if necessary
%       if ~wasOpen
         tS.close;
%       end
   end
end
   
end