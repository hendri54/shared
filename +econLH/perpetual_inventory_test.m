function tests = perpetual_inventory_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

disp('Testing perpetual_inventory');
ny = 8;
nc = 3;
dbg = 111;
ddk = 0.1;

rng(23);
iy_ycM = rand(ny, nc);
Y_ycM = 1 + rand(ny, nc);

iy_ycM(iy_ycM < 0.1) = -1;
Y_ycM(Y_ycM < 1.1) = -1;

K_ycM = econLH.perpetual_inventory(iy_ycM, Y_ycM, ddk, dbg);

end