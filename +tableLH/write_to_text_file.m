function write_to_text_file(tbM, tbFn)
% Write table to text file
%{
Uses diary mechanism

needs testing +++++
%}

fDir = fileparts(tbFn);
if ~isempty(fDir)
   filesLH.mkdir(fDir);
end

diaryS = filesLH.DiaryFile(tbFn, 'new');
disp(tbM);
diaryS.close;
diaryS.strip_formatting;

end