function out1 = is_on_path(inStr)
% Determines whether an object is on the path
%{
inStr cannot be a folder. For that use `is_folder_on_path`
If inStr is in a package, provide `package.inStr`

This is as simple as checking whether `which` returns a path or 'Not on Matlab path' or []
EXCEPT
when `inStr` is in current directory
%}

x = which(inStr);
% which either returns [] or 'Not on path' message, depending on whether inStr can be found in
% current dir
if isempty(x)
   out1 = false;
else
   out1 = ~strncmpi(x, 'not', 3);
end

if out1
   % Need to check that `which` does not return current directory
   fDir = fileparts(x);
   if strcmp(fDir, pwd)
      % Is current dir on path
      out1 = filesLH.is_folder_on_path(fDir);
   end
end

end