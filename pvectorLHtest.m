function pvectorLHtest

fprintf('\nTest code for pvector class\n');

rng('default')
doCalV = 0 : 2;
n = 14;
pv = pvectorLH(n, doCalV);

paramS.blank = 1;

nameV = cell(n, 1);
pSizeV = cell(n, 1);
pValueV = cell(n, 1);

% Add objects
for i1 = 1 : n
   nameStr = sprintf('var%i', i1);
   nameV{i1} = nameStr;

   sizeV = randi(5, [1,3]);
   valueV = randn(sizeV);
   pSizeV{i1} = sizeV;
   pValueV{i1} = valueV;
   
   doCal = randi([doCalV(1), doCalV(end)], [1,1]);
   pv.change(nameStr, sprintf('x%i', i1), sprintf('descr %i', i1), valueV, ...
      -4 .* ones(sizeV), 4 .* ones(sizeV), doCal);
   paramS.(nameStr) = valueV;
end

% Make guess vector
guessV = pv.guess_make(paramS, doCalV(2));

% Make parameter struct from guess
param2S = pv.guess_extract(guessV(:)', paramS, doCalV(2));
for i1 = 1 : n
   checkLH.approx_equal(param2S.(nameV{i1}), pValueV{i1}, 1e-8, []);
end

% Make guess vector again and check that it is unchanged
guess2V = pv.guess_make(param2S, doCalV(2));

if max(abs(guess2V - guessV)) > 1e-8
   error('Guess not correctly recovered');
end

% Return list of calibrated parameters
pv.calibrated_values(paramS, doCalV(2));

% Change some calibration statuses
doCalOld = doCalV(1);
doCalNew = doCalV(end);
pv.change('test1', 't1', 'test object 1', rand(3,1), -2 * ones(3,1), 2 * ones(3,1), doCalOld);
ps = pv.retrieve('test1');
if isempty(ps)
   error('Not found');
end
pv.change_calibration_status('test1', doCalOld, doCalNew);
ps = pv.retrieve('test1');
if ~isequal(ps.doCal, doCalNew)
   error('Invalid');
end
calStatus = pv.cal_status('test1');
assert(isequal(calStatus, doCalNew));

end