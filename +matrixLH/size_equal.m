function result = size_equal(size1V, size2V)
% Compare size of matrix with target, correctly handling trailing singleton dimensions

result = isequal(strip_trailing_ones(size1V),  strip_trailing_ones(size2V));

end


function outV = strip_trailing_ones(sizeV)
   outV = sizeV;
   while  length(outV) > 2  &&  outV(end) == 1
      outV(end) = [];
   end
end