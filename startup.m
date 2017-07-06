% Matlab Startup File
%{
Do NOT save in a Matlab system dir! It gets wiped
   out sometimes when reinstalling.

This is the first thing run when matlab starts, locally or on kure

This function cannot use anything but built in functions

Store all constants in lhS
Given that const_lh is now always on the path, there is no need to ever use the global

%}

disp('Processing startup.m');


%% Directories
% Location of shared dirs depends on whether we are running local or not

lhS = const_lh;

% Add dir for startup routines
% addpath(filesLH.fullpaths(lhS.dirS.iniFileDir));
% for i1 = 1 : length(lhS.dirS.sharedDirV)
%    addpath(filesLH.fullpaths(lhS.dirS.sharedDirV{i1}));
% end


%%  Figure sizes 

% Get screen size
screen = get(0, 'ScreenSize');
% With dual screens, the total width is reported
width  = min(2560, screen(3));
height = screen(4);

% Set width and height of a figure
mwwidth  = round(width * 0.5);
mwheight = round(height * 0.5);

% Bottom left corner
left = round(0.5 * (width - mwwidth));
bottom = round(0.5 * (height - mwheight));

rect = [ left bottom mwwidth mwheight ];
set(0, 'defaultfigureposition',rect);


%% Other

format short


% *** end function ***
