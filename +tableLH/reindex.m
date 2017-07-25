function outM = reindex(tbM, keyVar, keyListV)
% Given a table with a single key variable, reindex such that sort order matches a given list of
% keys

% Make a table with just the keys in the desired order
keyTbM = table(keyListV, 'VariableNames', {keyVar});

% The join makes a table with all the keys
[outM, ~, bIdxV] = outerjoin(tbM, keyTbM,  'Keys', {keyVar},  'MergeKeys', true);
% We drop keys that don't appear in keyListV
outM(bIdxV <= 0,:) = [];
% Resort to match order in keyListV
bIdxV = bIdxV(bIdxV > 0);
outM(bIdxV,:) = outM;

assert(isequal(outM.(keyVar), keyListV));

end