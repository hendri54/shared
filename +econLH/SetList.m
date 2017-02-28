% List of named and numbered sets
%{
A set is meant to be a model version with its own settings
The set list keeps track of the mapping from names to numbers

Name inputs can be individual strings, cell arrays, or string arrays
Name outputs are string arrays
%}
classdef SetList < handle
   
properties
   % No of elements allocated
   n  uint64
   % Names (unique)
   nameV  string
   % Numbers (unique)
   numberV  uint64
   % Any other info; can be any object
   otherV
end

methods
   %% Constructor
   function sS = SetList(nMax)
      sS.nameV = strings([nMax, 1]);
      sS.numberV = zeros([nMax, 1], 'uint64');
      sS.otherV = cell([nMax, 1]);
      sS.n = 0;
   end
   
   
   %% Does name or number exist?
   function outV = exists(sS, inV)
      if isa(inV, 'numeric')
         outV = sS.exists_number(inV);
      else
         outV = sS.exists_name(inV);
      end
   end
   
   
   %% Does number exist?
   %{
   IN
      inV
         numbers; any numeric format
   %}
   function outV = exists_number(sS, inV)
      validateattributes(inV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive'})
      if sS.n == 0
         outV = false(size(inV));
      else
         outV = ismember(uint64(inV), sS.numberV(1 : sS.n));
      end      
   end
   
   
   %% Does name exist?
   function outV = exists_name(sS, nameInV)
      if sS.n == 0
         outV = false(size(nameInV));
      else
         outV = ismember(sS.convert_to_string(nameInV), sS.nameV(1 : sS.n));
      end
   end
   
   
   %% Add a list of sets
   function add(sS, nameInV, numberInV, otherInV)
      name2V = sS.convert_to_string(nameInV);
      % Add all elements
      for i1 = 1 : length(name2V)
         sS.add_one(name2V(i1), numberInV(i1), otherInV(i1));
      end
   end
   
   
   %% Add one entry
   function add_one(sS, nameIn, numberIn, otherIn)
      assert(~sS.exists_name(nameIn));
      assert(~sS.exists_number(numberIn));
      sS.n = sS.n + 1;
      sS.nameV(sS.n) = nameIn;
      sS.numberV(sS.n) = numberIn;
      sS.otherV(sS.n) = otherIn;
   end
   
   
   %% Retrieve a set by name
   function [nameOut, numberOut, otherOut] = retrieve_name(sS, nameIn)
      idx1 = find(strcmp(sS.nameV(1 : sS.n), nameIn), 1, 'first');
      if isempty(idx1)
         nameOut = [];
         numberOut = [];
         otherOut = [];
      else
         nameOut = sS.nameV(idx1);
         numberOut = sS.numberV(idx1);
         otherOut = sS.otherV{idx1};
      end
   end
   
   
   %% Retrieve a set by number
   function [nameOut, numberOut, otherOut] = retrieve_number(sS, numberIn)
      idx1 = find(sS.numberV(1 : sS.n) == uint64(numberIn), 1, 'first');
      if isempty(idx1)
         nameOut = [];
         numberOut = [];
         otherOut = [];
      else
         nameOut = sS.nameV(idx1);
         numberOut = sS.numberV(idx1);
         otherOut = sS.otherV{idx1};
      end
   end
   
   
   %% Retrieve a set by name or number
   function [nameOut, numberOut, otherOut] = retrieve(sS, numberIn)
      if isnumeric(numberIn)
         [nameOut, numberOut, otherOut] = sS.retrieve_number(numberIn);
      else
         [nameOut, numberOut, otherOut] = sS.retrieve_name(numberIn);
      end
   end
   
   
   %% Convert name input to string array
   function nameV = convert_to_string(sS, nameInV)
      if isa(nameInV, 'char')  ||  isa(nameInV, 'cell')
         nameV = string(nameInV);
      else
         nameV = nameInV;
      end
      assert(isa(nameV, 'string'));
   end
end
   
end