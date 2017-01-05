function sat_old2new_test

newV = sat_actLH.sat_old2new(linspace(400, 1590, 50));
validateattributes(newV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', [1,50]})

end