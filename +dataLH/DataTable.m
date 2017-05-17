% Extends table for additional methods and meta info about variables
%{
%}
classdef DataTable < handle
      
properties
   % Data table
   tbM  table = []
   % List of variables.
   varList  dataLH.VarList = []
end


properties (Dependent)
   % No of observations
   nObs  uint16
end


methods
   %% Constructor
   function dS = DataTable(tbM, varList)
      dS.tbM = tbM;
      dS.varList = varList;
      dS.validate;
   end
   
   function n = get.nObs(dS)
      n = uint16(size(dS.tbM, 1));
   end
   
   
   %% Validate
   function validate(dS)
      % Check that variables match
      varList1V = dS.tbM.Properties.VariableNames;
      varList2V = dS.varList.names;
      diff1V = setdiff(varList1V, varList2V);
      diff2V = setdiff(varList2V, varList1V);
      if ~isempty(diff1V)  ||  ~isempty(diff2V)
         disp('Differences in variable names:');
         if ~isempty(diff1V)
            displayLH.show_string_array(diff1V, 80, 111);
         end
         if ~isempty(diff2V)
            displayLH.show_string_array(diff2V, 80, 111);
         end
         error('Quitting');
      end
      %assert(isequal(sort(varList1V(:)), sort(varList2V(:))),  'Variable names do not match');
   end
   
   
   %% Rename variable
   %{
   Purpose: the file contains a variable that can take on one of several names
   Rename it so that its name is known
   %}
   function rename_variable(dS, oldNameV, newName)
      if ischar(oldNameV)
         oldNameV = {oldNameV};
      end
      
      % Make sure the new name does not exist (unless it is one of the old names)
      if ~ismember(newName, oldNameV)
         assert(~dS.var_exists(newName),  ['Variable  [',  newName,  ']  already exists']);
      end
      
      % Make sure only one of the old names exists
      idx1 = [];
      for i1 = 1 : length(oldNameV)
         if dS.var_exists(oldNameV{i1})
            assert(isempty(idx1),  'More than one variable found');
            idx1 = i1;
         end
      end
      oldName = oldNameV{idx1};
      
      % Rename that variable
      idx2 = find(strcmp(oldName, dS.tbM.Properties.VariableNames));
      dS.tbM.Properties.VariableNames{idx2} = newName;
      dS.varList.var_rename(oldName, newName);
   end
   
   
   %% Add variable
   % Must not exist
   function add_variable(dS, xV, varS)
      % Check that variable does not exist
      assert(~dS.var_exists(varS.nameStr),  'Variable already exists');
      
      dS.tbM.(varS.nameStr) = xV;
      dS.varList.add_variables({varS});
   end
   
   
   %% Drop variable
   function drop_variable(dS, varName)
      dS.tbM.(varName) = [];
      dS.varList.drop_variables({varName});
   end
   
   
   %% Does variable exist?
   function out1 = var_exists(dS, varName)
      out1 = dS.varList.var_exists(varName);
   end
   
   
   %% Retrieve by name
   %{
   Output [] if not found
   %}
   function [xV, varS] = retrieve(dS, varName)
      varS = dS.varList.retrieve(varName);
      if isempty(varS)
         xV = [];
      else
         xV = dS.tbM.(varName);
      end
   end
   
   
   %% Summary table: logical variables
   %{
   OUT
      outM  ::  cell
   %}
   function outM = summary_tb_logical(dS)
      dS.validate;
      vIdxV = dS.varList.find_variables('logical');
      if isempty(vIdxV)
         outM = [];
         return;
      end
      
      outM = cell(2 + size(dS.tbM,1),  3);
      
      ir = 1;
      outM(ir,:) = {'Variable', 'FracMiss', 'FracTrue'};
      
      for i1 = vIdxV(:)'
         varS = dS.varList.listV{i1};
         varName = varS.nameStr;
         xV = dS.tbM.(varName);

         n = length(xV);
         fracMiss = (n - length(xV)) ./ n;
         
         xV(isnan(xV)) = [];
         n = length(xV);
         
         fracTrue = sum(xV == true) ./ n;
         
         ir = ir + 1;
         outM(ir,:) = {varName,  sprintf('%.1f', 100 .* fracMiss),  sprintf('%.1f', 100 .* fracTrue)};
      end
      
      outM((ir+1) : end, :) = [];
   end
   
   
   %% Summary table: continuous variables
   function outM = summary_tb_continuous(dS)
      dS.validate;
      vIdxV = dS.varList.find_variables('continuous');
      if isempty(vIdxV)
         outM = [];
         return;
      end
      
      outM = cell(2 + size(dS.tbM,1),  6);
      
      ir = 1;
      outM(ir,:) = {'Variable', 'FracMiss',  'Median', 'Mean', 'Std', 'Range'};
      
      for i1 = vIdxV(:)'
         varS = dS.varList.listV{i1};
         varName = varS.nameStr;
         xV = double(dS.tbM.(varName));
         n = length(xV);
         xV(isnan(xV)) = [];
         
         fracMiss = (n - length(xV)) ./ n;
         xMean = mean(xV);
         xStd = std(xV);
         xMin = min(xV);
         xMax = max(xV);
         xMedian = median(xV);
         
         ir = ir + 1;
         outM(ir,:) = {varName,  sprintf('%.1f', 100 .* fracMiss),  sprintf('%.2f', xMedian),  ...
            sprintf('%.2f', xMean),  sprintf('%.2f', xStd), ...
            sprintf('[%.2f, %.2f]', xMin, xMax)};
      end
      
      outM((ir+1) : end, :) = [];
   end
end
   
end
