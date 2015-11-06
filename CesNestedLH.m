classdef CesNestedLH < handle
% Nested CES production function
%{
Sub-nests have neutral productivity of 1

Handles sub-nests with single inputs
Their output is simply alpha * x

Handles Cobb-Douglas as special case

Check: when all nests have 1 input, this should be the same as CES
%}

properties
   % Top level
   substElast  % substitution elasticity
   
   % For each group (sub-nest)
   nV       % no of inputs
   substElastV
   
   % *****  Derived properties
   % no of "groups" (sub-nests)
   ng       
   % First and last input of each group
   gLbV
   gUbV
   % CES objects for lower levels
   cesV
   % CES object for top level
   cesTop
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
   
   
   % ******  Derived properties
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
   
   
   % ******  Validate
   function validate(fS)
      validateattributes(fS.substElast, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
      
      validateattributes(fS.substElastV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [fS.ng, 1]})
      validateattributes(fS.nV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [fS.ng, 1]})
   end
   
   
   % ******  Sub-outputs
   %{
   IN
      alphaM ::  T x no of inputs
      xM :: T x no of inputs
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
   
   
   % ******  Output
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
end
   
end