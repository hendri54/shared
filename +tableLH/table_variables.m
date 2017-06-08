function [inBothV, inTableV, inVarNameV] = table_variables(tbM, varNameV)
% Given a table and a list of variables: report variables that are not in table / not in variable
% list / in both
%{
Purpose: Check which variables of a desired set are in a table. Perhaps to create a sub-table with
only those variables

OUT
   inBothV
      variables in table and varNameV
   inTableV
      variables only in table
   inVarNameV
      variables only in varNameV
%}

assert(isa(tbM, 'table'));

tbNameV = tbM.Properties.VariableNames;

inBothV = intersect(tbNameV, varNameV);

% Variables only in table, not in varNameV
inTableV = tbNameV(~ismember(tbNameV, varNameV));

% Variables only in varNameV, not in table
inVarNameV = varNameV(~ismember(varNameV, tbNameV));


end