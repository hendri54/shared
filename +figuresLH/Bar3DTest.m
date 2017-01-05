function Bar3DTest

isVisible = false;

nx = 6;
ny = 3;
rng('default');
data_xyM = rand(nx, ny);

bS = figuresLH.Bar3D(data_xyM, 'visible', isVisible);
if isVisible
   pause(3);
end
bS.close;

end