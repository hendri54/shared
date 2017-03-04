% Variable list
%{
Make a list of unique names
%}
classdef VariableListLH < handle
   
properties
   % No of variables stored
   n  uint16
   % List of unique names
   varNameV  string
   % Descriptions
   descrV  string
end


methods
   %% Constructor
   function vl = VariableListLH(nMax)
      vl.n = 0;
      vl.varNameV = strings(nMax, 1);
      vl.descrV = strings(nMax, 1);
   end
   
   
   %% Does a variable exist in the list?
   function outVal = exist(vl, varName)
      if vl.n > 0
         outVal = any(ismember(varName, vl.varNameV));
      else
         outVal = false;
      end
   end
   
   
   %% Add one
   function add(vl, varName, descrStr)
      if nargin < 3
         descrStr = varName;
      end
      
      if vl.exist(varName)
         error('Variable already exists');
      end
      
      vl.n = vl.n + 1;
      vl.varNameV(vl.n) = varName;
      vl.descrV(vl.n) = descrStr;
   end
   
   
   %% Add many
   function add_group(vl, varListV, descrListV)
      assert(isa(varListV, 'cell')  ||  isa(varListV, 'string'))
      if nargin < 3
         descrListV = varListV;
      end

      for i1 = 1 : length(varListV)
         vl.add(varListV{i1}, descrListV{i1});
      end
   end
   
   
   %% List all permitted variables
   function [outV, descrListV] = get_list(vl)
      outV = vl.varNameV(1 : vl.n);
      descrListV = vl.descrV(1 : vl.n);
   end
end
   
   
end