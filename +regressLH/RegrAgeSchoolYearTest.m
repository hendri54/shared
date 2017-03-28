function tests = RegrAgeSchoolYearTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

rng(20);

weighted = false;
ageRangeV = [30, 40];
schoolRangeV = [9, 14];
yearRangeV = [1990, 1997];
rS = regressLH.RegrAgeSchoolYear(ageRangeV, schoolRangeV, yearRangeV, weighted);

nAge = diff(ageRangeV) + 1;
nSchool = diff(schoolRangeV) + 1;
nYear = diff(yearRangeV) + 1;

sizeV = [nAge, nSchool, nYear];
x_astM = randn(sizeV);
wt_astM = 1 + rand(sizeV);
y_astM = x_astM + randn(sizeV) .* 0.5;

rS.regress(y_astM, x_astM, wt_astM);

end