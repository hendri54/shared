classdef ClassDates
   
properties
   % Start and end date
   startDate   datetime
   endDate     datetime
   % Weekdays the class meets
   weekDayV    cell
end


methods
   %% Constructor
   function cdS = ClassDates(startDate, endDate, weekDayV)
      cdS.startDate = startDate;
      cdS.endDate = endDate;
      cdS.weekDayV = weekDayV;
   end
   
   
   %% Make a list of dates as datetime objects
   function outV = date_list(cdS)
      n = round(days(cdS.endDate - cdS.startDate) ./ 5);
      outV = [];
      for i1 = 1 : length(cdS.weekDayV)
         newV = dateshift(cdS.startDate, 'dayofweek', cdS.weekDayV{i1}, 1 : n);
         newV(newV > cdS.endDate) = [];
         outV = [outV, newV];
      end
      
      outV = sort(outV);
   end
  
end
   
   
end