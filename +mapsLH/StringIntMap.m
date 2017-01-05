% One-to-one mapping between strings and integers
%{
Applications: 
- items that can be referred to by name or number (such as calibration sets)

Essentially containers.Map with the restriction that the values must be unique

Approach
Create containers.Map. Ensure unique values.
Keys are strings (for easy retrieval). Values are integers

%}
classdef StringIntMap < handle
   
properties
   % This holds all the data
   cmS  containers.Map
end

methods
   %% Constructor
   %{
   Define max size
   Initialize with set of key / value pairs
   
   IN:
      keyV  
         cell array of char (the keys or names)
      valueV
         integer vectors
   
   should allow empty +++++
   %}
   function sS = StringIntMap(keyV, valueV)
      validateattributes(valueV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive'})
      % Make sure values are unique
      assert(isequal(length(valueV),  length(unique(valueV))),  'Values must be unique');
      
      sS.cmS = containers.Map(keyV, valueV, 'UniformValues', true);
   end
   
   
   %% Validate
   
   
   %% All values and keys
   % Not returned in any particular order
   function [keyV, valueV] = all_keys_values(sS)
      keyV = sS.cmS.keys;
      valueV = cell2mat(sS.cmS.values);
   end
   
   
   %% Retrieve values from keys
   function valueV = values(sS, keyInV)
      if ischar(keyInV)
         keyInV = {keyInV};
      end
      % This is a cell array
      % Make into a vector
      valueV = cell2mat(sS.cmS.values(keyInV));
      validateattributes(valueV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive'})
   end
   
   
   %% Retrieve keys from values
   %{
   OUT:
      keyV  cell array
         even if value is scalar, output is cell array
   %}
   function keyV = keys(sS, valueInV)
      validateattributes(valueInV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive'})
      % All values as numeric vector
      keyListV   = sS.cmS.keys;
      valueListV = cell2mat(sS.cmS.values);
      
      keyV = cell(size(valueInV));
      for i1 = 1 : length(valueInV)
         idx1 = find(valueListV == valueInV(i1), 1, 'first');
         assert(idx1 >= 1,  'Value not found');
         keyV{i1} = keyListV{idx1};
      end
   end
   
   
   %% Do all keys match values?
   function out1 = matches(sS, keyInV, valueInV)
      out1 = all(sS.values(keyInV) == valueInV);
   end
   
   
   %% Add more elements
   % Make sure there are no duplicate keys or values
   function add(sS, keyInV, valueInV)
      % **** Make sure no key or value already exists
      % All values as numeric vector
      valueListV = cell2mat(sS.cmS.values);      
      assert(~any(sS.cmS.isKey(keyInV)),  'Keys already exist');
      for i1 = 1 : length(valueInV)
         assert(~any(valueListV == valueInV(i1)),  'Values already exist');
      end
      
      % ****  Append
      cm2S = containers.Map(keyInV, valueInV);
      sS.cmS = [sS.cmS; cm2S];
   end
end
   
end