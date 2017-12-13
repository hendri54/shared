function out1 = rand_time
% Generate a uniform random variable based on current time
%{
Does not disturb the random seed
This is a bit slow
%}

x = rng;
% Set seed based on time
rng('shuffle');
out1 = rand(1,1);
rng(x);

end