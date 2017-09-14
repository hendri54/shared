% Constants to be shared across projects
% Basically obsolete. Directories in 'configLH.Computer'
classdef const_lh < handle
   
properties (Constant)
   % Missing value code (unless NaN is used)
   missVal = -9191;

   % Sex codes (really: indices)
   male = 1;
   female = 2; 
   sexBoth = 3;
   sexStrV = {'men', 'women', 'both'};

   % When we have model and data, index in this order
   iModel = 1;
   iData = 2;
end


methods
   %% Constructor
   function cS = const_lh
   end

end

end