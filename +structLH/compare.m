function compare(s1, s2, dbg)
% Compare 2 structures. Produce a report
%{
%}
% ------------------------------------

valueToler = 1e-5;

% Get common and unique field names
[fBothV, f1V, f2V] = structLH.compare_fields(s1, s2);



%% Non-matching fiels

for iCase = 1:2
   if iCase == 1
      nameV = f1V;
      hdStr  = 'Fields only in s1 \n';
   else
      nameV = f2V;
      hdStr  = 'Fields only in s2 \n';
   end

   if ~isempty(nameV)
      fprintf(hdStr);
      for i1 = 1 : length(nameV)
         fprintf('    %s',  nameV{i1});
      end
      fprintf('\n');
   end
end


%% Non-matching field values

for i1 = 1 : length(fBothV)
   fn = fBothV{i1};
   value1 = s1.(fn);
   value2 = s2.(fn);
   if isnumeric(value1)
      if isnumeric(value2)
         if isequal(size(value1), size(value2))
            if max(abs(value1(:) - value2(:))) > valueToler
               fprintf('    %s  differs in value \n',  fn);
            end
         else
            fprintf('    %s  size mismatch \n',  fn);
         end
      else
         fprintf('    %s  numeric in s1, not numeric in s2 \n',  fn);
      end
   end
end



end