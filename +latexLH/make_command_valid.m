function outStr = make_command_valid(inStr)
% Given a string, make it into a valid latex command
%{
Remove special characters: _, \
Make numbers into words: 1 -> One
%}

% Remove special characters from field names (so latex does not choke)
outStr = regexprep(inStr, '[_\\]', '');

% Also replace numbers 
oldV = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
newV = {'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Zero'};
for i1 = 1 : length(oldV)
   outStr = strrep(outStr, oldV{i1}, newV{i1});
end

end