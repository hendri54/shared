function [marginalValueS, schoolS, value] = solve_given_s(spS, s, h0)
% Solve schooling part of the hh problem, given parameters and s
%{
Schooling could be 0

OUT
   marginaValueS
      marginal value of increasing schooling
         discounted to age s
      deviation from optimal schooling condition
   value
      present value of lifetime earnings net of xs
%}

if isempty(h0)
   h0 = spS.h0;
end


if s == 0
   schoolS = spS.solve_s0(h0);

   % Schooling = 0 if deviation from optimal schooling is < 0 and increasing in s
   marginalValueS  = spS.marginal_value_s(schoolS);
      
else
   % Schooling is > 0
   % Find q0
   q0 = 2;

   optS = optimset('fzero');
   optS.MaxIter = 1e3;
   optS.Display = 'off';
   
   % Plot deviation function
   if false
      q0V = linspace(1e-2, 1e2, 10);
      devV = zeros(size(q0V));
      for i1 = 1 : length(q0V)
         devV(i1) = s_dev(log(q0V(i1)));
      end
      disp([q0V(:), devV(:)]);
      keyboard;
   end
   
   [solnV, ~, exitFlag] = fzero(@s_dev, log(q0), optS);
   
   if exitFlag <= 0
      warning('School solution not found')
   end

   [devQH, marginalValueS, schoolS] = s_dev(solnV);

   % fprintf('Max dev: %f \n',  max(abs(devV)));
end


% Value
value = spS.value_fct(schoolS);


%% Nested Deviation function
function [devQH, devOptS, schoolS] = s_dev(guessV)
   q02 = exp(guessV) + 1e-3;
   
   [~, schoolS, devOptS, devQH] = spS.dev_given_s_q0(s, q02, h0);
end


end