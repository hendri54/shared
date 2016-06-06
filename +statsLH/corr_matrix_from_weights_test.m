function corr_matrix_from_weights_test

rng(490);
for n = 2 : 5
   wtM = rand(n,n);
   for i1 = 1 : n
      if i1 > 1
         wtM(1 : i1, i1) = 0;
      end
      wtM(i1,i1) = 1;
   end

   corrM = statsLH.corr_matrix_from_weights(wtM);
   chol(corrM);
end

end