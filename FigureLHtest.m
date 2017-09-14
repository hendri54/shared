function tests = FigureLHtest

tests = functiontests(localfunctions);

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

fS = FigureLH('visible', isVisible, 'figNoteV', {'Line 1', 'Line 2'});
fS.new;
fS.plot_line(1:10, sqrt(1:10), 1);
fS.plot_line(1:10, 0.5 .* sqrt(1:10), 2);
fS.text(2, 3, 'Test text');
fS.format;
if isVisible
   pause;
end
fS.save(fullfile(compS.testFileDir, 'FigureLHtest'), true);
fS.close;


end