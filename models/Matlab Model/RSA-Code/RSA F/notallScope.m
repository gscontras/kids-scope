function [success] = notallScope(x,y,rand)
%notallScope(x,y,rand).  Y is the total number of items, and x is the number we are
%concerned with.  If 2 of three apples are red, then x=2 and y=3.  The
%function checks if "not all x, y" is true or false, outputting 1 or 0
%repectively.  This function is 'every's lexical, truth functional content.
if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end
%checks to see if 0 probs should be assigned
if nargin < 3
    rand = 0;
end

if rand == 1
    if x ~= y
        success = .99;
    else
        success = .01;
    end
else
    if x ~= y
        success = 1;
    else
        success = 0;
    end
end
end

