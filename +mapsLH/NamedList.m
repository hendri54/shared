% List of named objects with unique names
%{
This is really a dictionary (mapping from char -> any)
Example: List of model variables with descriptions
%}
classdef NamedList < handle
   
properties
   % No of variables stored
   n  uint16
   % Cell array of objects to be stored
   dataV  cell
   % List of names (for efficiency)
   nameV  cell
   % Name of the 'name' field
   nameField  char
end


methods
   %% Constructor
   function vl = NamedList(nMax, nameField)
      vl.n = 0;
      vl.nameField = nameField;
      vl.dataV = cell(nMax, 1);
      vl.nameV = cell(nMax, 1);
   end
   
   
   %% Does a variable exist in the list?
   function outVal = exist(vl, nameIn)
      if vl.n > 0
         outVal = any(strcmp(nameIn, vl.nameV));
      else
         outVal = false;
      end
   end
   
   
   %% Add one
   function add(vl, dataIn)
      varName = dataIn.(vl.nameField);
      if vl.exist(varName)
         error('Name already exists');
      end
      vl.n = vl.n + 1;
      vl.dataV{vl.n} = dataIn;
      vl.nameV{vl.n} = varName;
   end
   
   
   %% Retrieve one
   function dataOut = retrieve(vl, nameIn)
      dataOut = [];
      if vl.n <= 0
         return;
      end
      outIdx = find(strcmp(nameIn, vl.nameV), 1, 'first');
      if isempty(outIdx)
         return;
      end
      dataOut = vl.dataV{outIdx};
   end
   
   
   %% Add many
   function add_group(vl, varListV)
      assert(isa(varListV, 'cell'));
      for i1 = 1 : length(varListV)
         vl.add(varListV{i1});
      end
   end
   
   
   %% List all permitted variables
   function outV = get_list(vl)
      outV = vl.dataV(1 : vl.n);
   end
end
   
   
end