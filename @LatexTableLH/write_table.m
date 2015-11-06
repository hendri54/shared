function write_table(tS)
% Write table to latex file

% Open file
fid = fopen(tS.filePath, 'w');
if fid < 0
   errorLH('Cannot open file');
end


%% Alignment of header columns

fprintf(fid, '%s', '\begin{tabular}{');

% Header
fprintf(fid, '%s', tS.alignHeader);

% Body columns
for ic = 1 : tS.nc
   % Left column line
   if tS.colLineV(ic) == 1
      fprintf(fid, '|');
   end
   if tS.colWidthV(ic) > 0.001
      fprintf(fid, 'p{%3.2fin}', tS.colWidthV(ic));
   else
      fprintf(fid, '%s', tS.alignV{ic});
   end
end

% Right end line
if tS.colLineV(end) == 1
   fprintf(fid, '|');
end
fprintf(fid, '%s\n', '}');


% Headers for columns
fprintf(fid, '%s\n', '\hline');
fprintf(fid, ' & %s \n',  latexLH.table_row(tS.colHeaderV));
fprintf(fid, '%s\n', '\hline');



%% Write the table body

for ir = 1 : tS.nr
   if isempty(tS.lineStrV{ir})
      fprintf(fid, '%s & %s \n',  tS.rowHeaderV{ir}, latexLH.table_row(tS.tbM(ir,:)));
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
      fprintf(fid, '%s\n', '\hline');
   end
end

% Closing underline
fprintf(fid, '%s\n', '\hline');
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


% if tbS.showOnScreen == 1
%    latex_lh.text_table_lh(dataM, tbS);
% end

% % Also create text file?
% if ~isempty(fPath)  &&  tbS.createTextFile
%    [fDir, fName] = fileparts(fPath);
%    fid2 = fopen(fullfile(fDir, [fName, '.txt']), 'w');
%    tbS.fp = fid2;
%    latex_lh.text_table_lh(dataM, tbS);
%    fclose(fid2);
% end




end