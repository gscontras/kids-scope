function [success] = none(x,y)
%none(x,y).  Y is the total items, and x is the amount we are concerned
%with.  This function represents the truth functional definition of 'none'.
%Returns 1, or true, when x = 0, and 0, or false, otherwise.
if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end
if x == 0
    success = 1;
else
    success = 0;
end
end

