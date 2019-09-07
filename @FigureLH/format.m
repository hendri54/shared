function format(fS)
% Format a figure
%{
For printing with export_fig

To make this work with subplots, this formats the current axes. But it uses fS.fh as figure handle
%}

hold off;


%% Get figure info

axes_handle = gca;

% Get line handles. May be []
lineHandleV = findobj(axes_handle, 'Type', 'Line');


% Type of graph
iBar = 1;
iLine = 2;

% What type of figure
if ~isempty(fS.figType)
   if strcmpi(fS.figType, 'bar')
      iFigType = iBar;
   elseif strcmpi(fS.figType, 'line')
      iFigType = iLine;
   else
      error('Invalid fS.figType');
   end
else
   iFigType = [];
end

% Another try at figuring out figure type
if isempty(iFigType)
   if isempty(lineHandleV)
      iFigType = iBar;
   else
      iFigType = iLine;
   end
end


%%  Format

if ~isempty(fS.backGroundColor)
   set(fS.fh, 'color', fS.backGroundColor);
end


fS.format_axes;
fS.format_legend;
fS.format_title;
fS.format_lines;

% % Make sure figure size is correct
% set(fS.fh,'PaperUnits', 'inches');
% papersize = get(fS.fh, 'PaperSize');
% left = (papersize(1)- figOptS.width)/2;
% bottom = (papersize(2)- figOptS.height)/2;
% myfiguresize = [left, bottom, figOptS.width, figOptS.height];
% set(gcf,'PaperPosition', myfiguresize);


% Set axis so that labels are not truncated when in latex
% This does not work for subplots
% set(gca, 'Units', 'normalized',  'Position', [0.15 0.2 0.75 0.7]);



if iFigType == iBar
   fS.format_bars;
end







%%  Tick labels

% Ensure that small numbers are not displayed in scientific notation
% in which case the exponent gets truncated
% axisV = axis;
% if axisV(4) < 0.01  &&  axisV(4) > 0
%    yTickV = get(gca, 'YTick');
%    set(gca,'YTickLabel', sprintf('%.3f',yTickV))
% end

% Set tick labels
% set(gca, 'XTick', -pi : pi/2 : pi);
% set(gca,'XTickLabel',{'-pi','-pi/2','0','pi/2','pi'})

% 
% % Get current labels. Char array
% %xTickM = get(gca, 'XTickLabel');
% %[nTick, nLen] = size(xTickM);
% 
% % Make new labels
% xTickValueV = xV(1) : 1 : xV(end);
% nTick = length(xTickValueV);
% xTickStrV = cell([nTick,1]);
% for i1 = 1 : nTick
%    xTickStrV{i1}=sprintf('%4.1f', xTickValueV(i1));
% end
% 
% set(gca, 'XTick', xTickValueV,  'XTickLabel', xTickStrV);





end