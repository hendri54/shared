function [idxV, dummy1V, dummy2V] = interaction_names(mdl, name1, name2, cat1, cat2)
% Retrieve positions where regressors that interact `name1` and `name2` are stored
%{
When regressing
   fitlm(tbM, 'y ~ a:b')
the regressor names can be `a:b` or `b:a`
This function finds all `b_123:a_123` or `a_123:b_123` names and the associated dummy categories
(the `123` for a and b)
Either a or b or both can be categorical (not all combinations implemented)

OUT
   idxV
      indices in mdl.CoefficientNames
   dummy1V
      dummy values for name1
   dummy2V
      dummy values for name2

needs testing +++++
%}

idxV = [];
dummy1V = [];
dummy2V = [];


%% Build search string for first pattern

dStr = '_(\d+)';

if cat1
   nameStr1 = [name1, dStr];
else
   nameStr1 = name1;
end
if cat2
   nameStr2 = [name2, dStr];
else
   nameStr2 = name2;
end

searchStr1 = [nameStr1, ':', nameStr2];

% searchStr1 = name1;
% if cat1
%    % 'a_123'
%    searchStr1 = [searchStr1, dStr];
% end
% % a_123:b
% searchStr1 = [searchStr1, ':', name2];
% if cat2
%    % a_123:b_456
%    searchStr1 = [searchStr1, dStr];
% end

%% Try first pattern

[aV, ~] = regexp(mdl.CoefficientNames, searchStr1, 'tokens', 'match');
idxV = find(~cellfun(@isempty, aV));

if ~isempty(idxV)
   % First pattern was correct
   if cat1
      dummy1V = zeros(size(idxV));
   end
   if cat2 
      dummy2V = zeros(size(idxV));
   end
   
   for i1 = 1 : length(idxV)
      idx1 = idxV(i1);
      xV = cellfun(@str2double, aV{idx1});
      ix = 0;
      if cat1
         ix = ix + 1;
         dummy1V(i1) = xV(ix);
      end
      if cat2
         ix = ix + 1;
         dummy2V(i1) = xV(ix);
      end
      assert(ix == length(xV),  'Wrong length of matches');
   end
   
else
   % Build search string for first pattern
   searchStr2 = [nameStr2, ':', nameStr1];
   
   % Try second pattern
   [aV, ~] = regexp(mdl.CoefficientNames, searchStr2, 'tokens', 'match');
   idxV = find(~cellfun(@isempty, aV));
   
   if ~isempty(idxV)
      % Success      
      if cat1
         dummy1V = zeros(size(idxV));
      end
      if cat2 
         dummy2V = zeros(size(idxV));
      end

      for i1 = 1 : length(idxV)
         idx1 = idxV(i1);
         xV = cellfun(@str2double, aV{idx1});
         ix = 0;
         if cat2
            ix = ix + 1;
            dummy2V(i1) = xV(ix);
         end
         if cat1
            ix = ix + 1;
            dummy1V(i1) = xV(ix);
         end
         assert(ix == length(xV));
      end
      
   end
end


% if ~cat1  &&  cat2
%    % Try name1:name2_123 pattern
%    [aV, ~] = regexp(mdl.CoefficientNames, [name1, ':', name2, '_(\d+)'],  'tokens', 'match');
%    
%    
%    % Find all regressors that match the pattern name2_123:name1
%    [aV, ~] = regexp(mdl.CoefficientNames, [name2, '_(\d+):', name1], 'tokens', 'match');
%    idxV = find(~cellfun(@isempty, aV));
%    if ~isempty(idxV)
%       aV = aV(idxV);
%       regNameV = mdl.CoefficientNames(idxV);
%       newNameV = cell(size(regNameV));
%       for i1 = 1 : length(newNameV)
%          newNameV{i1} = [name1, ':', name2, '_', char(aV{i1}{1})];
%       end
%    end
% 
% else
%    error('Not implemented');
% end


end