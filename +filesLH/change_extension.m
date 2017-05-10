function outV = change_extension(inV, newExt, changeExisting, dbg)
% Change extension for a list of files (in inV)
%{
IN
   inV  ::  cell or char
      list of file paths
   newExt  ::  char
      new extension; with or without leading '.'
   changeExisting  ::  logical
      if a file already has an extension, change it?
%}

%% Input check

if nargin < 4
   dbg = 1;
end

% % Make char input a cell array
% if isa(inV, 'char')
%    inV = {inV};
% end

if dbg > 10
   assert(isa(changeExisting, 'logical'));
   assert(isa(inV, 'cell')  ||  isa(inV, 'char'));
   assert(~isempty(inV));
   assert(isa(newExt, 'char'));
end

% Add period to extension
if newExt(1) ~= '.'
   newExt = ['.', newExt];
end


%% Main

if isa(inV, 'cell')
   outV = cell(size(inV));
   for i1 = 1 : length(inV)
      outV{i1} = change_one(inV{i1}, newExt, changeExisting);
   end
elseif isa(inV, 'char')
   outV = change_one(inV, newExt, changeExisting);
else
   error('Invalid');
end


end


function outFile = change_one(inFile, newExt, changeExisting)
   [fDir, fName, fExt] = fileparts(inFile);
   if isempty(fExt) || changeExisting
      outFile = fullfile(fDir, [fName, newExt]);
   else
      outFile = inFile;
   end
end