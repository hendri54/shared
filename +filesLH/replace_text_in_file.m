function replace_text_in_file(filePath, oldTextV, newTextV)
%{
Runs perl script on a file with several replacements
This always interprets oldTextV and newTextV as regex

NOTES:
filePath cannot contain '~'
Special characters must be escaped with '\':  \_
But '.' is ok (no need to escape it).
%}

dbg = 111;

if ~exist(filePath, 'file')
   error('File does not exist');
end
if filePath(1) == '~'
   error('Perl cannot handle this');
end

% \Q is quotemeta, so that special characters are taken literally
%  not clear how it works
baseCommand = 'perl -pi -w -e ''s{';
endCommand  = '}g'' ';

% specialCharV = '_\';

for i1 = 1 : length(oldTextV)
   oldText = stringLH.regex_escape(oldTextV{i1});
   newText = stringLH.regex_escape(newTextV{i1});
   
%    if stringLH.contains(oldText, specialCharV, dbg)  ||  stringLH.contains(newText, specialCharV, dbg)
%       warning('Cannot run replace_text_in_file on special characters');
%       
%    else
   cmdStr = [baseCommand, oldText, '} {', newText, endCommand, '''', filePath, ''' '];
   % disp(cmdStr);
   system(cmdStr);
%    end
end


end