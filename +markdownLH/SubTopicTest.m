function tests = SubTopicTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

classDate = datetime(2016, 8, 22);
stringV = {'[Dynamics and steady state](olg/olg_analysis_sl.pdf)', '[solution for example](olg/OLG_example.pdf)', ...
   '[PS1](olg/OLG_PS.pdf)'};
stS = markdownLH.SubTopic(stringV, classDate);

stS = markdownLH.SubTopic(stringV, classDate, 'sameDate');

stS.write_string(datetime(2016, 9, 17))

stS.write_string

end