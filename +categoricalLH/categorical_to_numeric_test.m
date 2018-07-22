function tests = categorical_to_numeric_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   valueV = [5, 10, 5, 9, 7,8, 2];
   x = categorical(valueV, 1:10, {'11', '12', '13', '14', '15', '16', '17', '18', '19', '20'});
   y = categoricalLH.categorical_to_numeric(x);
   tS.verifyEqual(y, valueV + 10);
end