function K_ycM = perpetual_inventory(iy_ycM, Y_ycM, ddk, dbg)
% Use perpetual inventory method to construct capital stock
%{
Assumes that initial capital output ratio is given by mean iy / ddk

Single missing values are interpolated
Multiple missing values lead to missing capital stock for all years

Same for output

IN
   iy_ycM(year, country)
      investment / output
   Y_ycM
      output
   ddk
      depreciation rate
OUT
   K_ycM(year, country)
      capital stock
%}

[ny, nc] = size(iy_ycM);

% Make missing values into NaN
iy_ycM(~(iy_ycM > 0.001)) = NaN;
Y_ycM(~(Y_ycM > 0.001)) = NaN;


%% Which countries have enough data to construct capital stock?

hasData_cV = ones(nc, 1);
iyMean_cV = zeros(nc, 1);
K_ycM = zeros(ny, nc);

for ic = 1 : nc
   % Interpolate over missing values
   iy_ycM(:, ic) = interp_local(iy_ycM(:, ic), dbg);
   Y_ycM(:, ic)  = interp_local(Y_ycM(:, ic), dbg);
   
   if ~isnan(iy_ycM(1,ic))  &&  ~isnan(Y_ycM(1,ic))
      hasData_cV(ic) = true;
   else
      hasData_cV(ic) = false;
   end
   
   if hasData_cV(ic)
      validateattributes(iy_ycM(:, ic), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         '<', 1})
      validateattributes(Y_ycM(:, ic), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      
      iyMean_cV(ic) = mean(iy_ycM(:, ic));
      % Initial capital stock
      K_ycM(1, ic) = iyMean_cV(ic) ./ ddk .* Y_ycM(1, ic);
   end
end


%% Perpetual inventory

cIdxV = find(hasData_cV);

for iy = 1 : (ny-1)
   K_ycM(iy+1, cIdxV) = K_ycM(iy, cIdxV) .* (1 - ddk) + iy_ycM(iy, cIdxV) .* Y_ycM(iy, cIdxV);
end

validateattributes(K_ycM(:, cIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   'size', [ny, length(cIdxV)]})


end


%% Local: interpolate
function outV = interp_local(inV, dbg)
   n = length(inV);
   
   % Find missing values
   mIdxV = find(isnan(inV));
   if isempty(mIdxV)
      outV = inV;
   else
      % Any consecutive missing years?
      if any(diff([-1; mIdxV]) < 2)
         outV = nan(size(inV));   
      else
         outV = vectorLH.extrapolate(inV, dbg);
         % Prevent odd interpolation at ends
         if isnan(inV(1))
            outV(2) = outV(1);
         end
         if isnan(inV(n))
            outV(n) = outV(n-1);
         end
         
         validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', size(inV)})
      end
   end
end