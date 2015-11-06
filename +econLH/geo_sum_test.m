function geo_sum_test

disp('Test geo_sum');
t2 = 8;
x = 0.8;

for t1 = [0, 3]

   gTrue = sum(x .^ (t1 : t2));

   gSum = econLH.geo_sum(x, t1, t2);

   checkLH.approx_equal(gSum, gTrue, 1e-6, []);
end

end