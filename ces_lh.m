% CES aggregator of the form
%{
Y = A * [sum of (alpha X) ^ rho] ^ (1/rho)
Accommodates matrix inputs (T x N)

If N == 1:  Y = A * alpha * X
   This is useful for nested CES

When rho -> 0: Cobb Douglas, alphas must sum to 1

Inputs can be stored in the object or provided each time a method is called.
%}
classdef ces_lh
   properties
      substElast
      rho
      N
      % Optional inputs
      AV          % productivities, Tx1
      alphaM      % relative weights, TxN
      xM          % inputs, TxN
   end
   
   
   methods
      % ********  Constructor
      % Last 3 args are optional
      function fS = ces_lh(substElast, N,   AV, alphaM, xM)
         fS.substElast = substElast;
         fS.rho = 1 - 1 / fS.substElast;
         fS.N = N;

         % These can be []
         fS.AV = AV;
         fS.alphaM = alphaM;
         fS.xM = xM;
         
         fS.validate;
      end

      
      % ******  Validation
      function validate(fS)
         validateattributes(fS.substElast, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
         validateattributes(fS.N, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1})
         TV = [length(fS.AV), size(fS.alphaM, 1), size(fS.xM, 1)];
         T  = max(TV);
         % Optional inputs
         if ~isempty(fS.AV)
            validateattributes(fS.AV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
               'size', [T, 1]})
         end
         if ~isempty(fS.alphaM)
            validateattributes(fS.alphaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
               'size', [T, fS.N]})
%             if any(abs(sum(fS.alphaM, 2) - 1) > 1e-6)
%                error('alphaM must sum to 1');
%             end
         end
         if ~isempty(fS.xM)
            validateattributes(fS.xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
               'size', [T, fS.N]})
         end
      end
      
      
      % Returns sum([alpha * x] ^ rho)
      function qV = q(fS, alphaM, xM)
         % Column vector
         qV = sum((alphaM .* xM) .^ fS.rho, 2);
         validateattributes(qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [size(xM, 1), 1]})
      end
      
      
      %%  Output
      %{
      Can use inputs stored in object or not
      Not efficient, but convenient
      %}
      function yV = output(fS, AV, alphaM, xM)
         % Check whether inputs provided (fS is 1st input)
         if nargin == 1
            AV = [];
            alphaM = [];
            xM = [];
         end
         % Copy [] inputs (inefficient)
         if isempty(AV)
            AV = fS.AV;
         end
         if isempty(alphaM)
            alphaM = fS.alphaM;
         end
         if isempty(xM)
            xM = fS.xM;
         end
         
         if fS.N > 1
            if abs(fS.rho) > 1e-3
               yV = AV .* fS.q(alphaM, xM) .^ (1 / fS.rho);
            else
               yV = AV .* prod(xM .^ alphaM, 2);
            end
         else
            % Just 1 input
            yV = AV .* alphaM .* xM;
         end
         
         validateattributes(yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [size(xM, 1), 1]})
      end
      
      
      %%  Marginal products (TxN)
      %{
      Can use inputs stored in object or not
      Not efficient, but convenient
      %}
      function mpM = mproducts(fS, AV, alphaM, xM)
         % Check whether inputs provided (fS is 1st input)
         if nargin == 1
            AV = [];
            alphaM = [];
            xM = [];
         end
         % Copy empty inputs
         if isempty(AV)
            AV = fS.AV;
         end
         if isempty(alphaM)
            alphaM = fS.alphaM;
         end
         if isempty(xM)
            xM = fS.xM;
         end
         
         if fS.N > 1
            % Multiple inputs
            if abs(fS.rho) > 1e-3
               % CES
               qV = fS.q(alphaM, xM) .^ (1 / fS.rho - 1);
               mpM = ((AV .* qV) * ones(1, fS.N)) .* ((alphaM .* xM) .^ fS.rho) ./ xM;
            else
               % Cobb Douglas
               % Now alphas must sum to 1
               alphaSumV = sum(alphaM, 2);
               assert(all(abs(alphaSumV - 1) < 1e-6));
               n = size(xM, 2);
               yV = AV .* prod(xM .^ alphaM, 2);
               mpM = alphaM .* (yV * ones(1, n)) ./ xM;
            end
         else
            % 1 input
            mpM = AV .* alphaM;
         end
         %          axRhoM = (alphaM .* xM) .^ fS.rho;
         %          mpM = nan(size(xM));
         %          for j = 1 : fS.N
         %             mpM(:,j) = AV .* axRhoM(:,j) ./ xM(:,j) .* qV;
         %          end
                  
         validateattributes(mpM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [size(xM, 1), fS.N]})
      end
      
      
      %%  Factor weights from inputs and factor incomes
      %{
      factor income = mp * x
      IN
         alphaSum
            alphas sum to this number (normalization)
            with Cobb Douglas: alphas must sum to 1
      %}
      function [alphaM, AV] = factor_weights(fS, incomeM, xM, alphaSum)
         T = size(xM, 1);
         if fS.N > 1
            % Multiple inputs
            if abs(fS.rho) > 1e-3
               % CES (not Cobb-Douglas)
               % Weights relative to input 1
               alphaM = (incomeM ./ (incomeM(:,1) * ones(1, fS.N))) .^ (1 / fS.rho)  .*  ...
                  (xM(:,1) * ones(1, fS.N)) ./ xM;
               % Make sure they sum to 1
               alphaM = alphaM ./ (sum(alphaM,2) * ones(1, fS.N)) .* alphaSum;

            else
               % Cobb Douglas
               % alphas equal income shares
               alphaM = incomeM ./ (sum(incomeM, 2) * ones(1, fS.N));
            end
            
            % AV matches total incomes by t
            % Compute incomes implied by these alphas
            yInV = sum(incomeM, 2);
            yV = fS.output(ones(T,1), alphaM, xM);
            AV = yInV ./ yV;
            
         else
            % 1 input: y = A * alpha * X
            alphaM = ones(T, 1) .* alphaSum;
            AV = incomeM ./ xM ./ alphaSum;
         end
         
         validateattributes(alphaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', size(xM)})
         validateattributes(AV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      end
   end
   
end