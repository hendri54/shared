function result = copy(path1, path2, overWrite)
% Copy file path1 -> path2
%{
IN:
   path1, path2  ::  char or string
      Full paths
   overWrite      true:  overwrite existing path2
                  false: skip if path2 exists

%}

% In case inputs are string
path1 = char(path1);
path2 = char(path2);

if (exist( path2, 'file' ) > 0)  &&  ~overWrite
   disp('File already exists. Skipped.');
   result = 1;
else
   result = copyfile( path1, path2 );
end

if result ~= 1
   warnmsg([ mfilename, ':  Copying failed' ]);
   disp(path1)
   disp(path2)
end


end 