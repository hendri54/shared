% Matrix class
%{
Goals:
   Enforce fixed size
   Avoid indexing errors (forgotten dimensions etc)
   Have a distinct missing value

Rules:
   Once type is set, it can never change
   Automatic type conversion for changing elements later on

Change:
   allow setting / retrieving for index combinations (similar to sub2ind and ind2sub)
%}
classdef Matrix < handle
   
properties
   % Matrix
   mM
   % Size
   sizeV
   % Missing value code
   missVal
   % Type as string (e.g. 'double')
   typeStr  char
   
   dbg  uint16 = 0
end

properties (Constant)
   % Symbol for retrieving all values in a dimension
   all = -10;
   last = -11;
   % Symbols for operations
   plus = -21;
   minus = -22;
   times = -23;
   divide = -24;
end

methods
   %% Constructor
   %{
   Optional arguments
      missVal
   %}
   function mS = Matrix(inM, missValIn)
      if nargin < 2
         missValIn = -9191;
      end
      mS.mM = inM;
      mS.sizeV = size(mS.mM);
      mS.missVal = missValIn;
      mS.typeStr = class(inM);
   end
   
   
   %% Validation
   % May contain NaN
   function validate(mS)
      validateattributes(mS.mM, {mS.typeStr}, {'real', 'size', mS.sizeV})
   end
   
   
   %% Translate an index vector into ranges
   %{
   Enforces that indices are in range
   
   IN
      indexV :: cell array
         each entry describes the indices for 1 dimension
         range: 3:5
         list:  [1 3 4]
         special values: mS.all
         range as cell array: {5, mS.last}, {1, 7}
   
   OUT
      outV :: cell array
         each entry is an integer range or vector
         one can access elements using `mS.mM(outV{:})`
   %}
   function outV = make_index(mS, indexV)
      nd = length(mS.sizeV);
      if length(indexV) ~= nd
         error('Invalid indices');
      end
      
      outV = cell(nd, 1);
      % Loop over dimensions
      for i1 = 1 : nd
         idx = indexV{i1};
         if isnumeric(idx)
            % Single numeric value: can be singleton or special value
            if length(idx) == 1
               if idx < 0
                  % Special values
                  if idx == mS.all
                     outV{i1} = 1 : mS.sizeV(i1);
                  else
                     error('Invalid');
                  end
               else
                  % Singleton numeric
                  outV{i1} = idx;
               end
            else
               % Numeric range or vector
               outV{i1} = indexV{i1};
            end
         elseif iscell(idx)
            % Cell of length 2 describing a range
            if length(idx) == 2
               rangeV = nan(2,1);
               for i2 = 1 : 2
                  if idx{i2} == mS.last
                     rangeV(i2) = mS.sizeV(i1);
                  else
                     % Just a number
                     rangeV(i2) = idx{i2};
                  end
               end
               % Make a range
               if rangeV(1) <= rangeV(2)
                  outV{i1} = rangeV(1) : rangeV(2);
               else
                  outV{i1} = rangeV(1) : -1 : rangeV(2);
               end
            else
               error('Invalid');
            end
         end
         
         validateattributes(outV{i1}, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, ...
            '<=', mS.sizeV(i1)})
      end % i1
   end
   
   
   %% Getindex
   %{
   Retrieve matrix values for indices given in `indexInV` cell array
   %}
   function outM = getindex(mS, indexInV)
      % Make numeric indices
      indexV = mS.make_index(indexInV);
      outM = mS.mM(indexV{:});
   end
   
   
   %% Setindex
   %{
   With automatic type conversion
   Out of range indices result in error
   %}
   function setindex(mS, inM, indexInV)
      % Make numeric indices
      indexV = mS.make_index(indexInV);
      mS.mM(indexV{:}) = cast(inM, mS.typeStr);
   end
   
   
   %% Set
   % With automatic type conversion
   function set(mS, inM)
      validateattributes(inM, {'numeric'}, {'real', 'size', mS.sizeV})
      mS.mM = cast(inM, mS.typeStr);
   end
   
   
   %% Matrix operations
   %{
   Example:
      mS.oper(inM, mS.plus)
      adds m1 + m2. If missing, replace with missVal

   Input can be scalar
   %}
   function oper(mS, inM, operSym)
      outM = mS.operOut(inM, operSym);
      mS.set(outM);
   end
      
   % The same, but returns the result as an ordinary matlab matrix
   function outM = operOut(mS, inM, operSym)
      % Size check
      if ~isequal(mS.sizeV, size(inM))  &&  ~isscalar(inM)
         error('Size mismatch');
      end
      
      % Mark missing values
      isMissM = (mS.mM == mS.missVal);
      if ~isscalar(inM)
         isMissM(inM == mS.missVal) = true;
      end

      if operSym == mS.plus
         outM = mS.mM + cast(inM, mS.typeStr);
      elseif operSym == mS.minus
         outM = mS.mM - cast(inM, mS.typeStr);
      elseif operSym == mS.times
         outM = mS.mM .* cast(inM, mS.typeStr);
      elseif operSym == mS.divide
         outM = mS.mM ./ cast(inM, mS.typeStr);
         %mS.mM(abs(inM) < 1e-8) = mS.missVal;
      else
         error('Invalid operSym');
      end

      % Handle missing values
      outM(isMissM) = mS.missVal;
   end
   
   
   %% Vector operations
   %{
   Example: add a column vector to each column of the matrix
   Only for 2D matrices
   Simply expands the vector into a matrix and call oper
   %}
   function vector_oper(mS, vecIn, operSym)
      outM = mS.vector_operOut(vecIn, operSym);
      mS.set(outM);
   end
   
   function outM = vector_operOut(mS, vecIn, operSym)
      if length(mS.sizeV) ~= 2
         error('Only for 2d matrices');
      end
      sizeInV = size(vecIn);
      if all(sizeInV == 1)
         % Scalar
         outM = mS.operOut(repmat(vecIn, mS.sizeV), operSym);
      elseif sizeInV(1) == 1
         % Row vector
         outM = mS.operOut(repmat(vecIn, [mS.sizeV(1), 1]), operSym);
      elseif sizeInV(2) == 1
         % Col vector
         outM = mS.operOut(repmat(vecIn, [1, mS.sizeV(2)]), operSym);
      else
         error('Must be a vector');
      end
   end
   
   
   function add(mS, inM)
      mS.oper(inM, mS.plus);
   end
   
   
   % *******  Add a vector 
   % Only useful for 2-dim matrix
   function add_vector(mS, vecIn)
      mS.vector_oper(vecIn, mS.plus);
   end
   
   
   %% Formatting: Make cell array of strings
   %{
   %}
   function outM = formatted_cell_array(mS, fmtStrV, colOrRowStr)
      outM = cell(mS.sizeV);
      
      if strcmpi(colOrRowStr, 'col')
         byCol = true;
         n = mS.sizeV(2);
      elseif strcmpi(colOrRowStr, 'row')
         byCol = false;
         n = mS.sizeV(1);
      else
         error('Invalid');
      end

      for i1 = 1 : n
         if ischar(fmtStrV)
            fmtStr1 = fmtStrV;
         else
            fmtStr1 = fmtStrV{i1};
         end
         
         if byCol
            outM(:,i1) = cellfun(@(x) sprintf(fmtStr1, x), num2cell(mS.mM(:,i1)), 'UniformOutput', false);
         else
            outM(i1,:) = cellfun(@(x) sprintf(fmtStr1, x), num2cell(mS.mM(i1,:)), 'UniformOutput', false);
         end
      end
   end
end

end