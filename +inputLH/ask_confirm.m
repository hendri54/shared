function result = ask_confirm(qString, noConfirm)
% Ask a yes/no question and return true for yes answer
%{
Bypass if noConfirm == 'noConfirm'

OUT
   result  ::  logical
%}

% Bypass confirmation
if ischar(noConfirm)
   if strcmpi(noConfirm, 'noConfirm')
      result = true;
      return
   end
end


% Ask
ans1 = input([qString, '    '],  's');
if strcmpi(ans1, 'yes')
   result = true;
else
   result = false;
end


end