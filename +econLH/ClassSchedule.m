% ClassSchedule
%{
Produces a schedule of classes
ClassDates produces a list of class meetings
Maintain a list of topics and the dates when they are taught
Mark topics with fixed dates (exams, holidays, classes already taught)
Assign each remaining topic to a date (or to multiple dates)

Format:
   Jan-12 (M): Asset pricing, RQ
   Jan-14 (W): Asset pricing continued
   Jan-19 (M): Stochastic growth
   Jan-19 (M): Ramsey model
%}
classdef ClassSchedule
   
properties
   % Class dates (ClassDates object)
   cDateV
   % List of topics, some with fixed dates (vector of ClassTopic)
   cTopicV
end

methods
   %% Constructor
   
   
   %% Write a formatted class schedule
   %{
   Steps
   1. Allocate a vector of string vectors; one for each date
         each entry is 1 topic for that date
   2. Write topics with fixed dates
   3. Using cumulative sum of durations, determine start and end dates for each topic
         this uses only dates not taken by topics with fixed dates
   4. Loop over topics with variable dates
         write a string for each date the topic is taught
   %}
end
   
end