function timeStr = time_str(clockV)
% Return formatted string showing current time
% Or using time vector as returned by clock

if nargin < 1
   clockV = clock;
end
if isempty(clockV)
   clockV = clock;
end

timeStr = sprintf('%02i:%02i:%02i',  round(clockV(4:6)));


end