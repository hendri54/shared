function tbM = regr_table(mdlV, varNameV, varLabelV, modelNameV, dbg)
% Given a set of LinearModel's, make a formatted text table (cell array of strings)
%{
This can be directly passed into LatexTableLH or similar

Table format
   row 1: header
   col 1: header
   others: coefficients  and  std errors, R2, N

IN
   mdlV
      vector of LinearModel
   varNameV
      variables to display
   varLabelV
      headers for these variables
   modelNameV
      col headers
%}

nVar = length(varNameV);
nModels = length(mdlV);

% Table dimensions
nr = 1 + nVar * 2 + 2;
nc = 1 + nModels;
tbM = cell(nr, nc);

% Rows for each variable
varRowV = 2 : 2 : (2*nVar);
rR2 = varRowV(end) + 2;
rN  = rR2 + 1;


%% Loop over models
for iModel = 1 : nModels
   ic = 1 + iModel;
   % Wrap this in {} for `siunitx` package
   tbM{1, ic} = ['{',  modelNameV{iModel},  '}'];
   
   % Get outputs to be put into table
   outS = regressLH.format_regr_output(mdlV{iModel}, varNameV, dbg);
   
   % Loop over variables
   for iVar = 1 : nVar
      ir = varRowV(iVar);
      tbM{ir, ic} = outS.betaV{iVar};
      tbM{ir+1, ic} = outS.seBetaV{iVar};
      if iModel == 1
         tbM{ir, 1} = varLabelV{iVar};
      end
   end
   
   % R2 and N
   tbM{rR2, ic} = outS.r2Str;
   tbM{rN, ic} = outS.nObsStr;
   if iModel == 1
      tbM{rR2, 1} = '$R^2$';
      tbM{rN, 1} = '$N$';
   end
end


end