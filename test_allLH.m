function test_allLH
%% Runs all tests
% Also serves as a brief overview of the code
%

dbg = 111;

lhS = const_lh;


%% Cell arrays
%
% Make a cell array of numbers into a vector
cellLH.cell2vector_test;


%% Config
if lhS.runLocal  &&  false
   % Editor not available on server. Generally not run because of screen display annoyance
   configLH.MatlabEditorStateTest;
   configLH.MatlabEditorTest;
end


%% Data handling

dataLH.VariableTest;


%% Distributions

WeightedDataTestLH;

% Weighted cdf
distribLH.cdf_weighted_test;

% Assign each element in a vector to a percentile class
distribLH.class_assign_test;

% Bounds of percentile classes
distribLH.cl_bounds_w_test;

% Quantiles, weighted data
distribLH.pcnt_weighted_test;

% Bivariate normal
distribLH.NormalBivariateTest;


%% Economics
%
% Ben-Porath model
%
% $$h(t+1)=(1-\delta)h(t) + A (h(t) l(t))^\alpha$$
%
BenPorathLHtest;

% Interior, continuous time
BenPorathContTimeTestLH;
% Corner, continuous time
BenPorathCornerTestLH;

% Nested CES production function
CesNestedLHtest;

% Bounded grid
econLH.GridBoundedTest;

% Discrete choice problem with type 1 extreme value shocks
% Solve and calibrate its parameters
econLH.extreme_value_decision_test;
econLH.extreme_value_calibrate_test(false)


%
% CRRA utility and permanent income model
% UtilCrraLHtest;
%
% CES production function
ces_lh_test;
%
% Table of symbols. Generates a latex preamble with newcommands, so that model notation does not
% have to be hard coded
SymbolTableLHtest;
%
% Geometric sums
econLH.geo_sum_test;
%
% Perpetual inventory method
econLH.perpetual_inventory_test;

% Test by regression whether true and simulated outcomes are consistent
econLH.regression_test_test(false);
%
% Maintain a list of unique names (e.g. file names for model results)
% econLH.VariableListLHtest;
%



%% Figures

figuresLH.Bar3DTest;
FigureLHtest;


%% Files

% RDIR is taken from the Matlab file exchange and used in some of my file routines
% rdir cannot be in a subdir that's not on the path
rdir_test

% Find common base directory for a list of files
filesLH.common_base_directory_test;

% Test whether a file contains a set of strings
filesLH.does_file_contain_strings_test

% Find all files that contain at least one of a set of strings
filesLH.find_files_containing_strings_test

% Find files by name
filesLH.find_files_by_name_test

filesLH.FolderTest;

% FTP up and downloads to mounted volume (actually using rsync)
%  obsolete; use KureLH +++
filesLH.FtpTargetTest;

% Make absolute into relative paths
filesLH.make_relative_paths_test;

% Multi file search and replace
filesLH.replace_text_in_file_test;

% Make zip file, preserving directory structure
filesLH.zip_files_test;


%% Markdown

markdownLH.ClassDatesTest;
markdownLH.SubTopicTest;
markdownLH.TopicTest;
markdownLH.ClassScheduleTest;


%% Markov chains

markovLH.markov_sim_test;


%% Matrix

% Apply a scalar function to one dimension of an array of arbitrary size
matrixLH.apply_scalar_function_test;

% Given a matrix, find rows with valid observations for all columns
matrixLH.find_valid_test;


%% Optimization

pstructTestLH;
pvectorLHtest;

globalOptLH.test;
optimLH.GuessUnboundedTest;


%% Random numbers

randomLH.MultiVarNormalTest;
randomLH.rand_discrete_test;
randomLH.rand_time_test;


%% Regressions

regressLH.test_all;


%% SATs and ACTs

sat_actLH.act2sat1Test;
sat_actLH.sat_old2new_test;
sat_actLH.sat2percentile_test;

%% Statistics

% R^2 for weighted data
rng(323);
yV = linspace(-1, 1, 100);
yHatV = yV + randn(size(yV));
wtV = 1 + rand(size(yV));
statsLH.rsquared(yV, yHatV, wtV, dbg);

statsLH.CovMatrixTest;
statsLH.ProbMatrix2Dtest;

% Construct correlation matrix from weights
statsLH.corr_matrix_from_weights_test;

% Weighted data: mean and std deviation
statsLH.std_w_test;



%% String

% Does a string contain any of a set of other string?
stringLH.contains_test;

% Format one number in the same way as another (provided as a formatted string)
stringLH.format_similar_test;

stringLH.string_array_to_cell_test;


%% Struct

structLH.show_test;


%% Vector

% Extend a vector into the past and future using constant linear trends
vectorLH.extend_linear_trend_test;
% For each element in x, find their position in y
vectorLH.find_matches_test;
% Given a set of (x,y) vectors, make an x vector that spans all the x values
% Make a y matrix with all the y values
vectorLH.xy_to_common_base_test;


%% Build unit tests
% Done at the end so results are clearly visible

testStrV = {};

testStrV = [testStrV, 'devstructLHtest',  'devvectLHtest',  'ParPoolLHtest',  'ProjectLHtest'];
% Economics routines
% testStrV = [testStrV,  {'econLH.BinaryDecisionTest',  'econLH.grid_round_to_test',  'econLH.test_all'}];
% File routines
% testStrV = [testStrV,  {'filesLH.FileNamesTest',  'filesLH.TextFileTest',  'filesLH.ZipFileTest'}];
% Accessing ftp servers
testStrV = [testStrV, 'KureLHtest'];
% Latex
%latexV = {'latexLH.make_command_valid_test',  'latexLH.PreambleTest'};
% Linux routines
%linuxV = {'linuxLH.LSFtest', 'linuxLH.SBatchTest'};
% Maps and containers
%mapsV = {'mapsLH.StringIntMapTest'};
% Regression related
%regressV = 'regressLH.unitTests';
%vectorV = {'vectorLH.count_elements_test', 'vectorLH.vector2matrix_test'};

% testStrV = [testStrV, latexV, linuxV, mapsV, regressV, vectorV];

runtests(testStrV)


%% Tests for entire folders
% There can be other functions ending in `test` in the folder. They are ignored

import matlab.unittest.TestSuite

displayV = [TestSuite.fromPackage('displayLH'),  TestSuite.fromPackage('distribLH'),  TestSuite.fromPackage('econLH'),  ...
   TestSuite.fromPackage('figuresLH'),  TestSuite.fromPackage('filesLH'),  TestSuite.fromPackage('functionLH'),   ...
   TestSuite.fromPackage('latexLH'), ...
   TestSuite.fromPackage('linuxLH'),  TestSuite.fromPackage('mapsLH'),  TestSuite.fromPackage('regressLH'), ...
   TestSuite.fromPackage('stringLH'),  TestSuite.fromPackage('structLH'),  TestSuite.fromPackage('vectorLH')];

run(displayV);


end