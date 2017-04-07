function [select] = sampler(x)
%sampler(x). this function just takes a bunch of discrete probabilities as
%inputs and selects one of them as a function of how likely it is to select
%that one

final = numel(x);
roll = rand;
concern = x(1);
for i = 1:final
    if roll < concern
        select = i;
        break
    else
        concern = concern + x(i + 1);
    end
end