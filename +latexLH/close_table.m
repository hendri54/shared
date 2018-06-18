function close_table(fid)
% Close an open latex table

assert(fid > 0);

fprintf(fid, '%s \n',  '\bottomrule');
fprintf(fid, '%s \n',  '\end{tabular}');
fclose(fid);

end