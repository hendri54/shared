% Global optimization main routine
%{
User provided optimization function
- runs optimization given a starting guess
- returns: struct with 
      guessV: guess
      solnV: solution, 
      fVal:  objective, 
      exitFlag, 
      outS: optional additional outputs
To pass additional arguments: make an anonymous function with the args built in

Next: +++++
   adopt more code from globalsearch_lh
   show as points are found / solved (uitable?)
%}
classdef Problem

properties
   % Handle to optimization function
   fHandle
   % Starting guess
   guessV   double
   % Bounds for guesses (optional)
   guessLbV    double
   guessUbV    double
   % File name for optimization history
   historyFn   char
   % Start time
   startTime   datetime
   
   % *** Termination criteria
   % Max time in hours
   maxTime  double
   % Max number of points to evaluate
   maxPoints
   % fVal must fall by at least fToler in nRecent steps
   fToler   double  =  1e-3;
   nRecent  double
   
   % *** Selection of new points
   % Make new points from the nBest best points found so far
   nBest    double   = 10;
   % Probability of using random new point, not based on history
   probRandomPoint   double   = 0.2
   % Probabiliy of rejecting point in basin of attraction of another point
   probRejectInBasin    double   = 0.8
   
   % Show graph with optimization progress?
   showProgressGraph    logical  = true
   % Number of cpus to request
   nCpus  uint8 = 8
end

methods
   %% Constructor
   function pS = Problem(fHandle, guessV, varargin)
      pS.fHandle = fHandle;
      pS.guessV = guessV(:);
      n = length(guessV);
      
      % Defaults
      % effectively no bounds
      pS.guessLbV = -1e6 * ones(n, 1);
      pS.guessUbV =  1e6 * ones(n, 1);
      pS.maxTime = 1;
      pS.maxPoints = 100;
      pS.nRecent = 30;
      
      % Override defaults
      if ~isempty(varargin)
         for i1 = 1 : 2 : (length(varargin) - 1)
            pS.(varargin{i1}) = varargin{i1+1};
         end
      end
      
      % Make column vectors
      pS.guessLbV = pS.guessLbV(:);
      pS.guessUbV = pS.guessUbV(:);
      
      pS.validate;
   end
   
   
   %% Validate
   function validate(pS)
      validateattributes(pS.guessV,   {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
      validateattributes(pS.guessLbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(pS.guessV)})
      validateattributes(pS.guessUbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(pS.guessV)})
      validateattributes(pS.maxTime,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
      assert(length(pS.historyFn) > 2);
   end
   
   
   %% Generate new point
   %{
   This does not have access to the current state of pS!
   
   improve this +++
   reject if function value is poor (relative to history)
   reject points too close to something in history
   %}
   function newGuessV = new_point(pS)
      % Load history
      hfS = globalOptLH.HistoryFile(pS.historyFn);
      histS = hfS.load;
      
      % Load history, if any
      if histS.n >= pS.nBest
         [fValV, ~, ~, solutionM] = histS.retrieve_best(pS.nBest);
      end
      
      % Try new points until an acceptable one is found
      done = false;
      iTry = 0;
      maxTry = 50;
      while ~done
         % Make random new point
         wtV = rand(size(pS.guessLbV));
         newGuessV = wtV .* pS.guessLbV + (1 - wtV) .* pS.guessUbV;
         % Descriptive string
         descrStr = 'random guess';
         
         % With some probability, just use random point
         % Otherwise, take convex combination with a solution
         if rand(1,1) > pS.probRandomPoint
            if histS.n >= pS.nBest
               % Base on nBest best points so far
               idx1 = randi(size(solutionM, 2), [1, 1]);
               wt1 = rand(1, 1);
               newGuessV = wt1 .* solutionM(:,idx1) + (1 - wt1) .* newGuessV;
               descrStr = sprintf('guess based on point %i with weight %.2f',  idx1, wt1);
            end
         end
         
         % Is this point acceptable?
         inBasin = histS.in_basin(newGuessV);
         iTry = iTry + 1;
         done = true;
         
         if iTry <= maxTry
            % Evaluate this point
            % outS = feval(pS.fHandle, newGuessV, false);

            % Is function value acceptable
            % not sure how to test that +++

            % Is it in basin of attraction?
            if inBasin  &&  (rand(1,1) < pS.probRejectInBasin)
               done = false;
            end
         end
            
      end
      
      
      % Run optimization
      if inBasin
         basinStr = '  (in basin of attraction)';
      else
         basinStr = ' ';
      end
      disp(['New point:  ',  descrStr, basinStr]);
      
   end
   
   
   %% Solve
   %{
   OUT
      hfS :: HistoryFile
   %}
   function hfS = solve(pS)
      pS.startTime = datetime('now');
      
      % Open parallel pool
      parS = ParPoolLH('nWorkers', pS.nCpus);
      parS.open;
      
      % Initialize history file
      histS = globalOptLH.History(length(pS.guessV));
      hfS = globalOptLH.HistoryFile(pS.historyFn);
      hfS.save(histS);      
      clear histS;
      
      % Figure to show progress
      if pS.showProgressGraph
         figS = FigureLH('visible', true, 'figFontSize', 14);
         figS.new;
         hold off;
      end

      % Submit first job (with user provided guess)
      lastJob = 1;
      jobV(lastJob) = parfeval(pS.fHandle, 1, pS.guessV);

      % Make sure remaining jobs are canceled in case of interruption
      cancelFutures = onCleanup(@() cancel(jobV));

      p = gcp('nocreate');
      nParallel = p.NumWorkers;
      clear p;

      % Collect job outputs. Decide termination
      done = false;
      % Record which jobs are done
      doneV = false(pS.maxPoints, 1);
      
      while ~done
         % Submit more jobs if needed
         % If all jobs are submitted before the while loop, they all start running right away (so
         % they don't read the history file)
         nRunning = sum(~doneV(1 : lastJob));
         if nRunning < nParallel
            for i1 = 1 : (nParallel - nRunning)
               lastJob = lastJob + 1;
               newGuessV = pS.new_point;
               jobV(lastJob) = parfeval(pS.fHandle, 1, newGuessV);
               fprintf('Starting new job with ID  %i \n', lastJob);
            end
         end
         
         % Get results from next job
         [jobIdx,  outS] = fetchNext(jobV);
         doneV(jobIdx) = true;
         fprintf('Finished job ID  %i \n', jobIdx);
         
         % Write to history
         histS = hfS.add(outS.guessV, outS.solnV, outS.fVal, outS.exitFlag);
         if pS.showProgressGraph
            histS.show_progress(figS);
         end
         
         % Decide termination
         if all(doneV)
            done = true;
            terminationStr = 'All points finished';
         else
            [done, terminationStr] = pS.decide_termination(histS);
         end
      end
      
      fprintf('Terminating because:  %s \n',  terminationStr);
      fprintf('Number of points evaluated: %i.  Terminal fVal: %.3f \n', sum(doneV),  histS.retrieve_best(1));

      % Cancel pending jobs (automatic when function ends)
      cancel(jobV);
   end

      
   %% Decide termination
   %{
   IN
      histS :: History
   %}
   function [done, msgStr] = decide_termination(pS, histS)
      done = false;
      msgStr = '';
      
      if datetime('now') > pS.startTime + hours(pS.maxTime)
         done = true;
         msgStr = 'Max time exceeded';
      end
      
      % Check progress over last N points
      if histS.n > pS.nRecent
         % Best point before last n
         bestBefore = min(histS.fValV(1 : (histS.n - pS.nRecent)));
         % Best point since last n
         bestSince = min(histS.fValV((histS.n - pS.nRecent + 1) : histS.n));
         if bestSince > bestBefore + pS.fToler
            done = true;
            msgStr = 'Insufficient recent progress';
         end
      end
   end
end

end