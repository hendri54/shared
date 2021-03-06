% Class to load and save variables (usually generated by models)
%{
Project should define a subclass that sets
- list of admissible variables
- method to determine variable file name
- possibly override save / load methods
%}
classdef SavedVariable < handle
      
properties
   % Version (so that one can check whether a file was generated by current version of code)
   version  double = []
   
   % List of acceptable variable names
   varListV  cell
   
   % Default directory for files (may not be used, but useful for testing)
   fileDir  char
end

methods
   %% Constructor
   function vS = SavedVariable(versionIn, fileDir)
      vS.version = versionIn;
      vS.fileDir = fileDir;
   end
   
   
   %% Save
   function save(vS, saveS, varName, varargin)
      % Check that variable exists
      assert(ismember(varName, vS.varListV),  'Invalid variable name');
      
      % Construct 
      fn = vS.var_fn(varName, varargin);
      
      vS.save_given_name(saveS, fn);
   end
   
   
   %% Load
   function [saveS, metaS] = load(vS, varName, varargin)
      fn = vS.var_fn(varName, varargin);
      [saveS, metaS] = vS.load_given_name(fn);
   end
   
   
   %% Dummy function to generate file names
   % Each project overrides this method, but we need a stub for the code to compile
   function [fn, fDir] = var_fn(vS, varName, varargin)
      if isempty(vS.fileDir)
         fDir = pwd;
      else
         fDir = vS.fileDir;
      end
      fn = fullfile(fDir, [varName, '.mat']);
   end
   
   
   %% Save for given file name
   function save_given_name(vS, saveS, fn)
      fDir = fileparts(fn);
      
      if ~isempty(fDir)
         if ~exist(fDir, 'dir')
            filesLH.mkdir(fDir, 0);
         end
      end
      
      metaS = struct;
      metaS.version = vS.version;
      
      save(fn, 'saveS', 'metaS');
   end
   
   
   %% Load for given file name
   %{
   Returns [] if file does not exist
   %}
   function [saveS, metaS] = load_given_name(vS, fn)
      if exist(fn, 'file')
         load(fn, 'saveS', 'metaS');
      else
         saveS = [];
         metaS = [];
      end      
   end
end
   
end
