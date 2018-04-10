% Run all unit tests in a base folder and packages that hang off it
%{
Cannot write a unit test for this. This would call a unit test from a unit test.

Writing this as a class would be better but leads to errors. Matlab cannot find the methods
associated with the class (sometimes!) (R2017b)

IN
   baseDir  ::  char
      run tests in this directories and all packages hanging off it
%}
function TestAll(baseDir)
   assert(exist(baseDir, 'dir') > 0,  'baseDir does not exist');
   import matlab.unittest.TestSuite
   
   fprintf('\n\n\nTestAll on folder %s \n\n',  baseDir);

   % Tests contained in the base directory
   displayV = TestSuite.fromFolder(baseDir, 'IncludingSubfolders', false);

   % Add all packages
   packageV = dir(fullfile(baseDir, '+*'));
   if ~isempty(packageV)
      for i1 = 1 : length(packageV)
         % Package name, excluding '+'
         displayV = [displayV, TestSuite.fromPackage(packageV(i1).name(2 : end))];
      end
   end

   % Run all tests
   run(displayV);
end