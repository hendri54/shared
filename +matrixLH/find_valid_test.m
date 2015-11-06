function find_valid_test

disp('Testing find_valid');

dbg = 111;
missVal = -9191;
rng(32);

nr = 10;
nc = 3;
xM = randn([nr, nc]);

vIdxV = matrixLH.find_valid(xM, missVal);
assert(isequal(vIdxV,  (1 : nr)'));

iDrop = 3;
trueIdxV = (1 : nr)';
trueIdxV(iDrop) = [];
xM(iDrop,2) = nan;
vIdxV = matrixLH.find_valid(xM, missVal);
assert(isequal(vIdxV,  trueIdxV));


iDrop = 6;
trueIdxV(trueIdxV == iDrop) = [];
xM(iDrop, 1) = missVal;
vIdxV = matrixLH.find_valid(xM, missVal);
assert(isequal(vIdxV,  trueIdxV));



end