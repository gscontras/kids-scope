function [success] = toss(x)
%Functions as the Church function does.  Takes a number between 0 and 1 and
%spits out true or false.
if nargin < 1
    x = .5;
end
if x > 1 || x < 0
    error('Number for flip needs to be between 0 and 1');
end
random = rand;
if random < x
    success = 1;
else
    success = 0;
end
end