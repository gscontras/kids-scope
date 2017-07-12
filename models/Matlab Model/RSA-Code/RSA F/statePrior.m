function [statePrior] = statePrior(tot, baserate, iter)
%statePrior(frogs, probs,iter) 
%this function calculates my state prior as it was instatiated in the
%orginal model (Sav, 2017). It uses the individual probabilities of each
%individual (frogs or horses) to do this.  I could do this analytically,
%but this is more intuitive.  Important note: this function will be
%'decoupled' from the indivPrior in the meaning function. This shouldn't
%matter since in the limit the two will be equal, but the variances in each
%calculation won't be the same since I'm running the calculation twice
%(also its innefficient this way)
%Should I do this in the literal listener? I could also just put the entire
%frog draws into this function - that might be better. I can't do this
%because the number of draws in each row must be the same, and they aren't
%for frogdraws.


for i = 1:iter
    world = worldPrior(tot,baserate);
    x = sum(world);
    States(i) = x;
end
for i = 1:(tot + 1)
    y(i) = sum(States(:) == (i - 1))/iter;
end
y(isnan(y))=0;

statePrior = y;