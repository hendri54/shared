classdef ClassifiedDataTest < matlab.unittest.TestCase
    
% properties (TestParameter)
% 
% end
% 
% methods (TestMethodSetup)
%    function x(testCase)
% 
%    end
% end
% 
% methods (TestMethodTeardown)
%    function y(testCase)
% 
%    end
% end

methods (Test)
   function oneTest (testCase)
      rng('default');
      nc = 5;
      xV = randn([nc, 1]);
      wtV = rand([nc, 1]);
      classV = randi(nc, [nc, 1]);
      cdS = dataLH.ClassifiedData(nc);
      cdS.class_means(xV, wtV, classV);
   end

end
end