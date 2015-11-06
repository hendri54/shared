function find_matches_test

disp('Testing find_matches');
dbg = 111;

yV = 1 : 5;
xV = [3,2,1];
idxV = vectorLH.find_matches(xV,yV, dbg);
assert(isequal(xV, yV(idxV)));

% Just check random integer vectors
% Testing happens inside find_matches
rng(43);
valueV = 1 : 100;
for i1 = 1 : 10;
   yV = valueV(randperm(32));
   xV = valueV(randperm(14));
   vectorLH.find_matches(xV, yV, dbg);
end

end