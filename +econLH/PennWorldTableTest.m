classdef PennWorldTableTest < matlab.unittest.TestCase
    
   properties (TestParameter)
      verNum = {7.1, 8.1, 9};        
   end
    
%    methods (TestMethodSetup)
%       function x(testCase)
%                      
%       end
%    end
    
    
   methods (Test)
      function startTest(testCase, verNum)
         pS = econLH.PennWorldTable(verNum);
         pS.make_table(false);
         m = pS.load_table;
         
         wbCodeV = pS.country_list;
         testCase.verifyTrue(length(wbCodeV) > 100  &  length(wbCodeV) < 300);
      end
      
      function varSaveTest(testCase, verNum)
         pS = econLH.PennWorldTable(verNum);

         pS.var_fn('test');
         
         saveM = rand(4,3);
         pS.var_save(saveM, 'test');
         loadM = pS.var_load('test');
         testCase.verifyEqual(saveM, loadM);
      end
      
      
      function load_vc_test(testCase, verNum)
         pS = econLH.PennWorldTable(verNum);
         
         xV = pS.load_var_country(pS.vnPop, 'USA');
         if verNum == 8.1
            testCase.verifyTrue(abs(xV(1) - 155.5472) < 1);
         elseif verNum == 7.1
            testCase.verifyTrue(abs(xV(1) - 151868) < 1);
         end
      end
      
      
      %% Find countries
      function find_countries_test(testCase, verNum)
         pS = econLH.PennWorldTable(verNum);
         wbCodeV = {'USA', 'CAN'};
         [startIdxV, endIdxV] = find_countries(pS, wbCodeV);
         
         m = pS.load_table;
         countryV = m.(pS.vnCountry);
         yearV = m.(pS.vnYear);
         for i1 = 1 : length(wbCodeV)
            testCase.verifyTrue(all(strcmp(countryV(startIdxV(i1) : endIdxV(i1)), wbCodeV{i1})));
            testCase.verifyEqual(yearV(startIdxV(i1) : endIdxV(i1)),  (pS.year1 : pS.year2)');
         end
      end
      
      
      %% Load by [year, country]
      function load_yc_test(testCase, verNum)
         wbCodeV = {'USA', 'CAN'};
         yearV = [1980, 1992, 2003];
         pS = econLH.PennWorldTable(verNum);
         outM = load_var_yc(pS, pS.vnPop, wbCodeV, yearV);
         
         m = pS.load_table;
         popV = m.(pS.vnPop);
         countryV = m.(pS.vnCountry);
         mYearV = m.(pS.vnYear);
         out2M = nan(size(outM));
         for ic = 1 : length(wbCodeV)
            for iy = 1 : length(yearV)
               idx1 = find(strcmp(countryV, wbCodeV{ic})  &  (mYearV == yearV(iy)));
               testCase.verifyTrue(length(idx1) == 1);
               out2M(iy, ic) = popV(idx1);
            end
         end
         
         checkLH.approx_equal(outM, out2M, 1e-6, []);
      end
      
%       %% Find years
%       function find_years_test(testCase, verNum)
%          pS = econLH.PennWorldTable(verNum);
%          yearV = [1982, 1987, 2004];
%          yrIdxV = pS.find_years(yearV);
%          
%          m = pS.load_table;
%          testCase.verifyEqual(m.(pS.vnYear)(yrIdxV), yearV(:));
%       end
   end
end