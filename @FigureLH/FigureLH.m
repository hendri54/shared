% Figure class
%{
Produces formatted figures that can be saved to PDF (requires `export_fig`)

Flow
1. Constructor: figS = FigureLH(...)
2. Plot: figS.plot_line(...)
3. Add xlabel, title, etc using standard commands
4. Format: figS.format
5. Save: figS.save

Working with subplots:
Works just like regular plotting. Each subplot requires its own `format` command.
%}
classdef FigureLH < handle
   
   
properties
   % Figure handle
   fh
   % Axes handle
   axesHandle
   % Figure type: 'line', 'bar'
   figType  char
   % Background color (for area surrounding plot)
   backGroundColor = 'w'
   % Color scheme :: string
   colorScheme
%    % Color map where this can be used
%    colorMap  char = 'autumn'
   % Color matrix
   colorM  double
   
   % Height, width in inches (for printing)
   height  double
   width  double
   % The same in pixes (for screen)
   screenHeight  double
   screenWidth  double
   % Visible?
   visible  logical
   
   lineWidth  double
   figFontName  char
   figFontSize  double
   legendFontSize  double
   titleFontSize  double
   
   % Figure file info
   % Extension, such as '.pdf'
   figExt  char
   % Format, such as 'pdf'
   fileFormat  char
   % Save file with figure data ('.fig')?
   saveFigFile  logical = true
   % Sub-dir for figure data file
   figFileDir  char
   % Save file with figure notes? If so, populate this string vector
   figNoteV  cell = []
   
   % Debug level
   dbg
end
   

% properties (Dependent)
%    % Line colors
%    colorM
% end

   
methods
   %% Constructor
   % Just populate properties
   function fS = FigureLH(varargin)
      fS.colorM = fS.default_colors;
      if ~isempty(varargin)
         fS.set_options(varargin);
      else
         fS.set_options({'visible', false});
      end
      
      fS.validate;
   end
   
   
   %% Validate
   function validate(fS)
      assert(ismember(fS.visible, [true, false]));
   end
   
   
   %% Set options based on inputs
   % Use default if not provided
   function set_options(fS, argListV)      
      propertyV = {'colorScheme', 'height', 'width', 'visible', 'lineWidth', 'figFontName', 'figFontSize', ...
         'legendFontSize', 'titleFontSize', 'figType', 'saveFigFile', 'figFileDir', 'figNoteV', 'dbg', ...
          'screenHeight',  'screenWidth'};
      defaultV  = {'default',       3,       3 * 1.61,   true,    2,          'Latex',       10, ...
         10,                12,              'line',       true,       'figData',  [],  111, ...
         800, 800 * 1.61};

      % Parse the input args
      p = inputParser;
      for i1 = 1 : length(propertyV)
         addParameter(p, propertyV{i1}, defaultV{i1});
      end
      parse(p, argListV{:});
      
      % Copy into object
      for i1 = 1 : length(propertyV)
         pName = propertyV{i1};
         fS.(pName) = p.Results.(pName);
      end
      
      fS.fh = [];
      fS.figExt = '.pdf';
      fS.fileFormat = 'pdf';
   end
   
   % Set figure notes
   function fig_notes(fS, noteV)
      fS.figNoteV = noteV;
   end
   
   
   %% New figure
   %{
   Open a new figure window
   Put hold on, so we can plot into it
   %}
   function new(fS)
      if fS.visible
         visStr = 'on';
      else
         visStr = 'off';
      end

      % Position for screen
      fS.fh = figure('Units','pixels',...
         'Position',[1, 1, fS.screenWidth, fS.screenHeight],...
         'PaperPositionMode','auto',  'visible', visStr);
      fS.axesHandle = gca;      
      
      hold on;
   end
   
   
   %% Close
   function close(fS)
      if ~isempty(fS.fh)
         close(fS.fh);
         fS.fh = [];
      end
   end
   
   
   
   
   %% Plot a line
   function plot_line(fS, xV, yV, iLine)
      % Open figure if needed
      if isempty(fS.fh)
         fS.new;
      end
      hold on;

      if length(xV) < 16
         lineStyleStr = fS.line_style(iLine);
      else
         lineStyleStr = fS.line_style_dense(iLine);
      end
      
      plot(xV, yV, lineStyleStr, 'color', fS.line_color(iLine), 'LineWidth', fS.lineWidth);
   end
   
   
   %% Plot 45 degree line
   function plot45(fS, iLine)
      axisV = axis;
      x1 = min(axisV([1,3]));
      x2 = max(axisV([2,4]));
      xV = linspace(x1, x2, 50);
      fS.plot_line(xV, xV,  iLine);
   end
   
   
   %% Plot a vertical line
   function plot_vertical(fS, xV, iLineV)
      yV = ylim;
%       axisV = axis;
%       y1 = min(axisV([2, 4]));
%       y2 = max(axisV([2, 4]));
      for ix = 1 : length(xV)
         fS.plot_line([xV(ix), xV(ix)], yV,  iLineV(ix));      
      end
   end
   
   
   %% Scatter plot
   function plot_scatter(fS, xV, yV, iLine)
      % Open figure if needed
      if isempty(fS.fh)
         fS.new;
      end
      
      if length(xV) < 200
         markerStr = 'o';
      else
         markerStr = '.';
      end
      
      plot(xV, yV, markerStr, 'color', fS.line_color(iLine));
   end

   
   %% Add regression line and display it
   function add_regression_line(fS, xV, yV, wtV)
      [lineHandle, outStr] = figuresLH.regression_line(xV, yV, wtV);
      set(lineHandle, 'Color', 'k');
      
      % show the string (positioning is crude)
      axisV = axis;
      x1 = axisV(1) + 0.1 * (axisV(2) - axisV(1));
      y1 = axisV(3) + 0.1 * (axisV(4) - axisV(3));
      text(x1, y1, outStr);
   end

   
%    %% Format
%    function format(fS)
%       hold off;
%       % Make a struct with options
%       optS.figFontSize = fS.figFontSize;
%       optS = struct_lh.merge(fS, optS, fS.dbg);
%       figures_lh.format(fS.fh, fS.figType, optS);
%    end
   
   
   %% Set axis range
   % To keep something at default: set to NaN
   function axis_range(fS, axisV)
      axis0V = axis;
      idxV = find(~isnan(axisV));
      axis0V(idxV) = axisV(idxV);
      axis(axis0V);
   end   
   
   
   %%  Format axes
   function format_axes(fS)
      axes_handle = gca;
      
      set(axes_handle,  'Units', 'normalized', ...
         'FontUnits','points', 'FontWeight','normal', 'Box', 'off', ...
         'FontSize',  fS.figFontSize,  'FontName', fS.figFontName);

      axes_handle.TickLabelInterpreter = 'LaTeX';
      axes_handle.LineWidth = 1;

      grid(axes_handle, 'on');
      % Light grey
      axes_handle.GridColor = ones(1, 3) .* 0.75;

      xl = get(axes_handle, 'XLabel');
      if ~isempty(xl)
         axes_handle.XLabel.Interpreter = 'LaTeX';
         set(xl, 'Fontsize', fS.figFontSize, 'FontName', fS.figFontName);
      end
      
      yl = get(axes_handle, 'yLabel');
      if ~isempty(yl)
         axes_handle.YLabel.Interpreter = 'LaTeX';
         set(yl, 'Fontsize', fS.figFontSize, 'FontName', fS.figFontName);
      end
   end
   
   
   %% Format lines (if any)
   function format_lines(fS)
      % Get line handles. May be []
      ax = gca;
      lineHandleV = findobj(ax, 'Type', 'Line');

      if ~isempty(lineHandleV)
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
   end

   
   %% Format bars in bar graph (if any)
   function format_bars(fS)
      % Set color map for bar graphs
      %  seems to have no effect on line graphs
      %colormap(fS.colorMap);
      axes_handle = gca;

      % Get handles to bar objects
      barV = get(axes_handle, 'Children');
      if ~isempty(barV)
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
   end
   
   
   %% Format title
   function format_title(fS)
      ax = gca;
      ax.Title.Interpreter = 'LaTeX';
      ax.Title.FontSize = fS.titleFontSize;
   end
   
   
   %% Format legend
   function format_legend(fS)
      ax = gca;
      lHandle = ax.Legend;  
      if ~isempty(lHandle)
         set(lHandle, 'FontUnits', 'points', 'FontSize', fS.legendFontSize, 'FontName', fS.figFontName);
         ax.Legend.Interpreter= 'Latex';
         
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

   
   %% Get info for a line
   function colorV = line_color(fS, iLine)
      n = size(fS.colorM, 1);
      i1 = integerLH.sequential_bounded(iLine, n);
      colorV = fS.colorM(i1, :);
   end
   
   % Line styles when many points are used
   function lineStyle = line_style_dense(fS, iLine)
      lineTypeV = {'-', '--', '-.', ':'};
      n = length(lineTypeV);
      i1 = integerLH.sequential_bounded(iLine, n);
      lineStyle = lineTypeV{i1};
   end
   
   % Markers for non-connected plots
   function markerOut = marker(fS, iLine)   
      markerV = 'odx+*s^vph';
      n = length(markerV);
      i1 = integerLH.sequential_bounded(iLine, n);
      markerOut = markerV(i1);
   end
   
   % Line styles when few points are used
   function lineStyle = line_style(fS, iLine)
      lineStyle = [fS.marker(iLine), fS.line_style_dense(iLine)];
   end
   
   
   
   %% Text objects
   %{
   Writes to fS.axesHandle, which is set during `new`. Could fail with subplots.
   %}
   function text(fS,  x, y, str)
      validateattributes(y, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      assert(isa(str, 'char'));
      text(fS.axesHandle, x, y, str,  'Fontsize', fS.figFontSize,  'FontName', fS.figFontName);
   end

   
   
   %% Set color matrix
   % This works for line graphs, but not well for 3d bar graphs
   function outM = default_colors(fS)
      % Set default colors muted
      xV = 0.2 : 0.15 : 0.96;
      ncol = length(xV);
      outM = zeros([2 * ncol, 3]);
      for ix = 1 : length(xV)
         x = xV(ix);
         outM(ix,:) = [1-x, 0.4, x];
         outM(ncol + ix, :) = [1-x, x, 0.4];
      end
   end
   
   
   %% Set defaults for all figures
   function set_defaults(fS)
      % Set default line width
      set(0, 'DefaultLineLineWidth', fS.lineWidth);

      set(0, 'DefaultAxesColorOrder', fS.colorM);


      set(0, 'defaultAxesFontName', fS.figFontName);
      set(0, 'defaultTextFontName', fS.figFontName);      
   end
   
end
   
   
end