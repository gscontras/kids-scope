function [success] = LL(utt, QUD, state, tot, scope)
%LL(utt, scope, QUD, worlds, tot). Not sure how to do this one either.  I think I might
%need a two matrix output here.
if nargin < 5
    scope = 'surface';
end
 
m = meaning(utt, state, tot, scope);
if m == 1
    success = 1;
else
    success = 0;
end

end


