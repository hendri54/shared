% Multivariate normal distribution
%{
Mainly for drawing scaled Normal variables given a lower triangular weight matrix
(which is the Cholesky decomp of the cov matrix)

Can handle cases where variables have zero std
Then weight matrix must have zeros in that row / column
%}
classdef MultiVarNormal
   
properties
   % n x 1 vector of means
   meanV
   % n x 1 vector of std deviations (marginals)
   stdV
end


methods
   % Constructor
   function mS = MultiVarNormal(meanV, stdV)
      mS.meanV = meanV;
      mS.stdV  = stdV;
      if any(stdV < 0)
         error('Negative std');
      end
   end
   
   
   %%  Make a lower triangular weight matrix into a cov matrix
   %{
   OUT
      covMatM
         cov matrix implied by wtM and stdV
   %}
   function covMatM = cov_from_weights(mS, wtM, dbg)
      n = length(mS.meanV);
      
      % *****  Input check
      if dbg > 10
         validateattributes(wtM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,n]})
         % Check that wtM is lower triangular
         for i1 = 1 : n
            if wtM(i1,i1) ~= 1
               error('Diagonal should be 1');
            end
            if i1 < n
               if any(wtM(i1, (i1+1) : n) ~= 0)
                  error('Not lower triangular');
               end
            end
            if mS.stdV(i1) == 0
               % Must have 0 weights
               idxV = 1 : n;
               idxV(i1) = [];
               if any(wtM(i1,idxV) ~= 0)  ||  any(wtM(idxV, i1) ~= 0)
                  error('Invalid wtM');
               end
            end
         end
      end

      % *****  Main
      
      % Scale the weight matrix so that it is the Cholesky decomposition of the Cov matrix
      wt2M = wtM;
      for i1 = 1 : n
         wt2M(i1,:) = wtM(i1,:) ./ sqrt(sum(wtM(i1,:) .^ 2)) .* mS.stdV(i1);
      end
      
      covMatM = wt2M * (wt2M');
      % Scale this
%       std2V = sqrt(diag(covMatM));
%       stdRatioV = mS.stdV ./ std2V;
%       covMatM = covMatM .* (stdRatioV * ones(1, n)) ./ (ones(n,1) * stdRatioV');
      
      % *******  Output check
      if dbg > 10
         validateattributes(covMatM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,n]});
         % Diagonal should be variances
         std2V = sqrt(diag(covMatM));
         checkLH.approx_equal(std2V(:), mS.stdV, 1e-5, []);
      end
   end
   
   
   %%  Draw random variables given weight matrix
   %{
   For reproducability: set random seed before calling this
   %}
   function randM = draw_given_weights(mS, nObs, wtM, dbg)
      nVar = length(mS.meanV);
      
      % Make cov matrix
      covMatM = mS.cov_from_weights(wtM, dbg);
      % Draw random variables using built in function
      randM = mvnrnd(mS.meanV(:)',  covMatM,  nObs);
      
%       % Scale them
%       randM = zeros([nObs, nVar]);
%       for iVar = 1 : nVar
%          randM(:,iVar) = (varM(:, iVar) - mean(varM(:,iVar))) ./ std(varM(:,iVar)) .* mS.stdV(iVar) + mS.meanV(iVar);
%       end
      
      % Output check
      if dbg > 10
         validateattributes(randM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nObs, nVar]})
      end
   end
   
   
   %% Compute conditional distribution of a set of variables, given the others
   %{
   IN:
      covM
         covariance matrix
      idx2V
         indices of variables on which we condition
      value2V
         their values
   OUT:
      condMeanV, condStdV
         conditional means and std of each variable, given all others
   %}
   function [condMeanV, condStdV, condCovM] = conditional_distrib(mS, idx2V, value2V, covM, dbg)
      
      % ******* Input check
      nVars = length(mS.meanV);
      if dbg > 10
         validateattributes(idx2V, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, ...
            '<=', nVars})
         validateattributes(value2V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
         if ~isequal(size(idx2V), size(value2V))
            error('Size mismatch');
         end
         validateattributes(covM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nVars, nVars]})
         std2V = sqrt(diag(covM));
         checkLH.approx_equal(std2V(:), mS.stdV, 1e-6, []);
      end
      
      
      % *******  Main
      
      % Indices of unknowns
      idx1V = 1 : nVars;
      idx1V(idx2V) = [];
      
      sigma11 = covM(idx1V, idx1V);
      sigma12 = covM(idx1V, idx2V);
      sigma21 = covM(idx2V, idx1V);
      sigma22 = covM(idx2V, idx2V);
      mu1V = mS.meanV(idx1V);
      mu2V = mS.meanV(idx2V);
      
      condMeanV = (mu1V(:)' + ((value2V(:)' - mu2V(:)') / sigma22) * sigma21)';
      condCovM  = sigma11 - (sigma12 / sigma22) * sigma21;
      condStdV  = sqrt(diag(condCovM));
      condStdV  = condStdV(:);
      
      
      % ******* Output check
      if dbg > 10
         n1 = length(idx1V);
         validateattributes(condMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
            'size', [n1, 1]})
         validateattributes(condStdV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
            '>=', 0,  'size', [n1, 1]})
         validateattributes(condCovM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
            'size', [n1, n1]})
      end
   end
   
end
   
end