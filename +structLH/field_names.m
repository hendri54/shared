function [fCommonV, fAllV] = field_names(varargin)
% Find field names that are common to all structs in varargin or that are in one of the structs
%{
IN
   Either a list of structs or a cell array of structs
%}

if nargin == 1  &&  isa(varargin{1}, 'cell')
   % Input is cell array of struct
   inV = varargin{1};
else
   % Input is list of struct
   inV = varargin;
end
assert(isa(inV, 'cell'));


fAllV = fieldnames(inV{1});
fCommonV = fAllV;

if length(inV) > 1
   for i1 = 2 : length(inV)
      fnV = fieldnames(inV{i1});
      fAllV = union(fAllV, fnV);
      if ~isempty(fCommonV)
         fCommonV = intersect(fCommonV, fnV);
      end
   end
end



end