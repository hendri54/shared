classdef ProjectListLH < handle
   
properties
   % This is where list of projects is stored
   fileNameStr  char
   projectV  cell
   n  double
end

methods
   %% Constructor
   %{
   IN
      fileNameStr
         defaults to value from const_lh
   %}
   function plS = ProjectListLH(fileNameStr)
      lhS = const_lh;
      if nargin < 1
         fileNameStr = lhS.projectFile;
      end
      if isempty(fileNameStr)
         fileNameStr = lhS.projectFile;
      end
      
      plS.fileNameStr = fileNameStr;
      plS.projectV = cell(300, 1);
      plS.n = 0;
   end
   
   
   %% Append projects
   %{
   IN
      newV :: cell array
         Each is a ProjectLH object
   %}
   function append(plS, newV)
      if ~isa(newV, 'cell')
         newV = {newV};
      end
      for i1 = (1 : length(newV))
         plS.n = plS.n + 1;
         plS.projectV{plS.n} = newV{i1};
      end
   end
   
   
   %% Save to file
   function save(plS)
      projectV = plS.projectV;
      n = plS.n;
      save(plS.fileNameStr,  'projectV',  'n');
   end
   
   
   %% Load from file
   function load(plS)
      load(filesLH.fullpaths(plS.fileNameStr), 'projectV', 'n');
      plS.projectV = projectV;
      plS.n = n;
   end
   
   
   %% Retrieve by name (not by suffix!)
   function projectS = retrieve(plS, nameStr)
      if plS.n == 0
         plS.load;
      end
      projectS = [];
      for i1 = 1 : plS.n
         if strcmp(plS.projectV{i1}.nameStr, nameStr)
            projectS = plS.projectV{i1};
            break;
         end
      end
   end
   
   
   %% Retrieve by suffix
   function projectS = retrieve_suffix(plS, suffixStr)
      if plS.n == 0
         plS.load;
      end
      projectS = [];
      for i1 = 1 : plS.n
         if strcmp(plS.projectV{i1}.suffixStr, suffixStr)
            projectS = plS.projectV{i1};
            break;
         end
      end
   end
   
   
   %% Restore editor state from file
   function restore_state(plS, suffixStr)
      pS = plS.retrieve_suffix(suffixStr);
      assert(~isempty(pS));
      pS.restore_state;
   end
end
   
end