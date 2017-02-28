function [fBothV, f1V, f2V] = compare_fields(s1, s2)
% Given 2 structures, make a list of fields that common, only in s1, only in s2

fn1V = fieldnames(s1);
fn2V = fieldnames(s2);

% All field names
fnV = unique([fn1V(:); fn2V(:)]);

in1V = ismember(fnV, fn1V);
in2V = ismember(fnV, fn2V);

fBothV = fnV(in1V & in2V);
f1V = fnV(in1V  &  ~in2V);
f2V = fnV(in2V  &  ~in1V);


end