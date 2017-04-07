function [success] = every(x,y)
%every(x,y).  Y is the total number of items, and x is the number we are
%concerned with.  If 2 of three apples are red, then x=2 and y=3.  The
%function check if "Every apple is red" is true or false, outputting 1 or 0
%repectively.  This function is 'every's lexical, truth functional content.
if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end
if x == y
    success = 1;
else
    success = 0;
end
end

