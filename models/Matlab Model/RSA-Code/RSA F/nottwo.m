function [success] = nottwo(x,y)
%nottwo(x,y).  This function determines if x isn't equal to two.

if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end

if x ~= 2
    success = 1;
else
    success = 0;
end