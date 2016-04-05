function randi_test

disp('Testing randi');

dbg = 111;
sizeV = [500, 20];
rng(43);

xMin = -3;
xMax = 2;
xM = randomLH.randi(xMin, xMax, sizeV, dbg);

cntV = accumarray(xM(:) - xMin + 1, 1);

nValues = xMax - xMin + 1;
checkLH.approx_equal(cntV ./ prod(sizeV),  ones(nValues,1) ./ nValues, 1e-2, []);


end