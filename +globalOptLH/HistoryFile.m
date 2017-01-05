% History file for parallel optimization
%{
To initialize: save with empty History
%}
classdef HistoryFile < handle

properties
   filePath    char
end


methods
   %% Constructor
   function hfS = HistoryFile(filePath)
      hfS.filePath = filePath;
   end
   
%    %% Initialize
%    function initialize(hfS)
%       saveS = globalOptLH.History;
%       hfS.save(saveS);
%    end
   
   %% Load
   function loadS = load(hfS)
      x = load(hfS.filePath, 'saveS');
      loadS = x.saveS;
   end
   
   %% Save
   function save(hfS, saveS)
      save(hfS.filePath, 'saveS');
   end
   
   
   %% Add an entry
   %{
   OUT
      histS :: History
   %}
   function histS = add(hfS, guessInV, solnInV, fVal, exitFlag)
      histS = hfS.load;
      histS.add(guessInV, solnInV, fVal, exitFlag);
      hfS.save(histS);
   end
end
   
   
end