function [success] = twonot(x,y)
%twonot(x,y).  This function determines if there are two things the
%subjected didn't verb.  So x is the amount the subject does verb, so the
%function tests if y (the total amount) minus x equals 2

if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end

if (y - x) == 2
    success = 1;
else
    success = 0;
end