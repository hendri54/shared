function bar_graph(fS, data_xyM, groupLabelV)
% Draw data by [x, y] as a bar graph
%{
Grouped by y
One bar for each x in the group

IN
   data_xyM
      data to plot
   groupLabelV  ::  cell or []
      label for each group of bars
%}

ny = size(data_xyM, 2);
assert(isequal(length(groupLabelV), ny),  'Group labels do not have correct length');

fS.figType = 'bar';
bar(1 : ny, data_xyM', 1);

xticks(1 :ny);
if ~isempty(groupLabelV)
   if isa(groupLabelV, 'cell')
      xticklabels(groupLabelV);
   else
      error('Invalid');
   end
end

end