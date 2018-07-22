function errorLH(msgV)
% Error with options
%{
On local machine, go to keyboard so error can be investigated
On remote machine: error
%}

compS = configLH.Computer([]);

if iscell(msgV)
   warning('Error encountered');
   for i1 = 1 : length(msgV)
      fprintf(msgV{i1});
      fprintf('\n');
   end
   
else
   warning(msgV);
end

if compS.runLocal
   keyboard;
else
   error('Terminating program');
end


end