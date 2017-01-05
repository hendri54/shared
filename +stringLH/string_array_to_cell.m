function outV = string_array_to_cell(strV)

assert(isa(strV, 'string'),  'String array expected');

outV = cell(size(strV));
for i1 = 1 : length(outV)
   outV{i1} = char(strV(i1));
end

end