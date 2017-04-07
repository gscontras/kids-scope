function [success] = ambiScope(x,y)
%ambiScope(x,y).  This function calculates in what worlds the scoppally
%ambiguous 'every horse didn't jump over the fence' is true it.
if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end

if x == 0 || x ~= y
    success = 1;
else
    success = 0;
end