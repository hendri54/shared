% 2 dimensional probability matrix
%{
Various ways of initializing a 2d probability matrix (joint distribution)
Then derive conditionals and marginals using Bayes rule
%}
classdef ProbMatrix2D < handle
   
   properties
      nx
      ny
      pr_xyM
      prX_yM
      prY_xM
      pr_xV
      pr_yV
   end
   
   methods
      %% Constructor 
      %{
      Provide inputs in pairs, such as 'prY_xM', prY_xM, ...
      Various combinations are permitted
      %}
      function pmS = ProbMatrix2D(varargin)
         pmS.nx = 0;
         
         % Extract fields
         fieldV = {'pr_xyM', 'prX_yM', 'prY_xM', 'pr_xV', 'pr_yV'};
         for i1 = 1 : length(fieldV)
            idx = find(strcmp(varargin, fieldV{i1}));
            if length(idx) == 1
               pmS.(fieldV{i1}) = varargin{idx+1};
            else
               pmS.(fieldV{i1}) = [];
            end
         end
         
         % Compute the other fields
         if ~isempty(pmS.prY_xM)  &&  ~isempty(pmS.pr_xV)
            pmS.input_pry_x;
         elseif ~isempty(pmS.pr_xyM)
            pmS.input_pr_xy;
         end
      end
      
      
      %% Validation
      function validate(pmS)
         validateattributes(pmS.nx, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 2})
         validateattributes(pmS.ny, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 2})
         if ~isequal(size(pmS.pr_xyM), [pmS.nx, pmS.ny])
            error('Invalid');
         end
         checkLH.prob_check(pmS.pr_xyM, []);
         checkLH.prob_check(pmS.pr_xV, 1e-7);
         checkLH.prob_check(pmS.pr_yV, 1e-7);

         validateattributes(pmS.prY_xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
            'size', [pmS.ny, pmS.nx]})
         checkLH.prob_check(pmS.prY_xM, 1e-7);
         
         validateattributes(pmS.prX_yM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
            'size', [pmS.nx, pmS.ny]})
         checkLH.prob_check(pmS.prX_yM, 1e-7);
         
         prob_xV = sum(pmS.pr_xyM, 2);
         checkLH.approx_equal(prob_xV(:), pmS.pr_xV, 1e-6, []);

         prob_yV = sum(pmS.pr_xyM, 1);
         checkLH.approx_equal(prob_yV(:), pmS.pr_yV, 1e-6, []);
      end
      
      
      %% Provide pr(x,y)
      function input_pr_xy(pmS)
         [pmS.nx, pmS.ny] = size(pmS.pr_xyM);
         
         pmS.pr_xV = sum(pmS.pr_xyM, 2);
         pmS.pr_xV  = pmS.pr_xV(:);
         pmS.pr_yV = sum(pmS.pr_xyM);
         pmS.pr_yV  = pmS.pr_yV(:);

         pmS.prY_xM = pmS.pr_xyM' ./  (ones(pmS.ny,1) * pmS.pr_xV(:)');
         pmS.prX_yM = pmS.pr_xyM  ./  (ones(pmS.nx,1) * pmS.pr_yV(:)');
         
         pmS.validate
      end
      
      
      %% Provide pr(y|x) and pr(x)
      function input_pry_x(pmS)
         [pmS.ny, pmS.nx] = size(pmS.prY_xM);
         
         % Pr(y) = sum over x of Pr(y|x) * Pr(x)
         pmS.pr_yV = sum(pmS.prY_xM, 2);
         pmS.pr_yV = pmS.pr_yV(:);
         
         % Pr(x,y) = pr(y|x) * pr(x)
         pmS.pr_xyM = (pmS.prY_xM .* (ones(pmS.ny,1) * pmS.pr_xV(:)'))';
         
         pmS.pr_xV  = sum(pmS.pr_xyM, 2);
         pmS.pr_xV  = pmS.pr_xV(:);
         
         pmS.pr_yV  = sum(pmS.pr_xyM, 1);
         pmS.pr_yV  = pmS.pr_yV(:);
         
         % Pr(x | y) = Pr(x,y) / Pr(y)
         pmS.prX_yM = pmS.pr_xyM  ./  (ones(pmS.nx,1) * pmS.pr_yV(:)');
         
         pmS.validate;         
      end
      
   end
end