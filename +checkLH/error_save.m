function error_save(descrStr, saveS, filePath, useKeyboard)
% When an error is caught, save information. Then call error
%{
IN
   descrStr
      description of error
   saveS
      struct with info to be saved
%}
% ------------------------------------------

outS.descrStr  = descrStr;
outS.saveS     = saveS;
save(filePath, 'outS');

if useKeyboard
   warning(descrStr);
   keyboard;
else
   error(descrStr);
end


end