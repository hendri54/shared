function save(figS, figFn, saveFigures)
% Save a figure as pdf or eps
%{
Make dir if it does not exist

IN
   figFn
      incl dir, no extension
   slideOutput
      format with larger fonts etc
%}

dbg = 111;

% ****  Output settings for the type

if strcmpi(figS.fileFormat, 'pdf')
   figExtStr = '.pdf';
   painterStr = '-pdf';
elseif strcmpi(figS.fileFormat, 'eps')
   figExtStr = '.eps';
   painterStr = '-eps';
else
   error('Invalid');
end



%% Make dir

% Try to extract the fig dir
[figDir, figName] = fileparts(figFn);
if isempty(figDir)
   error('Need a directory');
end

% Create fig dir if necessary
if ~exist(figDir, 'dir')
   filesLH.mkdir(figDir, dbg);
end


%% Save figure
if saveFigures == 1
   % Set figure position for printing

   figS.fh.Units = 'inches';
   figS.fh.Position = [1, 1, figS.width, figS.height];

   export_fig([figFn, figExtStr], painterStr, '-painters', '-r600', '-nocrop');
   
   if figS.saveFigFile
      % Which dir?
      figFileDir = figS.figFileDir;
      % Is path relative to current dir?
      if isempty(strfind(figFileDir, filesep))
         figFileDir = fullfile(figDir, figFileDir);
      end
      
      if ~exist(figFileDir, 'dir')
         filesLH.mkdir(figFileDir);
      end
      
      % Also save as FIG file
      hgsave(gcf, fullfile(figFileDir, figName));
   end
   
   close;
   disp(['Saved figure:  ',  figFn, figExtStr]);

else
   disp(['Figure name:   ',  figFn]);
   pause;
   close;
end

end % eof
