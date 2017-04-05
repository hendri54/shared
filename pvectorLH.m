%% PvectorLH
%{
Vector of potentially calibrated parameters

Can handle matrix objects

Flow:
1. Set up the object
2. Add potentially calibrated parameters, one by one
3. Change parameters if needed for each calibration case
4. guess_make: make a vector of all calibrated guesses
5. run the vector of guesses into optimization routine
6. in objective function: guess_extract copies guesses into parameter struct
%}

classdef pvectorLH < handle
   properties (Constant)
      % Transformed guesses lie in this range
      guessMin = 1;
      guessMax = 10;
   end
   properties
      np  uint16 = 0;        % no of entries
      nameV  cell        % parameter names
      valueV  cell        % array of pstruct
      doCalV  double       % permitted values of doCal
   end
   
   methods
      %% Constructor
      function pv = pvectorLH(nMax, doCalV)
         pv.np = 0;
         pv.doCalV = doCalV;
         pv.nameV = cell([nMax,1]);
         pv.valueV = cell([nMax,1]);
      end
      
      
      %% Retrieve by name
      function ps = retrieve(obj, nameStr)
         % Does this param exist?
         idx1 = find(strcmp(obj.nameV, nameStr));
         if ~isempty(idx1)
            ps = obj.valueV{idx1};
         else
            ps = [];
         end
      end
      
      
      %% Retrieve calibration status
      function calStatus = cal_status(obj, nameStr)
         ps = obj.retrieve(nameStr);
         calStatus = ps.doCal;
      end
      
      
      %% Add a list of parameters
      function param_add_list(obj, psV)
         for i2 = 1 : length(psV)
            obj.add(psV{i2});
         end            
      end

      
      %% Add new parameter
      function add(obj, ps)
         assert(isa(ps, 'pstructLH'))
         % Does this param exist?
         idx1 = find(strcmp(obj.nameV, ps.name), 1, 'first');
         if ~isempty(idx1)
            error([ps.name, ' already exists']);
         else
            % Add new parameter
            obj.np = obj.np + 1;
            obj.nameV{obj.np} = ps.name;
            obj.valueV{obj.np} = ps;
         end
      end
      
      
      %% Add new param or change existing param
      function change(obj, nameStr, symbolStr, descrStr, valueV, lbV, ubV, doCal)
         % Does this param exist?
         idx1 = find(strcmp(obj.nameV, nameStr));
         if isempty(idx1)
            % Add new parameter
            obj.np = obj.np + 1;
            obj.nameV{obj.np} = nameStr;
            obj.valueV{obj.np} = pstructLH(nameStr, symbolStr, descrStr, valueV, lbV, ubV, doCal);
         else
            % Update existing parameter
            ps = obj.valueV{idx1};
            ps.update(valueV, lbV, ubV, doCal);
         end
      end
      
      
      %% Change calibration status
      function calibrate(obj, nameStr, doCal)
         % Does this param exist?
         idx1 = find(strcmp(obj.nameV, nameStr), 1, 'first');
         if isempty(idx1)
            error('%s does not exist', nameStr);
         end
         obj.change(nameStr, [], [], [], [], [], doCal);
      end
      
      
      %% Change calibration stats for a list of params
      %{
      Only for those whose calibration status is in a given list
      That list can be []. Then always change
      %}
      function change_calibration_status(obj, nameV, doCalOldV, doCalNew)
         if ischar(nameV)
            nameV = {nameV};
         end
         for i1 = 1 : length(nameV)
            ps = obj.retrieve(nameV{i1});
            if ~isempty(ps)
               if isempty(doCalOldV)  ||  any(ps.doCal == doCalOldV)
                  obj.calibrate(nameV{i1}, doCalNew);
               end
            end
         end
      end
      
      
      %% Make a struct with default values for all params
      function paramS = default_struct(p)
         paramS = struct;
         for i1 = 1 : p.np
            paramS.(p.nameV{i1}) = p.valueV{i1}.valueV;
         end
         % Force non-calibrated params to be fixed at defaults
         paramS = p.struct_update(paramS, 1);
      end
      
      
      %% Add all parameters that are not calibrated (or missing) to a struct
      %{
         Also impose bounds when calibrated (doCal >= 1)
      
         Can be used to make a paramS struct with all default values
         But that creates a new copy of paramS
      
         IN: 
            p: pvector
            paramS: struct to which fields are to be added
            doCalV: only fields with doCal NOT in doCalV are touched
         OUT:
            paramS with added / updated fields
      %}
      function paramS = struct_update(p, paramS, doCalV)
         % Loop over parameters
         for i1 = 1 : p.np
            % Param struct
            ps = p.valueV{i1};
            pName = p.nameV{i1};
            % Overwrite fields that are not calibrated or missing
            if ~ismember(ps.doCal, doCalV)  ||  (~isfield(paramS, pName))
               % Use exogenous default values
               paramS.(pName) = ps.valueV;
            end
            if ps.doCal >= 1
               % Impose bounds
               paramS.(pName) = max(ps.lbV, min(ps.ubV, paramS.(pName)));
            end
         end
      end
      
      
      %%  Copy parameters for which doCal in doCalV from one struct into another
      function paramS = param_copy(p, paramToS, paramFromS, doCalV)
         paramS = paramToS;
         % Loop over parameters
         for i1 = 1 : p.np
            % Param struct
            ps = p.valueV{i1};
            % Overwrite fields that are not calibrated or missing
            if ismember(ps.doCal, doCalV) 
               % Use exogenous default values
               pName = p.nameV{i1};
               paramS.(pName) = paramFromS.(pName);
            end
         end
      end
      
      
      %%  Make transformed parameter vector (for optimization routines
      % Make it out of paramS structure that contains all calibrated params
      %{
      IN
         doCalV
            only params with doCal in doCalV are put into guessV
      %}
      function guessV = guess_make(p, paramS, doCalV)
         % Get all the calibrated params into a single vector
         guessV = nan([100,1]);
         lbV = nan([100,1]);
         ubV = nan([100,1]);
         % Last entry in guessV that is filled
         idx1 = 0;
         for i1 = 1 : p.np
            % Get pstructLH
            ps = p.valueV{i1};
            if any(ps.doCal == doCalV)
               idxV = idx1 + (1 : numel(ps.valueV));
               % Take the value out of the paramS struct
               %  Flatten matrices. This can be undone using reshape
               assert(isequal(length(idxV),  length(paramS.(ps.name)(:))),  ...
                  sprintf('Size of %s in paramS does not match size in pvector',  ps.name));
               guessV(idxV) = paramS.(ps.name)(:);
               lbV(idxV) = ps.lbV(:);
               ubV(idxV) = ps.ubV(:);
               idx1 = idxV(end);
            end
         end
         
         % Drop unused elements
         if length(guessV) > idx1
            idxV = (idx1 + 1) : length(guessV);
            guessV(idxV) = [];
            lbV(idxV) = [];
            ubV(idxV) = [];
         end
         
         % Make sure all guesses are in range
         guessV = min(ubV, max(lbV, guessV));

         % Transform
         guessV = p.guessMin + (guessV(:) - lbV(:)) .* (p.guessMax - p.guessMin) ./ (ubV(:) - lbV(:));
         
         validateattributes(guessV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [idx1,1]})
      end
      
      
      %%  Make guesses into parameters
      % Inverts guess_make
      %{
      IN
         doCalV
            only guesses with doCal in doCalV are used
      %}
      function paramS = guess_extract(p, guessV, paramInS, doCalV)
         paramS = paramInS;
         guessV = guessV(:);
         % Last entry in guessV that is used
         idx1 = 0;
         % Loop over calibrated guesses
         for i1 = 1 : p.np
            % pstructLH for this param
            ps = p.valueV{i1};
            if any(ps.doCal == doCalV)
               % Position in guess vector
               idxV = idx1 + (1 : numel(ps.valueV));
               gValueV = guessV(idxV);
               % Reshape if needed
               if ~isvector(ps.valueV)
                  gValueV = reshape(gValueV, size(ps.valueV));
               end
               % Retrieve values. May be matrices
               paramS.(ps.name) = ps.lbV  +  (gValueV - p.guessMin) .* (ps.ubV - ps.lbV) ./ ...
                  (p.guessMax - p.guessMin);
               idx1 = idxV(end);
               validateattributes(paramS.(ps.name), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                  'size', size(ps.valueV)})
            end
         end
      end
      
      
      %%  Show all parameters that are calibrated
      %{
      IN
         paramS
            struct with parameter values
            can also be a class
      OUT
         outV :: string array
            each entry is a formatted parameter
            formatted for on screen display during calibration
      %}
      function [outV, pNameV] = calibrated_values(p, paramS, doCalV)
         % Is paramS a struct?
         %  So we know how to access fields
         isStruct = isa(paramS, 'struct');
         
         outV = cell(p.np, 1);
         pNameV = cell(p.np, 1);
         pIdx = 0;
         for i1 = 1 : p.np
            ps = p.valueV{i1};
            if any(ps.doCal == doCalV)
               nameStr = p.nameV{i1};
               % Check whether field exists (only if paramS is struct)
               if ~isStruct ||  isfield(paramS, nameStr)
                  pValueV = paramS.(nameStr);     
                  if length(pValueV) <= 4
                     valueStr = stringLH.string_from_vector(pValueV(:), '%.3f');
                  else
                     valueStr = sprintf('%.3f to %.3f',  pValueV(1), pValueV(end));
                  end
               else
                  valueStr = 'missing';
               end
               pIdx = pIdx + 1;
               outV{pIdx} = [nameStr, ':  ',  valueStr];
               pNameV{pIdx} = nameStr;
            end
         end
         
         outV = outV(1 : pIdx);
         pNameV = pNameV(1 : pIdx);
      end
      
      
      %%  Show params that are close to bounds
      %{
      Only for params that are calibrated (ps.Cal == doCalV)
      IN:
         fp
            file pointer for output text file
      %}
      function show_close_to_bounds(p, paramS, doCalV, fp)
         % Tolerance
         dTol = 1e-2;
         fprintf(fp, '\nParameters that are close to bounds\n');
         for i1 = 1 : p.np
            ps = p.valueV{i1};
            if any(ps.doCal == doCalV)
               value2V = paramS.(ps.name);
               % Differences should be positive
               diffUbV = (ps.ubV(:) - value2V(:)) ./ max(0.1, abs(value2V(:)));
               diffLbV = (value2V(:) - ps.lbV(:)) ./ max(0.1, abs(value2V(:)));
               idxV = find((abs(diffUbV) < dTol)  |  (abs(diffLbV) < dTol));
               if ~isempty(idxV)
                  fprintf(fp, '  %s:  ',  ps.name);
                  for i2 = 1 : length(value2V)
                     fprintf(fp, '  [%.3f %.3f %.3f]',  ps.lbV(i2), value2V(i2), ps.ubV(i2));
                     if rem(i2, 5) == 0
                        fprintf(fp, '\n');
                     end
                  end
                  fprintf(fp, '\n');
               end
            end
         end
      end
   end
end

