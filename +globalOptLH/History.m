% Optimization history
%{
%}
classdef History < handle
   
properties
   % Array size
   nMax = 1e3
   % No of entries written
   n = 0
   % Starting guesses
   guessM   double
   % Solutions
   solnM    double
   % Function values
   fValV    double
   % Exit flags; standard matlab codes
   exitFlagV   double
   
   % Derived
   % Radius of basin of attraction: norm(solution - guess)
   radiusV   double
   
   % FigureLH that shows progress during optimization
   % progressFigure    FigureLH
end


methods
   %% Constructor
   function hS = History(guessLen)
      hS.guessM = zeros(guessLen, hS.nMax);
      hS.solnM  = zeros(guessLen, hS.nMax);
      hS.fValV  = zeros(hS.nMax, 1);
      hS.exitFlagV = zeros(hS.nMax, 1);
      
      hS.radiusV = zeros(hS.nMax, 1);
   end
   
   
   %% Add a point
   function add(hS, guessInV, solnInV, fVal, exitFlag)
      hS.n = hS.n + 1;
      hS.guessM(:, hS.n) = guessInV;
      hS.solnM(:, hS.n) = solnInV;
      hS.fValV(hS.n) = fVal;
      hS.exitFlagV(hS.n) = exitFlag;
      
      hS.radiusV(hS.n) = norm(solnInV - guessInV);
   end
   
   
   %% Is a point in the basin of attraction of any solution found so far?
   function inBasin = in_basin(hS, newGuessV)
      inBasin = false;
      if hS.n > 0
         for i1 = 1 : hS.n
            radius1 = norm(newGuessV - hS.solnM(:,i1));
            if radius1 < hS.radiusV(i1)
               inBasin = true;
               break;
            end
         end      
      end
   end
   
   
   %% Retrieve best N points
   %{
   Only among those that converged (see exitFlagV)
   But if there are fewer than nOut points in the history, include those that did not converge
   
   OUT
      fValOutV
         fVal for each solution
      outIdxV
         indices into the matrices that store info about each point
   %}
   function [fValOutV, outIdxV, guessOutM, solnOutM] = retrieve_best(hS, nOutIn)
      if hS.n <= 0
         guessOutM = [];
         solnOutM  = [];
         fValOutV  = [];
      else
         nOut = min(nOutIn, hS.n);
         [~, sortIdxV] = sort(hS.fValV(1 : hS.n) + 1e6 .* (hS.exitFlagV(1 : hS.n) <= 0));
         outIdxV = sortIdxV(1 : nOut);
         guessOutM = hS.guessM(:, outIdxV);
         solnOutM  = hS.solnM(:, outIdxV);
         fValOutV  = hS.fValV(outIdxV);
      end
   end
   
   
   %% Show history while optimization is running
   % Use an existing figure window (FigureLH)
   function show_progress(hS, figIn)
      if hS.n > 0
         figIn.plot_line(1 : hS.n,  hS.fValV(1 : hS.n),  1);
         xlabel('Iteration');
         ylabel('Function value');
         axisV = axis;
         
         % Truncate y axis at 10 times best point found
         fBest = min(hS.fValV(1 : hS.n));
         figIn.axis_range([NaN, NaN, NaN, fBest * 10]);
         
         x = axisV(1) + 0.1 * (axisV(2) - axisV(1));
         y = axisV(3) + 0.1 * (axisV(4) - axisV(3));
         figIn.text(x, y, sprintf('Best f: %.3g', min(hS.fValV(1 : hS.n))));
      end
   end
end
   
end