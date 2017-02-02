%{
Vector with deviation from cal targets
%}

classdef devvectLH < handle

properties
   % no of entries preallocated
   nMax
   % no of entries filled
   n
   % name of each entry
   nameV
   % vector of devstruct; one for each entry
   dsV
   end
   
methods
   %% Constructor
   function v = devvectLH(nMax)
      v.nMax = nMax;
      v.n = 0;
      v.nameV = cell([nMax,1]);
      v.dsV = cell([nMax,1]);
   end
   
   
   %% Add a deviation
   %  ds is a devstruct
   function v = dev_add(v, ds)
      if ~isa(ds, 'devstructLH')
         error('Invalid ds');
      end
      v.n = v.n + 1;
      v.nameV{v.n} = ds.name;
      v.dsV{v.n} = ds;
   end
   
   
   %% Show all deviations on screen
   %{
   short descriptions and scalar deviations
   %}
   function dev_display(v)
      if v.n < 1
         disp('No deviations to display');
      else
         strV = cell(v.n, 1);
         for i1 = 1 : v.n
            strV{i1} = v.dsV{i1}.short_display;
            if isempty(strV{i1})
               strV{i1} = 'EMPTY';
            end
         end
         displayLH.show_string_array(strV, 75, 0);
      end
   end
   
   
   %% List of all scalar deviations
   function devV = scalar_devs(v)
      devV = nan([v.n, 1]);
      for i1 = 1 : v.n
         devV(i1) = v.dsV{i1}.scalar_dev;
      end
   end
   
   
   %% Return a deviation struct by name
   %{
   OUT
      ds :: devstructLH
         [] if not found
   %}
   function ds = dev_by_name(v, nameStr)
      i1 = find(strcmp(v.nameV, nameStr), 1, 'first');
      if ~isempty(i1)
         ds = v.dsV{i1};
      else
         ds = [];
      end
   end
end


end