% List of variables
classdef VarList < handle
      
properties
   % Cell array of dataLH.Variable
   listV  cell
end


properties (Dependent)
   % No of variables
   nVars  uint16
end
   
methods
   %% Constructor
   %{
   IN
      cell array of dataLH.Variable
   %}
   function vlS = VarList(listV)
      vlS.listV = listV(:);
   end
   
   
   function n = get.nVars(vlS)
      n = uint16(length(vlS.listV));
   end
   
   
   %% Does variable exist?
   function out1 = var_exists(vlS, varName)
      out1 = ~isempty(vlS.find_by_name(varName));
   end
   
   
   %% Rename variable
   %{
   Changes original name and name of Variable
   %}
   function var_rename(vlS, oldName, newName)
      % Make sure variable exists
      vIdx = vlS.find_by_name(oldName);
      assert(length(vIdx) == 1,  'Variable not found');
      vlS.listV{vIdx}.origNameStr = newName;
      vlS.listV{vIdx}.nameStr = newName;
   end
   
   
   %% Add variables
   % Must not exist, unless skipExisting = true
   function add_variables(vlS, addListV, skipExisting)
      if nargin < 3
         skipExisting = false;
      end
      assert(isa(addListV, 'cell'));
      
      existV = false(size(addListV));
      for i1 = 1 : length(addListV)
         varName = addListV{i1}.nameStr;
         existV(i1) = vlS.var_exists(varName);
      end
      
      if ~skipExisting  &&  any(existV)
         error('Some variables already exist');
      end
      
      % Only add variables that don't yet exist
      vlS.listV = [vlS.listV; addListV(~existV)];
   end
   
   
   %% Drop variables
   function drop_variables(vlS, dropListV)
      for i1 = 1 : length(dropListV)
         vIdx = vlS.find_by_name(dropListV{i1});
         assert(~isempty(vIdx),  'Variable not found');
         vlS.listV(vIdx) = [];
      end
   end
   
   
   %% List all variable names
   function importNameV = names(vlS)
      importNameV = cell(size(vlS.listV));
      for i1 = 1 : length(vlS.listV)
         importNameV{i1} = vlS.listV{i1}.nameStr;
      end
   end
   
   
   %% Find all variables of a particular type (e.g. continuous)
   %{
   OUT
      vIdxV
         index into varList.listV
      nameV
         cell array with variable names;
   %}
   function [vIdxV, nameV] = find_variables(vlS, typeStr)
      if vlS.nVars == 0
         vIdxV = [];
         nameV = [];
         return;
      end
      
      % Examine each variable
      validV = false([vlS.nVars, 1]);
      for i1 = 1 : vlS.nVars
         varS = vlS.listV{i1};
         switch typeStr
            case 'continuous'
               validV(i1) = ~isequal(varS.vClass, 'logical')  &&  ~varS.isDiscrete;
            case 'logical'
               validV(i1) = isequal(varS.vClass, 'logical');
            case 'discrete'
               validV(i1) = varS.isDiscrete;    
            case 'categorical'
               validV(i1) = isequal(varS.vClass, 'categorical');
            otherwise
               error('Invalid');
         end
      end
      
      vIdxV = find(validV);
      
      % Names
      nameV = cell(size(vIdxV));
      for i1 = 1 : length(vIdxV)
         nameV{i1} = vlS.listV{vIdxV(i1)}.nameStr;
      end
   end
   


   %% Find one variable by name
   %{
   OUT
      vIdx
         index into listV
         [] if not found
   %}
   function vIdx = find_by_name(vlS, varName)
      vIdx = [];
      for i1 = 1 : length(vlS.listV)
         if isequal(varName, vlS.listV{i1}.nameStr)
            vIdx = i1;
            break;
         end
      end
   end
   
   
   %% Retrieve info for one variable
   %{
   OUT
      dataLH.Variable object for that variable
      [] if not found
   %}
   function varS = retrieve(vlS, varName)
      vIdx = vlS.find_by_name(varName);
      if isempty(vIdx)
         varS = [];
      else
         varS = vlS.listV{vIdx};
      end
   end
end
   
end
