function pstructTestLH

rng(23);
n = 7;
valueV = randn(n, 1);
lbV = -0.7;
ubV = lbV + rand(n, 1);
doCal = 1;

p = pstructLH('name', 'symbol', 'descr', valueV, lbV, ubV, doCal);
p.validate;

p.update([], lbV - 0.1, [], [])

end