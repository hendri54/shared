function out1 = rand_time
% Generate a uniform random variable from the current time
%{
Does not disturb the random seed
This is a bit slow
%}

x = rng;
rng('shuffle');
out1 = rand(1,1);
rng(x);

end