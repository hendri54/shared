function ClassDatesTest

startDate = datetime(2016, 8, 24);
endDate = datetime(2016, 12, 7);

weekDayV = {'Monday', 'Wednesday'};

cdS = markdownLH.ClassDates(startDate, endDate, weekDayV);

cdS.date_list

end