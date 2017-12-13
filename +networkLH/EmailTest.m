function tests = EmailTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   emS = networkLH.Email([], [], []);
   emS.testMode = true;
   emS.send('hendricks.lutz@gmail.com', 'Test subject', {'Test message line 1', 'Test message line2'}, false);
end