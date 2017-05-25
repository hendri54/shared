function tests = ClassDatesTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

startDate = datetime(2017, 8, 22);
endDate = datetime(2017, 12, 6);

weekDayV = {'Tuesday', 'Thursday'};

cdS = markdownLH.ClassDates(startDate, endDate, weekDayV);

cdS.date_list

end