classdef ParPoolLH < handle
   
properties
   nWorkers = 4;
   profile = 'local';
end
   
methods
   function pS = ParPoolLH
   end
   
   % Open, unless it's already open
   function open(pS)
      if ~pS.is_open
         parpool(pS.profile, pS.nWorkers);
      end
   end
   
   % Close, if open
   function close(pS)
      if pS.is_open
         delete(gcp('nocreate'));
      end
   end
   
   % Is it open
   function isOpen = is_open(pS)
      p = gcp('nocreate');
      isOpen = ~isempty(p);
   end
end
   
end