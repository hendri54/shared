function beta_pdf_plot(pAlphaV, pBetaV)
% Exploring the beta distribution for given parameters

dS = makedist('Beta', 'a', 2, 'b', 4);
xV = linspace(0, 1, 100);

figS = FigureLH('visible', true);
figS.new;
hold on;

legendV = cell(size(pAlphaV));

for i1 = 1 : length(pAlphaV)
   dS.a = pAlphaV(i1);
   dS.b = pBetaV(i1);
   pdfV = dS.pdf(xV);
   
   figS.plot_line(xV, pdfV, i1);
   legendV{i1} = sprintf('a: %.1f  b: %.1f', dS.a, dS.b);
end


hold off;
xlabel('x');
ylabel('Density');
legend(legendV,  'location', 'eastoutside');
figS.format;

pause;
figS.close;


end