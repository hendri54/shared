function tests = text_table_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   dbg = 111;
   nr = 4;
   nc = 3;
   
   dataM = cell([nr, nc]);
   for ir = 1 : nr
      for ic = 1 : nc
         dataM{ir, ic} = sprintf('cell %i/%i', ir, ic);
      end
   end
   
   rowUnderlineV = zeros([nr, 1]);
   rowUnderlineV(1) = 1;
   
   fp = 1;
   cellLH.text_table(dataM, rowUnderlineV, fp, dbg);
end