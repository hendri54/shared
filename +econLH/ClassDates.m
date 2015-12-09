% ClassDates
%{
List of class dates
Defined by 
- start and end dates
- dates of the week that are taught
%}
classdef ClassDates
   
properties
   % First and last day of classes
   startDate
   endDate
   % Days of week that are taught
   %  1 = Monday, 7 = Sunday
   daysTaught
end

properties (Dependent)
   % List of all class dates
   dateList
end

methods
   %% Constructor
   
   
   %% Make a list of all class dates
end
   
end