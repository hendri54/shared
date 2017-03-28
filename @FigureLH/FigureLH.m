% Figure class
classdef FigureLH < handle
   
   
properties
   % Figure handle
   fh
   % Axes handle
   axesHandle
   % Figure type: 'line', 'bar'
   figType  char
   % Color scheme :: string
   colorScheme
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
   

properties (Dependent)
   % Line colors
   colorM
end

   
methods
   %% Constructor
   % Just populate properties
   function fS = FigureLH(varargin)
      if ~isempty(varargin)
         fS.set_options(varargin);
      else
         fS.set_options({'visible', false});
      end
   end
   
   
   %% Set options based on inputs
   % Use default if not provided
   function set_options(fS, argListV)      
      propertyV = {'colorScheme', 'height', 'width', 'visible', 'lineWidth', 'figFontName', 'figFontSize', ...
         'legendFontSize', 'figType', 'saveFigFile', 'figFileDir', 'figNoteV', 'dbg', ...
          'screenHeight',  'screenWidth'};
      defaultV  = {'default',       3,       3 * 1.61,   true,    2,          'Times',       10, ...
         10,                'line',       true,       'figData',  [],  111, ...
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
      
      if length(xV) < 16
         lineStyleStr = fS.line_style(iLine);
      else
         lineStyleStr = fS.line_style_dense(iLine);
      end
      
      plot(xV, yV, lineStyleStr, 'color', fS.line_color(iLine), 'LineWidth', fS.lineWidth);
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
   
   
   %% Format
   function format(fS)
      hold off;
      % Make a struct with options
      optS.figFontSize = fS.figFontSize;
      optS = struct_lh.merge(fS, optS, fS.dbg);
      figures_lh.format(fS.fh, fS.figType, optS);
   end
   
   
   %% Set axis range
   % To keep something at default: set to NaN
   function axis_range(fS, axisV)
      axis0V = axis;
      idxV = find(~isnan(axisV));
      axis0V(idxV) = axisV(idxV);
      axis(axis0V);
   end   
   
   
   %% Get info for a line
   function colorV = line_color(fS, iLine)
      n = size(fS.colorM, 1);
      i1 = integer_lh.sequential_bounded(iLine, n);
      colorV = fS.colorM(i1, :);
   end
   
   % Line styles when many points are used
   function lineStyle = line_style_dense(fS, iLine)
      lineTypeV = {'-', '--', '-.', ':'};
      n = length(lineTypeV);
      i1 = integer_lh.sequential_bounded(iLine, n);
      lineStyle = lineTypeV{i1};
   end
   
   % Markers for non-connected plots
   function markerOut = marker(fS, iLine)   
      markerV = 'odx+*s^vph';
      n = length(markerV);
      i1 = integer_lh.sequential_bounded(iLine, n);
      markerOut = markerV(i1);
   end
   
   % Line styles when few points are used
   function lineStyle = line_style(fS, iLine)
      lineStyle = [fS.marker(iLine), fS.line_style_dense(iLine)];
   end
   
   
   
   %% Text objects
   function text(fS,  x, y, str)
      validateattributes(y, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      assert(isa(str, 'char'));
      text(fS.axesHandle, x, y, str,  'Fontsize', fS.figFontSize,  'FontName', fS.figFontName);
   end

   
   
   %% Set color matrix
   function outM = get.colorM(fS)
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