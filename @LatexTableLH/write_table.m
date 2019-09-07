% Write table to latex file
%{
refactor +++
Requires booktabs package
%}
function write_table(tS)

tS.make_directory;

% Open file
fid = fopen(tS.filePath, 'w');
if fid < 0
   error('Cannot open file: \n  %s', tS.filePath);
end


%% Alignment of header columns

fprintf(fid,'%s \n', tS.align_block);


% Headers for columns
fprintf(fid, '%s\n', '\toprule');
for i1 = 1 : tS.nHeaderRows
   if isempty(tS.headerLineV{i1})
      if isempty(tS.topLeftCellV)
         topLeftStr = ' ';
      else
         topLeftStr = char(tS.topLeftCellV(i1));
      end
      fprintf(fid, '%s & %s \n',  topLeftStr,  latexLH.table_row(tS.colHeaderV(i1,:)));
   else
      fprintf(fid, '%s \\\\ \n',  tS.headerLineV{i1});
   end
   % Mainly for \cline commands
   if ~isempty(tS.headerSubLineV{i1})
      fprintf(fid, '%s \n', tS.headerSubLineV{i1});
   end
end
fprintf(fid, '%s\n', '\midrule');



%% Write the table body

for ir = 1 : tS.nr
   if isempty(tS.lineStrV{ir})
      fprintf(fid, '%s & %s \n',  tS.rowHeaderV{ir}, latexLH.table_row(tS.tbM(ir,:), tS.heatM(ir,:)));
   else
      % User provided line
      lineStr = tS.lineStrV{ir};
      fprintf(fid, '%s', lineStr);
      % Append \\ if needed
      if lineStr(end) == '\'
         fprintf(fid, ' \n');
      else
         fprintf(fid, ' \\\\ \n');
      end
   end
   
   % Underline this row
   if tS.rowUnderlineV(ir)
      fprintf(fid, '%s\n', '\midrule ');
   end
end

% Closing underline
fprintf(fid, '%s\n', '\bottomrule');
fprintf(fid, '%s\n', '\end{tabular}%');


%%  Table notes
% if isfield(tS, 'noteV')
%    fprintf(fid, '\n \\vspace{5 mm} \n');
%    fprintf(fid, '\\small \n');
%    for i1 = 1 : length(tbS.noteV)
%       fprintf(fid, tbS.noteV{i1});
%       fprintf(fid, '\n');
%    end
%    fprintf(fid, '\\normalsize \n');
% end




%% Clean up

fclose(fid);
[~, fName] = fileparts(tS.filePath);
disp(['Saved table ', fName]);


end