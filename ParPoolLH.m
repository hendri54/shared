classdef ParPoolLH < handle
   
properties
   nWorkers  uint16 = 4;
   profile  char = 'local';
end

properties (Dependent)
   maxWorkers  uint16
end
   
methods
   function pS = ParPoolLH(varargin)
      if ~isempty(varargin)
         functionLH.input_parse(varargin, pS);
      end
   end
   
   
   % Determine max number of workers in a given pool
   function nMax = get.maxWorkers(pS)
      myCluster = parcluster(pS.profile);
      nMax = uint16(myCluster.NumWorkers);
      validateattributes(nMax, {'uint16'}, {'scalar', '>=', 1, '<=', 1024})
   end
   
   
   % Open, unless it's already open
   function open(pS)
      if ~pS.is_open
         % Cannot request more workers than feasible
         pS.nWorkers = min(pS.nWorkers, pS.maxWorkers);
         if pS.nWorkers > 1
            parpool(pS.profile, pS.nWorkers);
         else
            warning('Cannot open parallel pool. Only 1 worker is available');
         end
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