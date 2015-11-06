% Variable list
%{
Make a list of unique names
%}
classdef VariableListLH < handle
   
properties
   % No of variables stored
   n
   % List of unique names
   varNameV
end


methods
   %% Constructor
   function vl = VariableListLH(nMax)
      vl.n = 0;
      vl.varNameV = cell(nMax, 1);
   end
   
   
   %% Does a variable exist in the list?
   function outVal = exist(vl, varName)
      if vl.n > 0
         outVal = any(strcmp(varName, vl.varNameV));
      else
         outVal = false;
      end
   end
   
   
   %% Add one
   function add(vl, varName)
      if vl.exist(varName)
         error('Variable already exists');
      end
      vl.n = vl.n + 1;
      vl.varNameV{vl.n} = varName;
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
      outV = vl.varNameV(1 : vl.n);
   end
end
   
   
end