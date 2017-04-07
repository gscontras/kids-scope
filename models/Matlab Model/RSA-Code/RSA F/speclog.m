function [ans] = speclog(x)
%speclog(x).  This is a special Log function designed to return 0, when x =
%0.  Normally the Log function returns -Inf.  
if x == 0
    ans = 0;
else
    ans = log(x);
end