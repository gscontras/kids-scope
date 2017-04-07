function [success] = somemost(x,y)
%someevery(x,y). Takes two lists, a list of total players and a list of the
%matches with the players involved in those mathces.  It outputs a 0 or a
%1.  It outputs a 1 if there is a singular match that every player played
%in.  It outputs a 0 otherwise.
if length(x) < 2 || length(y) < 2
    error('There has to be at least two players in a match');
end
matches = size(y,1);
half = length(x)/2;
for i = 1:matches
    players_in_match = ismember(x,y(i,:));
    %checks to see if every player was in an individual match
    if length(find(players_in_match==1)) > half
        success = 1;
        break
    else
        success = 0;
    end
end
