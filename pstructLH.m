%% PstructLH
%{
Structure describing a potentially calibrated parameter

valueV
   default values; used when not calibrated
doCal
   can take on any value; can determine under what condition a parameter is calibrated

%}

classdef pstructLH
   properties
      name        % name, such as prefBeta
      symbolStr   % symbol used in paper
      descrStr    % Long description used in param tables
      valueV      % default values if not calibrated
      lbV         % bounds if calibrated
      ubV
      doCal       % is it calibrated?
   end
   
   methods      
      % Constructor
      function p = pstructLH(nameStr, symbolStr, descrStr, valueV, lbV, ubV, doCal)
         p.name = nameStr;
         p.symbolStr = symbolStr;
         p.descrStr = descrStr;
         p.valueV = valueV;
         p.lbV = lbV;
         p.ubV = ubV;
         p.doCal = doCal;
         validate(p);
      end
      
      % Update with new data
      function p = update(p, valueV, lbV, ubV, doCal)
         if ~isempty(valueV)
            p.valueV = valueV;
         end
         if ~isempty(lbV)
            p.lbV = lbV;
         end
         if ~isempty(ubV)
            p.ubV = ubV;
         end
         if ~isempty(doCal)
            p.doCal = doCal;
         end
         validate(p);
      end
      
   end
end

% %% Validate doCal input
% function validate_docal(doCal)
%    if doCal ~= 0  &&  doCal ~= 1
%       error('Invalid doCal');
%    end
% end
% 
% %% Validate bounds
% function validate_bounds(lbV, ubV)
%    validateattributes(lbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(ubV)})
%    if any(lbV >= ubV)
%       error('Invalid bounds');
%    end
% end

%% Validate values in struct
function validate(p)
%    if ~any(p.doCal == [p.calBase, p.calNever, p.calExp])
%       error('Invalid doCal');
%    end
   validateattributes(p.lbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(p.valueV)})
   if any(p.lbV >= p.ubV)
      error('Invalid bounds');
   end

end