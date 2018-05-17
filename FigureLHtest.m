function tests = FigureLHtest

tests = functiontests(localfunctions);

end


%% Subplots
function subPlotTest(tS)
   figS = FigureLH('visible', false);
   figS.new;
   
   subplot(2,1,1);
   figS.plot_line(1:20, sqrt(1:20), 1);
   xlabel('x label');
   ylabel('$y$ variable');
   figS.format;
   
   subplot(2,1,2);
   figS.plot_line(1:20, exp(2 - (1 : 20) ./ 10), 1);
   xlabel('x label');
   ylabel('$y$ variable');
   figS.format;
   
   compS = configLH.Computer([]);
   figS.save(fullfile(compS.testFileDir, 'FigureLHSubPlotTest'), true);
end


%% Grouped bar graph
function groupedBarTest(testCase)
   nx = 4;
   ny = 3;
   
   rng('default');
   data_xyM = rand(nx, ny);
   
   xLabelV = cell([nx, 1]);
   for ix = 1 :nx
      xLabelV{ix} = sprintf('x%i', ix);
   end
   yLabelV = stringLH.vector_to_string_array(1 : ny, 'y%i');

   compS = configLH.Computer([]);
   isVisible = false;
   % isVisible = true;

   fS = FigureLH('height', 3.5, 'width', 4.2, 'visible', isVisible, 'figType', 'bar');
   fS.new;

   % Grouped by y, for which we provide labels
   fS.bar_graph(data_xyM, yLabelV)
   fS.format;
   fS.save(fullfile(compS.testFileDir, 'FigureLHGroupedBarTest'), true);
end


%% Bar graph
function barTest(testCase)
   compS = configLH.Computer([]);
   isVisible = false;
   % isVisible = true;

   fS = FigureLH('height', 3.5, 'width', 4.2, 'visible', isVisible, 'figType', 'bar');
   fS.new;
   bar(1:5, sqrt(1:5)' * linspace(1,2, 4));
   fS.text(2, 3, 'Test text');
   fS.format;
   if isVisible
      pause;
   end
   fS.save(fullfile(compS.testFileDir, 'FigureLHBartest'), true);
   fS.close;
end


%% Line graph
function lineTest(testCase)

compS = configLH.Computer([]);
isVisible = false;
% isVisible = true;

fS = FigureLH('height', 3.5, 'width', 4.2, 'visible', isVisible);

fS.set_defaults;

for i1 = 1 : 20
   fS.line_style_dense(i1);
   fS.line_style(i1);
   fS.marker(i1);
   fS.line_color(i1);
end
clear fS;

fS = FigureLH('visible', isVisible, 'figNoteV', {'Line 1', 'Line 2'}, 'titleFontSize', 18);
fS.new;
fS.plot_line(1:10, sqrt(1:10), 1);
fS.plot_line(1:10, 0.5 .* sqrt(1:10), 2);
fS.plot_line(1:10, (1:10) .^ 0.3, 3);
fS.plot_line(1:10, (1:10) .^ 0.7, 4);
fS.plot_line(1:10, (1:10) .^ 0.2, 5);
fS.text(2, 3, 'Test text');
xlabel('$\phi(x)$');
ylabel('Normal text');
title('$e^{-x/2} \phi(x)$');
fS.format;
if isVisible
   pause;
end
fS.save(fullfile(compS.testFileDir, 'FigureLHtest'), true);
fS.close;


end