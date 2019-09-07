function outS = format_regr_output(mdl, varNameV, dbg)
% Format regression output into a set of string arrays
%{
The goal is to produce formatted strings that can simply be rearranged into a latex (or other)
table

IN
   mdl :: LinearModel
   varNameV :: vector of string
      variables to show
      may be []; then show all
OUT
   outS :: struct
      varNameV  ::  string
         variable names
      betaV  ::  string
         coefficients 
      seBetaV  ::  string
         beta std errors
         same no of decimal places as coefficients
      r2Str
         r squared
      nObsStr
         No of obs
   all formatted strings
%}


% For n/a
naStr = 'n/a';

if isempty(varNameV)
   % Get var names from model
   varNameV = string(mdl.CoefficientNames);
else
   varNameV = string(varNameV);
end

outS.varNameV = latexLH.format_for_table(varNameV);
nVar = length(varNameV);

outS.betaV = strings(nVar, 1);
outS.seBetaV = strings(nVar, 1);

for iVar = 1 : nVar
   % Find that variable
   idx = find(strcmp(varNameV(iVar), mdl.CoefficientNames));
   if length(idx) == 1
      outS.betaV(iVar) = sprintf('$%#.3g$',  mdl.Coefficients.Estimate(idx));
      outS.seBetaV(iVar) = ...
         ['$(',  stringLH.format_similar(char(outS.betaV(iVar)), mdl.Coefficients.SE(idx), dbg),  ')$'];
   else
      outS.betaV(iVar) = naStr;
      outS.seBetaV(iVar) = naStr;
   end
end

outS.r2Str = sprintf('$%#.2g$', mdl.Rsquared.Ordinary);
outS.nObsStr = sprintf('$%i$', mdl.NumObservations);

end


% %% Remove underscores from variable names
% % For Latex, they would have to be escaped
% function outV = format_for_latex(inV)
%    assert(isa(inV, 'cell'));
%    outV = inV;
%    for i1 = 1 : length(inV)
%       outV{i1} = strrep(inV{i1}, '_', ' ');
%       outV{i1} = latexLH.str_escape(outV{i1});
%    end
% end