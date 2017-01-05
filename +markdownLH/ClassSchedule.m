classdef ClassSchedule < handle
%{
Extensions
   once something has been taught: fix the date 
   when running out of dates: how to handle that
   
   same date as previous topic
   topics that are longer than one date / shorter than one date
%}
   
properties
   % Class dates 
   classDateV  datetime
   % Cell array of Topic
   topicV      cell
end

methods
   %% Constructor
   function cS = ClassSchedule(classDateV, topicV)
      cS.classDateV = classDateV;
      cS.topicV = topicV;
   end
   
   
   %% Write schedule
   %{
   IN
      outFn (optional)
         output file, full path
   %}
   function outV = write(cS, outFn)
      outV = cell(200, 1);
      iLine = 0;
      
      % List of open class dates
      openV = ones(size(cS.classDateV));
      
      % Loop over topics
      assert(length(cS.topicV) >= 1);
      for i1 = 1 : length(cS.topicV)
         % Find available class dates
         if ~isempty(cS.topicV{i1})
            % Should have list of class dates as input to write_topic +++
            if all(openV == 0)
               openIdxV = length(openV);
            else
               openIdxV = find(openV);
            end
            
            cS.topicV{i1}.classDateV = cS.classDateV(openIdxV);
            [tOutV, iDateV] = cS.topicV{i1}.write_topic(1);
            outV(iLine + (1 : length(tOutV))) = tOutV;
            openV(openIdxV(iDateV)) = 0;
            iLine = iLine + length(tOutV);
         end
      end
      
      outV((iLine+1) : end) = [];
      
      if nargin >= 2
         fid = fopen(outFn, 'w');
         assert(fid > 0);
         for iLine = 1 : length(outV)
            fprintf(fid, '%s \n', outV{iLine});
         end
         fclose(fid);
      end
   end
end
   
end