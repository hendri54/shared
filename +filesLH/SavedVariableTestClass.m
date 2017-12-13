% Class to test SavedVariable class
classdef SavedVariableTestClass < filesLH.SavedVariable
      
% properties
% end

methods
   %% Constructor
   function vS = SavedVariableTestClass
      compS = configLH.Computer([]);
      
      vS@filesLH.SavedVariable(1.2, compS.testFileDir);
      
      vS.varListV = {'SavedVariable1', 'SavedVariable2'};
   end
   
   % The signature is such that it matches superclass; because this will be passed `varargin` from
   % superclass `save_given_name` method
   % But it also must be possible to call the method just with 2 char arguments
   function [fn, fDir] = var_fn(vS, varName, varargin)
      assert(length(varargin) == 1,  'Expecting 1 input argument: setName');     
      setName = varargin{1};
      if isa(setName, 'cell')
         % Method was called with varargin from calling method
         setName = setName{1};
      end
      assert(isa(setName, 'char'),  'setName must be char');
      
      fDir = vS.fileDir;
      fn = fullfile(fDir, [varName, '_', setName, '.mat']);
      assert(isa(fn, 'char'),  'File name is not character');
   end
end
   
end
