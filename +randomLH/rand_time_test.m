function rand_time_test

rng(45);
y0 = rand(1,1);

rng(45);
x1 = randomLH.rand_time;
y1 = rand(1,1);

% Did not change seed
assert(abs(y0 - y1) < 1e-8);

% Get different values each time
x2 = randomLH.rand_time;
assert(abs(x2 - x1) > 1e-8);


end