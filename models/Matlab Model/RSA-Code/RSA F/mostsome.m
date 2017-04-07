function [success] = mostsome(x, y)
%everysome(x,y).  Takes two lists, a lists of players and a lists of
%matches and the players involved in those matches.  It outputs a 1 or a 0.
% It out puts a 1 if it is the case that every player played in any match.
% So if there is a player that didn't play in a match the output is 0, but
% if every player played in a match (any match) then the output is 1.
if length(x) < 2 || length(y) < 2
    error('There has to be at least two players in a match');
end
half = length(x)/2;
did_player_play = ismember(x, y);
%checks if most the players played in a match
if length(find(did_player_play==1)) > half;
    success = 1;
else
    success = 0;
end