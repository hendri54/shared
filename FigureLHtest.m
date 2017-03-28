function tests = FigureLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

lhS = const_lh;
isVisible = false;

fS = FigureLH('height', 3.5, 'width', 4.2, 'visible', false);

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
fS.save(fullfile(lhS.dirS.testFileDir, 'FigureLHtest'), true);
fS.close;


end