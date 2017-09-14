classdef MatlabEditor < handle
   
properties
   % File for saved state
   stateFileName  char
end

methods
   %% Constructor
   function meS = MatlabEditor
      compS = configLH.Computer([]);
      meS.stateFileName = fullfile(compS.sharedDirV{1}, 'editor_state.mat');
   end
   
      
   %% Close all open files +++++
   
   
   %% Generate object with editor state
   function sS = get_state(meS)
      sS = configLH.MatlabEditorState;      
   end
   
   
   %% Save editor state
   function save_state(meS, fileName)
      sS = configLH.MatlabEditorState;
      if nargin < 2
         fileName = meS.stateFileName;
      end
      save(fileName,  'sS');
   end
   
   
   %% Load editor state
   function sS = load_state(meS, fileName)
      if nargin < 2
         fileName = meS.stateFileName;
      end
      sS = load(fileName);
      sS = sS.sS;
      assert(isa(sS,  'configLH.MatlabEditorState'));
   end
   
   
   %% Restore state
   function restore_state(meS, fileName)
      if nargin < 2
         fileName = meS.stateFileName;
      end
      sS = meS.load_state(fileName);
      sS.restore_state;      
   end
end
   
end