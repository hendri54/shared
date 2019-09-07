% Backup and restore Matlab preferences
%{
Substantive testing is difficult b/c it overwrites preferences or their backups
%}
classdef MatlabPreferences
   
properties
   % e.g. R2016a
   versionStr  char
end

methods

   %% Constructor
   function pS = MatlabPreferences(versionStr)
      if nargin < 1
         versionStr = [];
      end
      if isempty(versionStr)
         pS.versionStr = pS.version_string;
      else
         pS.versionStr = versionStr;
      end
   end

   
   %% Backup
   function backup(pS)
      tgDir = pS.target_dir(pS.versionStr);
      filesLH.mkdir(tgDir);

      result = inputLH.ask_confirm('Back up preferences', []);
      if result
         copyfile(prefdir, tgDir);
      else
         disp('skipped');
      end
   end
   
   
   %% Restore
   function restore(pS, verStr)
      srcDir = pS.target_dir(verStr);
      tgDir  = prefdir; 
      
      result = inputLH.ask_confirm('Restore preferences', []);
      if result
         nameV = {'cwdhistory.m', 'History.xml', 'matlab.prf', 'matlab.settings', 'MATLABDesktop.xml', ...
            'shortcuts_2.xml'};
         for i1 = 1 : length(nameV)
            copyfile(fullfile(srcDir, nameV{i1}),  fullfile(tgDir, nameV{i1}));
         end
      else
         disp('skipped');
      end
   end
end


methods (Static)
   %% Current version as string (R2016a)
   function verStr = version_string
      % Release in format (2016a)
      verS = ver;
      verStr = verS(1).Release;
      if verStr(1) == '('
         verStr(1) = [];
      end
      if verStr(end) == ')'
         verStr(end) = [];
      end
      fprintf('Current version: %s \n',  verStr);
      
      assert(verStr(1) == 'R');
      assert(length(verStr) == 6);
   end


   %% Target dir
   function tgDir = target_dir(verStr)
      tgDir = '/Users/lutz/Documents/data/software/matlab';
      assert(exist(tgDir, 'dir') > 0);
      tgDir = fullfile(tgDir, verStr);
   end


end

end