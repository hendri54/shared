function idxM = ind2sub(siz,ndx)
%IND2SUB Multiple subscripts from linear index.
%{
Basically a copy of the Matlab function, but it collects all indices into a matrix rather than a
list of output vectors
%}

siz = double(siz);
lensiz = length(siz);

idxM = zeros(length(ndx),  lensiz);

if lensiz > 2
    k = cumprod(siz);
    for i1 = lensiz : -1 : 3
        vi = rem(ndx-1, k(i1-1)) + 1;
        vj = (ndx - vi)/k(i1-1) + 1;
        idxM(:, i1) = double(vj);
        ndx = vi;
    end
end

if lensiz >= 2
    vi = rem(ndx-1, siz(1)) + 1;
    idxM(:,2) = double((ndx - vi)/siz(1) + 1);
    idxM(:,1) = double(vi);
else 
    idxM(:,1) = double(ndx);
end

end



