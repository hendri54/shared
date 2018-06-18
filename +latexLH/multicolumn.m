function outStr = multicolumn(nCols, textStr)

outStr = sprintf('\\multicolumn{%i}{c}{%s}',  nCols, textStr);

end