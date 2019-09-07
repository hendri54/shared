% Escape characters in a latex string so it can be sent to fprintf
%{
This is mainly used to make Latex tables
Control sequences have to be escaped before typesetting
%}
function xStr = str_escape(inStr)

xStr = strrep(inStr,'\','\\');
xStr = strrep(xStr,'%','%%');
% xStr = strrep(xStr,'_','\_');

end