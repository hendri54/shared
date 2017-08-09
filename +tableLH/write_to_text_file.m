function write_to_text_file(tbM, tbDir, tbFn)
% Write table to text file
%{
Uses diary mechanism

needs testing +++++
%}

filesLH.mkdir(tbDir);

diaryS = filesLH.DiaryFile(fullfile(tbDir,  tbFn), 'new');
disp(tbM);
diaryS.close;
diaryS.strip_formatting;

end