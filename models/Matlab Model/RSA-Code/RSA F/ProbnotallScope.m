function [success] = ProbnotallScope(x,y,Tprob,Fprob)
%notallScope(x,y).  Y is the total number of items, and x is the number we are
%concerned with.  If 2 of three apples are red, then x=2 and y=3.  The
%function checks if "not all x, y" is true or false, outputting 1 or 0
%repectively.  This function is 'every's lexical, truth functional content.
%Tprob and Fprob represent uncertainty abou the truth-function.

if x > y
    error('A sub-amount of the items cant be more than the total number of items');
end
if nargin < 3
    Tprob = 1;
    Fprob = 1;
end
if x ~= y
    if rand < Tprob
        success = 1;
    else
        success = 0;
    end
else
    if rand < Fprob
        success = 0;
    else
        success = 1;
    end
end
end

