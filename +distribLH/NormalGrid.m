% Approximate Normal distribution on a grid
%{
The grid is defined by bounds that can be set in various ways

Related: norm_grid_lh (for a given grid; should be integrated here +++)
%}
classdef NormalGrid < handle
   
properties
   % Upper bounds of grid points
   % There is NO implied open ended top grid interval
   ubV  double
   % Lower bound of lowest grid interval
   lb1  double
   
   dbg = false
end

properties (Dependent)
   % No of grid points
   ng
   % Bounds of intervals around grid points
   lbV
   % Mid points
   midPointV
   % Edges
   edgeV
end


methods
   %% Constructor
   %{
   Initialize with a grid, but that can be changed later
   %}
   function ngS = NormalGrid(lb1, gridUbV)
      ngS.ubV = gridUbV(:);
      ngS.lb1 = lb1;
   end

   
   %% Get dependent objects
   function ngOut = get.ng(ngS)
      ngOut = length(ngS.ubV);
   end
   
   function lbOutV = get.lbV(ngS)
      lbOutV = [ngS.lb1; ngS.ubV(1 : (end-1))];
   end
   
   function outV = get.edgeV(ngS)
      outV = [ngS.lb1; ngS.ubV];
   end
   
   function midV = get.midPointV(ngS)
      midV = (ngS.lbV + ngS.ubV) ./ 2;
   end

   
   %% Validate
   function validate(ngS)
      if ~isinf(ngS.ubV(end))
         nEnd = ngS.ng;
      else
         nEnd = ngS.ng - 1;
      end
      validateattributes(ngS.ubV(1 : nEnd), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing'})
      
      if ~isinf(ngS.lb1)
         validateattributes(ngS.lb1, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '<', ngS.ubV(1)})
      end
   end

   
   
   
   %% Set grid with equal probability points
   %{
   Top and bottom bounds are Inf
   %}
   function set_grid_equal_prob(ngS, nPoints, xMean, xStd)
      % Cumulative probabilities at grid upper bounds
      cumProbV = linspace(1 / nPoints, 1, nPoints);
      % Upper bounds
      ngS.ubV = norminv(cumProbV, xMean, xStd)';
      ngS.lb1 = -Inf;

      % Output check
      if ngS.dbg
         ngS.validate;
         % Check that mass is indeed uniform
         massV = ngS.grid_mass(xMean, xStd);
         checkLH.approx_equal(massV, ones(ngS.ng, 1) ./ ngS.ng, 1e-3, []);
      end
   end
   
   
   
   %% Mass in each grid interval for given mean, std
   %{
   Mass can be 0
   %}
   function massV = grid_mass(ngS, xMean, xStd)
      % Cdfs at upper bounds
      % Lightspeed normcdf is an order of magnitude faster than the built in (2017)
      cdfV = lightspeed.normcdf(ngS.edgeV, xMean, xStd);
      massV = diff(cdfV);
      if ngS.dbg
         validateattributes(massV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
            'size', [ngS.ng,1]})
      end
   end
   
   
end



methods (Static)
   %% Grid bounds
   function [lbV, ubV] = grid_bounds(gridV, dbg)
      ng = length(gridV);
      midPointV = 0.5 .* (gridV(1:(ng-1)) + gridV(2 : ng));
      lbV = [-Inf; midPointV(:)];
      ubV = [midPointV(:); Inf];
   end

   
end

end