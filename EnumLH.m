% Enum type
%{
Matlab has a built in emum type, but it's tedious because one has to define a new class each time an
enum is to be used (each in its own file)
This is an implementation using strings that can be used as follows

x = EnumLH('v1', {'v1', 'v2', 'v3});
x.is_valid('v3')
x.set('v2');
x.equals('v2')
%}
classdef EnumLH < handle
   
properties
   value
   valueList
end

methods
   %% Constructor
   function x = EnumLH(valueIn, valueListIn)
      x.valueList = valueListIn;
      x.set(valueIn);
   end
   
   %% Is a value valid?
   function out1 = is_valid(x, valueIn)
      out1 = any(strcmp(x.valueList, valueIn));
   end
   
   %% Set value
   function set(x, newValue)
      if x.is_valid(newValue)
         x.value = newValue;
      else
         error('Invalid value');
      end
   end
   
   %% Equality check
   function out1 = equals(x, valueIn)
      out1 = strcmp(x.value, valueIn);
   end
end
   
end