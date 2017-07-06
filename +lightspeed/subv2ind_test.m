function subv2ind_test

disp('Testing subv2ind');

rng(43);
sizeV = [4,5,2,3];

idxM = [1,2,1,2;  2,1,2,1];

idx1V = lightspeed.subv2ind(sizeV, idxM);

idx2M = lightspeed.ind2subv(sizeV, idx1V);

assert(isequal(idxM, idx2M));

end