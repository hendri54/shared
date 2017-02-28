function paper_format(paperFn, preambleFnV)
% Format paper for publication
%{
Replace macros with literals, based on preambles
Makes a copy of the paper file first
%}

%% Make a copy of the paper file

assert(exist(paperFn, 'file') > 0);
[paperDir, paperName, paperExt] = fileparts(paperFn);
newPaperFn = fullfile(paperDir, [paperName, '_formatted', paperExt]);
copyfile(paperFn,  newPaperFn);



%% Make list of all commands to be processed

% Extract commands from preambles
cmdV = [];
valueV = [];
for ip = 1 : length(preambleFnV)
   pS = latexLH.Preamble(preambleFnV{ip});
   [cmd2V, value2V] = pS.extract_commands;
   cmdV = [cmdV; cmd2V(:)];
   valueV = [valueV; value2V(:)];
end

% Sort commands by length (need to process longest first)
lengthV = zeros(size(cmdV));
for i1 = 1 : length(cmdV)
   lengthV(i1) = length(cmdV{i1});
end
validateattributes(lengthV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 2, '<=', 40, ...
   'size', size(cmdV)})


% Make sure that commands are unique
assert(isequal(length(unique(cmdV)),  length(cmdV)),  'Commands are not unique');

% Show the replacement table
[~, sortIdxV] = sort(-lengthV);
cmdV = cmdV(sortIdxV);
valueV = valueV(sortIdxV);

for i1 = 1 : length(cmdV)
   fprintf('%s  =  %s \n',  cmdV{i1},  valueV{i1});
end


%% Run replacement

filesLH.replace_text_in_file(newPaperFn, cmdV, valueV);


end