function pctV = sat2percentile(satV)
% Convert SAT scores to percentiles
%{
For combined math + critical reading
2015 data extracted from pdf

Scores below min value in data table are set to 0
%}

% Table with scores and percentiles
mf = mfilename('fullpath');
fDir = fileparts(mf);
m = readtable(fullfile(fDir, 'sat-percentile-ranks-composite-crit-reading-math-2015.xlsx'));

pctV = interp1(m.Score, m.Percentile ./ 100, double(satV), 'linear');

pctV(satV < min(m.Score)) = 0;

validateattributes(pctV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1})

end