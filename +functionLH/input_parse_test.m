function tests = input_parse_test

tests = functiontests(localfunctions);

end


%% Test for struct
function structTest(testCase)
   [~, ~, argListV] = get_defaults;

   x1 = 27;
   paramInS = struct;
   paramInS.x1 = x1;
   paramS = to_be_called(paramInS,  argListV);

   assert(isequal(paramS.x1, paramInS.x1));
   
   check_result(paramS)
end


%% Test for handle object
function handleTest(testCase)
   paramInS = functionLH.input_parse_test_class;
   
   %nameV = {'alpha', 'delta'};
   alpha0 = paramInS.alpha;
   delta0 = paramInS.delta;
   
   argListV = {'beta', 22, 'phi', 44};
   
   functionLH.input_parse(argListV,  paramInS);

   assert(isequal(paramInS.beta, 22));
   assert(isequal(paramInS.phi,  44));
   assert(isequal(paramInS.alpha, alpha0));
   assert(isequal(paramInS.delta, delta0));
end
   
   
function check_result(paramS)
   [nameV, valueV, argListV] = get_defaults;
   
   % Check arguments provided
   for i1 = 1 : 2 : (length(argListV) - 1)
      if ~strcmp(paramS.(argListV{i1}),  argListV{i1+1})
         error('Not copied');
      end
   end
      
   % Check arguments not provided
   for i1 = 1 : 2 : (length(nameV) - 1)
      if ~any(strcmp(argListV, nameV{i1}))
         if ~isequal(paramS.(nameV{i1}),  valueV{i1})
            error('Not copied');
         end
      end
   end
end


function paramS = to_be_called(paramInS, varargin)
   [nameV, valueV] = get_defaults;
   
   paramS = functionLH.input_parse(varargin{:},  paramInS,  nameV,  valueV);

end


function [nameV, valueV, argListV] = get_defaults
   % List of parameters and defaults
   nParams = 8;
   nameV = cell(nParams, 1);
   valueV = cell(nParams, 1);
   for i1 = 1 : nParams
      nameV{i1} = sprintf('name%i', i1);
      valueV{i1} = i1;
   end
   
   argListV = {'name1', 'value1',  'name3', 'value3'};
end