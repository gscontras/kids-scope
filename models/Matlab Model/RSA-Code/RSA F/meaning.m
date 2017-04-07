function [success] = meaning(utt, state, tot, scope)
%meaning(utt, state, tot, scope) I input in an utternace, state, total possible in world and scope, and
%return either a 1 if its true in this world state or a 0 if the utterance
%is false in this world state.  

if nargin < 4
    scope = 'surface';
end
%I'm going to need to specify the semantics of each utterance type here
if strcmpi(utt,'ambi') == 1
    if strcmpi(scope, 'surface') == 1
        if state == 0
            success = 1;
        else 
            success = 0;
        end
    else
        if state < tot
            success = 1;
        else
            success = 0;
        end
    end
elseif strcmpi(utt, 'null') == 1
    success = 1;
elseif strcmpi(utt, 'none') == 1
    if state == 0
        success = 1;
    else
        success = 0;
    end
elseif strcmpi(utt, 'every') == 1
    if state == tot
        success = 1;
    else
        success = 0;
    end
elseif strcmpi(utt, 'notall') == 1
    if state < tot
        success = 1;
    else
        success = 0;
    end
elseif strcmp(utt, 'nottwo') == 1
    if strcmpi(scope, 'surface') == 1
        %"It is not the case that X did two"
        if state == 2
            success = 0;
        else
            success = 1;
        end
    else
        if state == 2
            success = 1;
        else
            success = 0;
        end
    end
end
