% Constants to be shared across projects
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
%{
Largely obsolete, except for shared code directories
%}


% cS.raceWhite = 93;


% 
% %% Demographics
% 
% % How old is a person in year of birth?
% cS.demogS.ageInBirthYear = 1;
   end

end

end