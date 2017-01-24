function result = approx_equal(x1M, x2M, absToler, relToler, msgStr)
% Check whether 2 matrices are approximately equal

if nargin < 5
   msgStr = 'Approx equal fails';
end
if nargin < 4
   relToler = [];
end

% If any NaN: error
validateattributes(x1M, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(x2M)})
validateattributes(x2M, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

result = true;
if ~isempty(absToler)
   if any(abs(x1M(:) - x2M(:)) > absToler)
      result = false;
   end
end
if ~isempty(relToler)
   if any(abs((x2M(:) - x1M(:)) ./ max(1e-8, abs(x1M(:)))) > relToler)
      result = false;
   end
end


if nargout < 1  &&  ~result
   absDiffV = abs(x1M(:) - x2M(:));
   fprintf('Max difference:  absolute: %.4f  relative: %.4f \n',  max(absDiffV), ...
      max(absDiffV ./ max(1e-8, abs(x1M(:)))));
   if length(x1M) < 10  && length(x2M) < 10
      disp(x1M);
      disp(x2M);
   end
   error(msgStr);
end

end