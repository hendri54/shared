function nlopt_initialize(locationStr)
% Initialize for use of NLOPT library
%{
Puts nlopt on path
Loads library

Not needed on local machine (why?)

IN
   locationStr
      'local': local computer
      'kure'
%}
% -----------------------------------------

if strcmpi(locationStr, 'local')
   % Header
   hdPath = fullfile('/usr', 'local', 'include', 'nlopt.h');
   mustLoad = 0;
   % This is where wrappers reside
   % addpath('/Users/lutz/Documents/optimization/nlopt-2.4.2/octave');
   
elseif strcmpi(locationStr, 'kure')
   % This is where wrappers reside -- must be on path?
   nloptPath = fullfile('/nas02', 'apps', 'matlab-2013a', 'nlopt-2.4.2');
   addpath(fullfile(nloptPath, 'lib'));
   hdPath = fullfile(nloptPath, 'include', 'nlopt.h');   
   % On server: load the library
   %  not needed on local machine
   mustLoad = 1;
else
   error('Invalid location string');
end

% Check that files exist
if ~exist(hdPath, 'file')
   error('Library file does not exist: %s', hdPath);
end

if mustLoad
   loadlibrary('libnlopt', hdPath);
end

end
