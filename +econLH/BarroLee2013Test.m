function tests = BarroLee2013Test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   blS = econLH.BarroLee2013;
   m = blS.load_data('mf');
   tS.verifyTrue(isa(m, 'table'));
   
   wbCodeV = {'DZA', 'USA'};
   yearV   = [1950, 1960];
   ageV    = [15, 19];
   sexStr  = 'mf';
   
   
   loadM = blS.load_yc('ls', sexStr, ageV, yearV, wbCodeV);
   validateattributes(loadM, {'double'}, {'real', 'size', [length(yearV), length(wbCodeV)]})
   
   % This implicitly also tests `load_yc`
   frac_sycM = blS.load_school_fractions(sexStr, ageV, yearV, wbCodeV);
   % Expected output (first line in file)
   expectedV = [86.12,	13.32 - 3.64,	3.64,	0.54 - 0.12,	0.12,	0.02 - 0,	0] ./ 100;
   tS.verifyEqual(frac_sycM(:, 1,1),  expectedV(:),  'AbsTol',  1e-3);
end