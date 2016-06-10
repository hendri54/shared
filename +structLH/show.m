function show(xS, containStr)
% Show a struct
%{
Only fields whose names contain containStr
%}

assert(isa(containStr, 'char'));

nameV = fieldnames(xS);

for i1 = 1 : length(nameV)
   nameStr = nameV{i1};
   % Show this field?
   if strfind(lower(nameV{i1}), lower(containStr))
      fprintf('  %8s:   ',  nameV{i1});
      % Can this be shown?
      % Has to be short
      sizeV = size(xS.(nameV{i1}));
      
      if isa(xS.(nameStr), 'char')
         % Strings
         show_char(xS.(nameStr));
         
      elseif length(sizeV) == 2  &&  (sizeV(1) < 5)  &&  (sizeV(2) < 8)  && isnumeric(xS.(nameV{i1}))
         fprintf('\n');
         valueM = xS.(nameV{i1});
         % Vector?
         if min(sizeV) == 1
            valueM = valueM(:)';
            sizeV = size(valueM);
         end
         for iRow = 1 : sizeV(1)
            fprintf('    ');
            fprintf('%.3f  ', valueM(iRow, :));
            fprintf('\n');
         end
         
      else
         % Cannot be shown
         fprintf('  Matrix of size  ');
         fprintf('%i  ', sizeV);
         fprintf('\n');
      end
   end
end


end


%% Show string
function show_char(xM)
   n = min(30, length(xM));
   fprintf('%s',  xM(1 : n));
   fprintf('\n');
end