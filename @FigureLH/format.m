function format(fS)
% Format a figure
%{
%}

hold off;

%% Default inputs

% % Make sure we have a figure handle, not an axis handle
% if ~strcmp(get(fS.fh, 'type'), 'figure')
%    fS.fh = gcf;
% end

% defaultS = figures_lh.const;
% if isempty(cS)
%    cS = defaultS;
% end
% 
% % Copy all fields from cS into defaultS
% struct_lh.merge(cS, defaultS, fS.dbg);
% clear defaultS;


%% Get figure info

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


% Get axis handles
if isempty(fS.fh)
   fS.fh = gcf;
   axes_handle = gca;
else
   axes_handle = get(fS.fh, 'CurrentAxes');
end


% Get line handles
lineHandleV = findobj(axes_handle, 'Type', 'Line');
% disp('Change line width for one line only');
% set(lineHandleV(1), 'LineWidth', 2);

% Another try at figuring out figure type
if isempty(iFigType)
   if isempty(lineHandleV)
      iFigType = iBar;
   else
      iFigType = iLine;
   end
end


%%  Format figure area

% White background
set(fS.fh, 'color', 'w');


%%  Format axes

set(axes_handle,  'Units','normalized', ...
   'FontUnits','points', 'FontWeight','normal', 'Box', 'off', ...
   'FontSize',  fS.figFontSize,  'FontName', fS.figFontName);


grid(axes_handle, 'on');


xl = get(axes_handle, 'XLabel');
if ~isempty(xl)
   set(xl, 'Fontsize', fS.figFontSize, 'FontName', fS.figFontName);
end
yl = get(axes_handle, 'yLabel');
if ~isempty(yl)
   set(yl, 'Fontsize', fS.figFontSize, 'FontName', fS.figFontName);
end


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



%% Format bar graph
if iFigType == iBar

   % Set color map for bar graphs
   %  seems to have no effect on line graphs
   %colormap(fS.colorMap);

   % Get handles to bar objects
   barV = get(axes_handle, 'Children');
   if length(barV) > length(fS.colorM) / 2 
      % Not enough colors to set individually in fS.colorM
      colormap(fS.colorM);
   else
      % Set each color, skipping 1 color to get more contrast
      for i1 = 1 : length(barV)
         if strcmp(get(barV(i1), 'type'), 'bar')
            % This is a bar, not text
            set(barV(i1), 'Facecolor', fS.colorM(1 + (i1-1) * 2, :));
         end
      end
   end
end


%% Format line graph
if iFigType == iLine
   % ******  Markers
   for i1 = 1 : length(lineHandleV)
      mk = get(lineHandleV(i1), 'Marker');
      if ~isempty(mk)
         lColor = get(lineHandleV(i1), 'Color');
         set(lineHandleV(i1), 'MarkerFaceColor', lColor);
         lineHandleV(i1).LineWidth = fS.lineWidth;

         % Set marker size
         %  Odd: if no line, the marker disappears. Why?
         lStyle = get(lineHandleV(i1), 'LineStyle');
         if ~strcmp(lStyle, 'none')
            set(lineHandleV(i1), 'MarkerSize', 4);
         end
      end
   end
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



%%  Legend

lHandle = legend(axes_handle);
if ~isempty(lHandle)
   set(lHandle, 'FontUnits', 'points', 'FontSize', fS.legendFontSize, 'FontName', fS.figFontName);

   % Get position of legend: [x, y, w, h]
   %  w,h are width and height
   %  x,y is x,y position of legend
   % lPosV = get(lHandle, 'Position');

   % Turn off box around legend
   %legend(axes_handle, 'boxoff');

   % 
   % disp('More robust way of showing subset of legend objects');
   % % Plot entire legend
   % [legend_h, object_h, plot_h, textV] = legend(legendV);
   % % Now redraw with just the desired objects
   % legend(plot_h(1), legendV(1));
   % pause;
end


end