function outV = strip_formatting(inV)
% Strip formatting from text in a cell array
%{
Removes Matlab written strings such as <strong>
So that humans can read the files
%}

oldV = {'<strong>', '</strong>'};

outV = inV;
for i1 = 1 : length(oldV)
   outV = replace(outV, oldV{i1}, '');
end

end