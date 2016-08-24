% Subtopic for a class schedule
classdef SubTopic < handle
   
properties
   % No of class periods it lasts
   % nClasses    double
   % Date at which taught (optional)
   % This is set for items that occur at fixed dates (exams, holidays, classes already taught)
   classDate   datetime
   % List of formatted markdown strings
   stringV  cell
   % Taught on same date as previous topic?
   sameDateAsPrevious   logical = false;
end


methods
   %% Constructor
   function stS = SubTopic(stringV, classDate, varargin)
      %stS.nClasses = nClasses;
      stS.stringV = stringV;
      if nargin >= 2
         if ~isempty(classDate)
            stS.classDate = classDate;
         end
      end
      
      if nargin >= 3
         if any(strcmpi(varargin, 'sameDate'))
            stS.sameDateAsPrevious = true;
         end
      end
   end
   
   
   %% Output a string that can be written to a markdown file that displays the subtopic
   function outStr = write_string(stS, classDateIn)
      if nargin < 2
         classDateIn = [];
      end
      if isempty(classDateIn)
         classDateIn =  stS.classDate;
      end
      classDateStr = datestr(classDateIn, 'mmm-dd (ddd)');
      
      if stS.sameDateAsPrevious
         outStr = '    * ';
      else
         outStr = ['* ', classDateStr, ': ', ];
      end
      for i1 = 1 : length(stS.stringV)
         outStr = [outStr, stS.stringV{i1}];
         if i1 < length(stS.stringV)
            outStr = [outStr, ', '];
         end
      end
   end
end
   
end