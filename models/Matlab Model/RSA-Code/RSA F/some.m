function [success] = some(x,y)
%some(x,y). Y is the total number of items and x is some number we are
%cocerned with.  This function represents the truth functional definition
%of 'some'.  It outputs 1, or true, when x > 0, and false when x = 0.
if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end
if x > 0
    success = 1;
else
    success = 0;
end


end

