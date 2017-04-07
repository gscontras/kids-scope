function [utility] = util(LL, alpha)
%util(LL, alpha). x equals the number of answers the the calculation entertains.  I'm
%hard coding all the utterances we are using into this function, but, like
%the other functions, I can change this eventually. beta is the beta
%parameter setting.
if nargin < 2
    alpha = 1;
end

w = length(LL(1,:));
utility = [];

utility = LL;

utility(isnan(utility)) = 0;
utility = utility .* alpha;

