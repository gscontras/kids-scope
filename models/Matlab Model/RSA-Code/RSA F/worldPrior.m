function [success] = worldPrior(tot,probs)
%worldPrior(frogs, probs) 
%this function is very webpply. It takes in two arguments, our set of
%individuals and the probability of each individual succeeding. It then
%spits out a world state (consisting of successful individuals) 
%given these odds. iterate in the literal listener
 %%%NOTE: Changed this function to take total indiv., not each indiv
success = [];
for i = 1:tot
    if webpplFlip(probs) == 1
        success(i) = 1;
    else
        success(i) = 0;
    end
end

