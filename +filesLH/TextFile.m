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
      assert(tS.fid > 0,  ['Cannot open file [',  tS.fileName, ']']);
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
   
   
   %% Show on screen
   % Name was `display` but overloading `display` is not recommended
   function show(tS)
      type(tS.fileName);
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
   
   IN
      stripFormatting  ::  logical
         removes strings such as `<strong>` that are captured by evalc
   %}
   function write_strings(tS, stringV, stripFormatting)
      if nargin < 3
         stripFormatting = false;
      end
      
      if ischar(stringV)
         stringV = {stringV};
      end
      
      if stripFormatting
         oldV = {'<strong>', '</strong>'};
         for i1 = 1 : length(oldV)
            stringV = replace(stringV, oldV{i1}, '');
         end
      end
      
      % Write lines
      tS.open('a');
      for i1 = 1 : length(stringV)
         fprintf(tS.fid,  '%s\n',  stringV{i1});
      end
      
      tS.close;
   end
end
   
end