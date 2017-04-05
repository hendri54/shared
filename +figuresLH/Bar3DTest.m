function tests = Bar3DTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

lhS = const_lh;
isVisible = false;

nx = 6;
ny = 3;
rng('default');
data_xyM = rand(nx, ny);

bS = figuresLH.Bar3D(data_xyM, 'visible', isVisible);
bS.dbg = 111;
if isVisible
   pause(3);
end
bS.text_table(fullfile(lhS.dirS.testFileDir,  'Bar3D.txt'), '%.2f');
bS.close;

end