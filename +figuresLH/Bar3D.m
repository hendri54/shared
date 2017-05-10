% 3D bar graph
%{
Just a better interface for the matlab bar graph
%}
classdef Bar3D < handle
   
properties
   % Data to plot
   data_xyM    double
   
   % Formatting info
   visible  logical = true
   xLabel   char = 'x';
   yLabel   char = 'y';
   zLabel   char = 'z';
   zLimV    double
   colorM   double
   
   % FigureLH object
   figureS    FigureLH
   
   dbg  uint16 = 1
end



methods
   %% Constructor: shows the graph
   function bS = Bar3D(data_xyM, varargin)
      bS.set_default_colors;
      bS.data_xyM = data_xyM;
      [nx, ny] = size(data_xyM);
      
      % Variable arguments
      n = length(varargin);
      for i1 = 1 : 2 : (n - 1)
         bS.(varargin{i1}) = varargin{i1+1};
      end

      bS.figureS = FigureLH('visible', bS.visible, 'figType', 'bar');
      bS.figureS.new;
      
      % Keep in mind that the x axis shows the 2nd dimension of the matrix (!)
      bar3(data_xyM');
      xlabel(bS.xLabel);
      ylabel(bS.yLabel);
      zlabel(bS.zLabel);
      if ~isempty(bS.zLimV)
         zlim(bS.zLimV);
      end
      view([-45, 45]);
      set(gca, 'XTick', 1 : nx);
      set(gca, 'YTick', 1 : ny); 
      bS.format;
   end
   
   
   %% Format
   function format(bS)
      bS.figureS.format;
      % Set a colormap that works better for 3d bar graphs
      colormap(bS.colorM);
   end
   
   
   %% Default color map
   function set_default_colors(bS)
      n = 10;
      bS.colorM = [repmat(0.7, [n,1]),  linspace(0.6, 0.4, n)',  linspace(0.2, 0.6, n)'];
   end
   
   
   % Set figure notes
   function fig_notes(bS, figNoteV)
      bS.figureS.fig_notes(figNoteV);
   end
   
   
   %% Save
   function save(bS, figFn, saveFigures)
      bS.figureS.save(figFn, saveFigures);
   end
   
   
   %% Close
   function close(bS)
      bS.figureS.close;
   end
   
   
   %% Write text table with underlying data
   %{
   IN
      outFn  ::  char
         path for output table
   %}
   function text_table(bS, outFn, fmtStr)
      [nx, ny] = size(bS.data_xyM);
      dataM = cell([nx+1, ny+1]);
      
      dataM{1,1} = [bS.xLabel, ' / ', bS.yLabel];
      
      % Header row
      for iy = 1 : ny
         dataM{1, iy+1} = sprintf('%i', iy);
      end
      
      % Header column
      for ix = 1 : nx
         dataM{ix+1, 1} = sprintf('%i', ix);
      end
      
      % Body
      for ix = 1 : nx
         for iy = 1 : ny
            dataM{ix+1, iy+1} = sprintf(fmtStr, bS.data_xyM(ix,iy));
         end
      end

      % ***  Write
      % Make extension, if none given
      tbFn = filesLH.change_extension(outFn, '.txt', false, bS.dbg);
      fp = fopen(tbFn, 'w');
      rowUnderlineV = [1; zeros([nx, 1])];
      cellLH.text_table(dataM, rowUnderlineV, fp, bS.dbg);
      fclose(fp);
   end
end
   
   
end