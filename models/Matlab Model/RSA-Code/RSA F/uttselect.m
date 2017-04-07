function [success] = uttselect(x,y)
%uttselect(x) takes an array of utterances as input, and spits out the
%utterances you want from that array.  x should be the placement in the
%array of the utterances you want, and y should be the array. Should spit
%out a smaller utterance array

final = max(x);
inc = 1;
for i = 1:final
    if ismember(i,x) == 1
        success{inc} = y{i};
        inc = inc + 1;
    end
end