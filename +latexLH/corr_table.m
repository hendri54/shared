function [tbM, tbS] = corr_table(corrM, varNameV)
% Make a latex table with correlations
%{
IN:
   corrM
      table with correlation coefficients
   varNameV
      variable names

OUT:
   tbM
      cell array with variable names (headers) and corr coefficients
   tbS  ::  struct
      can be passed to latex_textb function
%}


%% Set up table

nVar = size(corrM, 1);
nr = 1 + nVar;
nc = 1 + nVar;
tbM = cell([nr, nc]);
tbS.rowUnderlineV = zeros([nr, 1]);
tbS.rowUnderlineV(1) = 1;


%% Table body

for iVar = 1 : nVar
   ir = 1 + iVar;
   % Header
   tbM{ir,1} = varNameV{iVar};
   tbM{1, ir} = tbM{ir, 1};

   for iVar2 = iVar : nVar
      tbM{ir, 1 + iVar2} = sprintf('%.2f', corrM(iVar,iVar2));
   end
end


end