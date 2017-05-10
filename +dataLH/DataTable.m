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
   end
   
   function n = get.nObs(dS)
      n = uint16(size(dS.tbM, 1));
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
      vIdxV = dS.varList.find_variables('continuous');
      if isempty(vIdxV)
         outM = [];
         return;
      end
      
      outM = cell(2 + size(dS.tbM,1),  5);
      
      ir = 1;
      outM(ir,:) = {'Variable', 'FracMiss', 'Mean', 'Std', 'Range'};
      
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
         
         ir = ir + 1;
         outM(ir,:) = {varName,  sprintf('%.1f', 100 .* fracMiss),  sprintf('%.2f', xMean),  sprintf('%.2f', xStd), ...
            sprintf('[%.2f, %.2f]', xMin, xMax)};
      end
      
      outM((ir+1) : end, :) = [];
   end
end
   
end
