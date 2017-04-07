function [answer] = QUD(x, y)
%QUD(x, y).  x is what we are asking about.  I.e. 'did 2 horses
%make it over?'  In this case x would be 2.  The goal is to determine how
%well an utterance answers the QUD by assessing how much probability mass
%is assigned to each partition of the common ground. (i.e. how much mass is
%assigned to not-2 and how much is assigned to 2).  The minimum return
%value is .5 (assuming the question is a yes-no question) because .5 is the
%maximum amount of uncertainty you could have.  y is the partition
%containing the mass that isn't on x
if x > 1 || x < 0
    error('x should be a probability so check if its between 0 and 1');
end 
if sum(y) > 1 || sum(y) < 0
    error('x should be a probability so check if its between 0 and 1');
end 
out_Partition = sum(y);
if out_Partition > x
    answer = out_Partition;
else
    answer = x;
end 
end