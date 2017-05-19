function [success] = worldPrior(frogs,probs)
%worldPrior(frogs, probs) 
%this function is very webpply. It takes in two arguments, our set of
%individuals and the probability of each individual succeeding. It then
%spits out a world state (consisting of successful individuals) 
%given these odds. iterate in the literal listener

tot = numel(frogs);
success = [];
check = 1;
for i = 1:tot
    if webpplFlip(probs(i)) == 1
        success{check} = frogs{i};
        check = check + 1;
    end
end

