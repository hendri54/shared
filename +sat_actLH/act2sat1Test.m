function act2sat1Test

actV = randi([11, 35], [100, 1]);

satV = sat_actLH.act2sat1(actV);
validateattributes(satV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 490})

end