classdef CesNestedLH < handle
% Nested CES production function
%{
Sub-nests have neutral productivity of 1

Handles sub-nests with single inputs
Their output is simply alpha * x

Handles Cobb-Douglas as special case

Substitution elasticity code is not efficient, but checks all constraints
For unknown reasons, computing the elasticities numerically does not yield the right answers (using
econLH.elasticity_substition)

Check: when all nests have 1 input, this should be the same as CES
%}

properties (SetAccess = private)
   % Top level
   substElast  double  % substitution elasticity
   
   % For each group (sub-nest)
   nV  uint16       % no of inputs
   substElastV  double
   
   % *****  Derived properties
   % no of "groups" (sub-nests)
   ng  uint16       
   % First and last input of each group
   gLbV
   gUbV
   % CES objects for lower levels
   cesV
   % CES object for top level
   cesTop
end

properties
   dbg logical = true
end


properties (Dependent)
   nInputs  uint16
end
   
   
methods
   % *****  Constructor
   function fS = CesNestedLH(substElast,  nV, substElastV)
      fS.substElast = substElast;
      
      fS.substElastV = substElastV(:);
      fS.nV = nV(:);
      
      fS.derived;
      fS.validate;
   end
   
   
   %% Derived properties
   function derived(fS)
      fS.ng = length(fS.nV);
      fS.gUbV = cumsum(fS.nV);
      fS.gLbV = [1; fS.gUbV(1 : (end-1)) + 1];
      fS.cesV = cell([fS.ng, 1]);
      for ig = 1 : fS.ng
         fS.cesV{ig} = ces_lh(fS.substElastV(ig), fS.nV(ig), [], [], []);
      end
      fS.cesTop = ces_lh(fS.substElast, fS.ng, [], [], []);
   end
   
   
   function n = get.nInputs(this)
      n = sum(this.nV);
   end
   
   
   % ******  Validate
   function validate(fS)
      validateattributes(fS.substElast, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
      
      validateattributes(fS.substElastV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [fS.ng, 1]})
      validateattributes(fS.nV, {'uint16'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [fS.ng, 1]})
   end
   
   
   % ******  Groups from inputs
   function groupV = groups_from_inputs(this, inputV)
      groupV = zeros(size(inputV), 'uint16');
      for i1 = 1 : length(inputV)
         groupV(i1) = find(inputV(i1) >= this.gLbV  &  inputV(i1) <= this.gUbV);
      end
      
      assert(all(groupV >= 1));
   end
   
   function inputV = inputs_from_group(this, ig)
      inputV = this.gLbV(ig) : this.gUbV(ig);
   end
   
   
   %%  Sub-outputs
   %{
   IN
      alphaM ::  T x no of inputs
         skill weights
      xM :: T x no of inputs
         inputs
   OUT
      yM  ::  T x no of groups
         output of each nested CES
   %}
   function yM = sub_outputs(fS, alphaM, xM)      
      T = size(xM, 1);
      nInputs = sum(fS.nV);
      
      validateattributes(alphaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})
      validateattributes(xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})
      
      AV = ones(T, 1);
      yM = zeros([T, fS.ng]);
      for ig = 1 : fS.ng
         gIdxV = fS.gLbV(ig) : fS.gUbV(ig);
         yM(:, ig) = fS.cesV{ig}.output(AV,  alphaM(:, gIdxV),  xM(:, gIdxV));
      end
      
      validateattributes(yM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, fS.ng]})
   end
   
   
   %%  Output
   function yV = output(fS, AV, alphaTopM, alphaM, xM) 
      T = size(xM, 1);
      nInputs = sum(fS.nV);
      validateattributes(alphaTopM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, fS.ng]})
      validateattributes(alphaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})
      validateattributes(xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})

      yGroupM = fS.sub_outputs(alphaM, xM);
      yV = fS.cesTop.output(AV, alphaTopM, yGroupM);
      
      validateattributes(yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, 1]})
   end
   
   
   %% Output from sub-outputs
   function yV = output_from_sub_outputs(this, AV, alphaTopM, yGroupM)
      yV = this.cesTop.output(AV, alphaTopM, yGroupM);
   end
   
   
   %%  Marginal products
   function mpM = mproducts(fS, AV, alphaTopM, alphaM, xM)
      T = size(xM, 1);
      validateattributes(alphaTopM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, fS.ng]})
      
      % Get marginal products at top level
      yM = fS.sub_outputs(alphaM, xM);
      mpTopM = fS.cesTop.mproducts(AV, alphaTopM, yM); % T x ng

      % Indices of inputs for each group
      nInputs = sum(fS.nV);
      mpM = zeros([T,  nInputs]);
      for ig = 1 : fS.ng
         % Productivities are 1 (neutral ones)
         gIdxV = fS.gLbV(ig) : fS.gUbV(ig);
         mpGroupM = fS.cesV{ig}.mproducts(ones(T,1), alphaM(:, gIdxV), xM(:, gIdxV));  % T x nv(ig)
         
         % dY/dX = dY/dG * dG/dX
         mpM(:, gIdxV) = (mpTopM(:, ig) * ones(1, fS.nV(ig))) .* mpGroupM;
      end
      
      validateattributes(mpM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})
   end
   
   
   %%  Factor weights that match incomes
   %{
   factor income = mp * x
   IN
      alphaTopSum, alphaSumV
         input weights sum to these (normalization)
   OUT
      AV
         neutral productivities
      alphaTopM :: T x no of top level groups
         top level skill weights
      alphaM :: T x no of inputs
   %}
   function [alphaTopM, alphaM, AV] = factor_weights(fS, incomeM, xM, alphaTopSum, alphaSumV)
      [T, nInputs] = size(xM);
      validateattributes(incomeM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})
      validateattributes(xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, nInputs]})
      
      alphaM = zeros([T, nInputs]);
      
      % For each group: get relative weights in that group
      % Output by group -> input into top level CES
      yGroupM = zeros(T, fS.ng);
      % Income by group
      incGroupM = zeros(T, fS.ng);
      for ig = 1 : fS.ng
         gIdxV = fS.gLbV(ig) : fS.gUbV(ig);
         % Within group alphas sum to alphaSumV
         [alphaGroupM, AgroupV] = fS.cesV{ig}.factor_weights( ...
            incomeM(:, gIdxV), xM(:, gIdxV), alphaSumV(ig));  % T x nv(ig)
         alphaM(:, gIdxV) = alphaGroupM;
         
         % Since A = 1 for the group: renormalize output
         yGroupV = fS.cesV{ig}.output(AgroupV,  alphaGroupM,  xM(:, gIdxV));
         yGroupM(:, ig) = yGroupV ./ AgroupV;
         
         incGroupM(:, ig) = sum(incomeM(:, gIdxV), 2);
      end
      
      
      % Get top weights that match group incomes
      [alphaTopM, AV] = fS.cesTop.factor_weights(incGroupM,  yGroupM,  alphaTopSum);
      
      validateattributes(alphaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', size(xM)})
      validateattributes(alphaTopM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, fS.ng]})
      validateattributes(AV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [T, 1]})
   end
   
   
   % *******  Express skill weights such that one factor has skill weight = 1
   %{
   %}
%    function skill_weight_normalize(fS, skillWeightTop_tlM, skillWeight_tlM, dbg)
%       T = size(skillWeight_tlM, 1);
%    skillWeight_stM = zeros(cS.nSchool, T);
%    skillWeight_stM(cS.iCG, :) = (modelS.skillWeightTop_tlM(:, 2) ./ modelS.skillWeightTop_tlM(:, 1));
%    skillWeight_stM(1 : cS.iCD, :) = modelS.skillWeight_tlM(:, 1 : cS.iCD)';
%    skillWeight_stM = skillWeight_stM ./ (ones(T, 1) * skillWeight_stM(iRef, :));
%    end


   %% Income shares
   %{
   OUT
      incomeShareM  ::  double
         by (t, input)   
   %}
   function incomeShareM = income_shares(this, AV, alphaTopM, alphaM, xM)
      mpM = this.mproducts(AV, alphaTopM, alphaM, xM);
      incomeM = mpM .* xM;
      incomeShareM = incomeM ./ sum(incomeM, 2);
      
      if this.dbg
         assert(isequal(size(incomeShareM), size(incomeM)));
      end
   end
   
   
   % Group shares = sum of income shares in each group
   function groupShareM = group_shares(this, incomeShareM)
      T = size(incomeShareM, 1);
      groupShareM = zeros([T, this.ng]);
      for ig = 1 : this.ng
         gIdxV = this.inputs_from_group(ig);
         groupShareM(:, ig) = sum(incomeShareM(:, gIdxV), 2);
      end
   end



   %% Elasticity of substitution from inputs
   %{
   OUT
      elast_ijtM  ::  double
         elasticity(i,j) for date t
   %}
   function elast_ijtM = elast_subst_from_inputs(this, AV, alphaTopM, alphaM, xM)
      incomeShareM = this.income_shares(AV, alphaTopM, alphaM, xM);
      groupShareM = this.group_shares(incomeShareM);
      
      T = size(xM, 1);
      elast_ijtM = zeros(this.nInputs, this.nInputs, T);
      for t = 1 : T
         for i1 = 1 : this.nInputs
            for i2 = 1 : this.nInputs
               elast_ijtM(i1,i2,t) = this.elast_substitution(i1, i2, incomeShareM(t,:), groupShareM(t,:));
            end
         end
      end
   end


   %% Elasticity of substitution (analytical)
   %{
   Sato (1967) REStud
   For perturbing inputs i1, i2 in nests g1, g2
   
   IN
      incomeShareV  ::  double
         marginal product * x / y  for all x
      groupShareV  ::  double
         share of each group in y
   %}
   function elast = elast_substitution(this, i1, i2, incomeShareV, groupShareV)
      if this.dbg
         assert(abs(sum(incomeShareV) - 1) < 1e-5);
         assert(abs(sum(groupShareV) - 1) < 1e-5);
      end
      
      if i1 == i2
         elast = NaN;
         return;
      end
      
      g1 = this.groups_from_inputs(i1);
      g2 = this.groups_from_inputs(i2);
      
      if g1 == g2
         elast = this.substElastV(g1);
         return
      end
      
      a = 1 / incomeShareV(i1) - 1 / groupShareV(g1);
      b = 1 / incomeShareV(i2) - 1 / groupShareV(g2);
      c = 1 / groupShareV(g1) + 1 / groupShareV(g2);
      rhs = (a / this.substElastV(g1) + b / this.substElastV(g2) + c / this.substElast);
      elast = (a + b + c) / rhs;
      
      if this.dbg
         assert(all([a,b,c,elast] >= 0));
      end
   end
   
   
   %% Range of elasticities for each group pair
   %{
   OUT
      min_ggtM, max_ggtM  ::  double
         min and max elasticity for each pair of groups (nests)
         by [group 1, group 2, t]
   %}
   function [min_ggtM, max_ggtM] = elasticity_ranges(this, elast_ijtM)
      T = size(elast_ijtM, 3);
      min_ggtM = zeros(this.ng, this.ng, T);
      max_ggtM = zeros(this.ng, this.ng, T);
      
      for t = 1 : T
         for g1 = 1 : this.ng
            i1V = this.inputs_from_group(g1);
            
            % Within
            if length(i1V) > 1
               elastM = elast_ijtM(i1V, i1V, t);
               elastM = matrixLH.set_diagonal(elastM, elastM(1,2));
               min_ggtM(g1,g1,t) = min(elastM(:));
               max_ggtM(g1,g1,t) = max(elastM(:));
            else
               min_ggtM(g1,g1,t) = this.substElastV(g1);
               max_ggtM(g1,g1,t) = this.substElastV(g1);
            end
            
            % Between
            g2V = 1 : this.ng;
            g2V(g1) = [];
            for g2 = g2V
               i2V = this.inputs_from_group(g2);
               elastM = elast_ijtM(i1V, i2V, t);
               min_ggtM(g1,g2,t) = min(elastM(:));
               max_ggtM(g1,g2,t) = max(elastM(:));
            end
         end      
      end
      
      if this.dbg
         validateattributes(min_ggtM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [this.ng, this.ng, T]})
         validateattributes(max_ggtM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [this.ng, this.ng, T]})
      end
   end
   
   
   %% Check that elasticity matrix satisfies restrictions implied by Sato (1967)
   function [withinCorrect, betweenCorrect, isSymmetric] = check_elastity_matrix(this, elast_ijtM)
      withinCorrect = this.check_elasticities_within(elast_ijtM);
      betweenCorrect = this.check_elasticities_between(elast_ijtM);
      isSymmetric = this.check_elast_symmetry(elast_ijtM, 1e-4);
   end
      
   
   % *****  Check that within elasticities match nested elasticities
   function withinCorrect = check_elasticities_within(this, elast_ijtM)
      withinCorrect = true;
      T = size(elast_ijtM, 3);
      for t = 1 : T
         for ig = 1 : this.ng
            inputV = this.inputs_from_group(ig);            
            elastM = elast_ijtM(inputV, inputV, t);
            
            % within a nest
            if length(inputV) > 1
               diffM = elastM - repmat(this.substElastV(ig), size(elastM));
               diffM = matrixLH.set_diagonal(diffM, 0);
               if any(abs(diffM(:)) > 1e-5)
                  withinCorrect = false;
               end
            end
         end
      end
   end
   
   
   % Check that between elasticities lie between top and nested elasticities
   function betweenCorrect = check_elasticities_between(this, elast_ijtM)
      betweenCorrect = true;
      
      for g1 = 1 : this.ng
         i1V = this.inputs_from_group(g1);
         g2V = 1 : this.ng;
         g2V(g1) = [];
         for g2 = g2V
            rangeV = [this.substElast; this.substElastV(g1); this.substElastV(g2)];

            i2V = this.inputs_from_group(g2);
            elastM = elast_ijtM(i1V, i2V, :);

            valid = all(elastM(:) >= min(rangeV))  &&  all(elastM(:) <= max(rangeV));
            if ~valid
               betweenCorrect = false;
            end
         end
      end      
   end   
end


methods (Static)
      function isSymmetric = check_elast_symmetry(elast_ijtM, toler)
      isSymmetric = true;
      T = size(elast_ijtM, 3);
      for t = 1 : T
         diffM = elast_ijtM(:,:,t) - elast_ijtM(:,:,t)';
         diffM = matrixLH.set_diagonal(diffM, 0);
         maxDiff = max(abs(diffM(:)));
         if maxDiff > toler
            isSymmetric = false;
         end
      end
   end
end
   
end