classdef Topic < handle
   
properties
   % Title
   title    char
   % List of SubTopic
   topicV   cell
   % Class dates (array of datetime)
   classDateV  datetime
end


methods
   %% Constructor
   %{
   IN
      topicV
         may be a single string
   %}
   function tS = Topic(titleIn, topicV, classDateV)
      tS.title = titleIn;
      if isa(topicV, 'char')
         topicV = {topicV};
      end
      tS.topicV = topicV;
      tS.classDateV = classDateV;
   end
   
   
   %% Make cell array of string that can be written to markdown file
   %{
   IN
      startDate
         index into classDateV
   
   OUT
      iDateV
         dates occupied by this topic
   %}
   function [outV, iDateV] = write_topic(tS, startDate)
      validateattributes(startDate, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', 'scalar'})
      outV = cell(20 + length(tS.topicV), 1);
      
      % Assign each topic a date
      iDateV = tS.topic_dates(startDate);
      
      % Write title
      iLine = 1;
      outV{iLine} = ' ';
      iLine = iLine + 1;
      outV{iLine} = ['## ', tS.title, ' ##'];
      iLine = iLine + 1;
      outV{iLine} = ' ';
      
      % Write each topic (in order of iDateV)
      [~, sortIdxV] = sort(iDateV);
      for i1 = 1 : length(tS.topicV)
         iTopic = sortIdxV(i1);
         iLine = iLine + 1;
         outV{iLine} = tS.topicV{iTopic}.write_string(tS.classDateV(iDateV(iTopic)));
      end
      
      iLine = iLine + 1;
      outV{iLine} = ' ';      
      outV(iLine+1 : end) = [];
   end
   
   
   %% Figure out the date for each topic
   %{
   Keep in mind that some topics have fixed dates
   IN
      startDate
         index into classDateV
   OUT
      iDateV
         index into tS.classDateV
         if full: assign last class date
   %}
   function iDateV = topic_dates(tS, startDate)
      validateattributes(startDate, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', 'scalar'})
      assert(~isempty(tS.classDateV));
      
      n = length(tS.topicV);
      iDateV = zeros(n, 1);
      
      % Mark which class dates are taken (all before start date)
      takenV = zeros(length(tS.classDateV), 1);
      if startDate > 1
         takenV(1 : (startDate-1)) = 1;
      end
      
      % Loop over subTopics
      for i1 = 1 : n
         topicS = tS.topicV{i1};
         if ~isempty(topicS)
            if topicS.sameDateAsPrevious
               % Taught on same date as previous topic
               iDateV(i1) = iDateV(i1-1);
            elseif ~isempty(topicS.classDate)
               % Assign fixed date (must exist)
               idx1 = find(topicS.classDate == tS.classDateV, 1, 'first');
               assert(idx1 > 0);
               iDateV(i1) = idx1;
            elseif all(takenV == 1)
               % Assign last class date
               iDateV(i1) = length(takenV);
            else
               % Assign first not taken date
               iDateV(i1) = find(takenV == 0, 1, 'first');
            end
            assert(iDateV(i1) >= 1);
            takenV(iDateV(i1)) = 1;
         end
      end
   end
end
   
end