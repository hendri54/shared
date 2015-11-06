function cellarray2matrix_test

disp('Testing cellarray2matrix');

%% 2 and 3 dim example
dbg = 111;
rng(311);
nV = [2, 4];
mV = [3, 6, 2];
fieldName = 'test1';

cellM = cell(nV);
tgM = nan([mV, nV]);

for i1 = 1 : nV(1)
   for i2 = 1 : nV(2)
      sS.test1 = rand(mV);
      sS.test2 = rand(mV);
      
      cellM{i1, i2} = sS;
      tgM(:,:,:, i1, i2) = sS.test1;
   end
end

outM = cellLH.cellarray2matrix(cellM, fieldName, dbg);

checkLH.approx_equal(tgM, outM, 1e-7, []);


%% 3 and 2 dim example

dbg = 111;
rng(311);
nV = [2, 1, 4];
mV = [3, 6];
fieldName = 'test1';

cellM = cell(nV);
tgM = nan([mV, nV]);

for i1 = 1 : nV(1)
   for i2 = 1 : nV(2)
      for i3 = 1 : nV(3)
         sS.test1 = rand(mV);
         sS.test2 = rand(mV);
      
         cellM{i1, i2, i3} = sS;
         tgM(:,:, i1, i2, i3) = sS.test1;
      end
   end
end

outM = cellLH.cellarray2matrix(cellM, fieldName, dbg);

checkLH.approx_equal(tgM, outM, 1e-7, []);



end