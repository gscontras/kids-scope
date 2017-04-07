function [info] = newKL(LL, utterances, QUDs, scopes)
%KL(LL, utterance, QUD, scope, tot). LL is the literal listener matrix needed for this calculation.  I'm
%hard coding all the utterances we are using into this function, but, like
%the other functions, I can change this eventually. beta is the beta
%parameter setting. V determines the utterances used
if nargin < 4
    scopes = 'surface';
end
info = [];
w = size(LL,1);
u = length(utterances);
q = length(QUDs);
s = length(scopes);

if ndims(LL) == 4
    for b = 1:u
        for c = 1:s
            for d = 1:q
                if strcmpi(utterances(b), 'ambi') == 1
                    if strcmpi(scopes(c), 'surface') == 1
                        if strcmpi(QUDs(d), 'many?') == 1
                            temp_info = 0;
                            for a = 1:w
                                temp_info = temp_info + LL(a,b,c,d)*speclog(LL(a,b,c,d)/(1/3));
                            end
                            info(b,c,d) = temp_info;
                        elseif strcmpi(QUDs(d), 'all?') == 1
                            info(b,c,d) = LL(w,b,c,d)*speclog(LL(w,b,c,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,c,d))/.5);
                        elseif strcmpi(QUDs(d), 'none?') == 1
                            info(b,c,d) = LL(1,b,c,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,c,d))*speclog(sum(LL(2:w,b,c,d))/.5);
                        end
                    elseif strcmpi(scopes(c), 'inverse') == 1
                        if strcmpi(QUDs(d), 'many?') == 1
                            temp_info = 0;
                            for a = 1:w
                                temp_info = temp_info + LL(a,b,c,d)*speclog(LL(a,b,c,d)/(1/3));
                            end
                            info(b,c,d) = temp_info;
                        elseif strcmpi(QUDs(d), 'all?') == 1
                            info(b,c,d) = LL(w,b,c,d)*speclog(LL(w,b,c,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,c,d))/.5);
                        elseif strcmpi(QUDs(d), 'none?') == 1
                            info(b,c,d) = LL(1,b,c,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,c,d))*speclog(sum(LL(2:w,b,c,d))/.5);
                        end
                    end
                elseif strcmpi(utterances(b), 'null') == 1
                    if strcmpi(QUDs(d), 'many?') == 1
                        temp_info = 0;
                        for a = 1:w
                            temp_info = temp_info + LL(a,b,c,d)*speclog(LL(a,b,c,d)/(1/3));
                        end
                        info(b,c,d) = temp_info;
                    elseif strcmpi(QUDs(d), 'all?') == 1
                        info(b,c,d) = LL(w,b,c,d)*speclog(LL(w,b,c,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,c,d))/.5);
                    elseif strcmpi(QUDs(d), 'none?') == 1
                        info(b,c,d) = LL(1,b,c,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,c,d))*speclog(sum(LL(2:w,b,c,d))/.5);
                    end
                elseif strcmpi(utterances(b), 'none') == 1
                    if strcmpi(QUDs(d), 'many?') == 1
                        temp_info = 0;
                        for a = 1:w
                            temp_info = temp_info + LL(a,b,c,d)*speclog(LL(a,b,c,d)/(1/3));
                        end
                        info(b,c,d) = temp_info;
                    elseif strcmpi(QUDs(d), 'all?') == 1
                        info(b,c,d) = LL(w,b,c,d)*speclog(LL(w,b,c,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,c,d))/.5);
                    elseif strcmpi(QUDs(d), 'none?') == 1
                        info(b,c,d) = LL(1,b,c,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,c,d))*speclog(sum(LL(2:w,b,c,d))/.5);
                    end
                elseif strcmpi(utterances(b), 'every') == 1
                    if strcmpi(QUDs(d), 'many?') == 1
                        temp_info = 0;
                        for a = 1:w
                            temp_info = temp_info + LL(a,b,c,d)*speclog(LL(a,b,c,d)/(1/3));
                        end
                        info(b,c,d) = temp_info;
                    elseif strcmpi(QUDs(d), 'all?') == 1
                        info(b,c,d) = LL(w,b,c,d)*speclog(LL(w,b,c,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,c,d))/.5);
                    elseif strcmpi(QUDs(d), 'none?') == 1
                        info(b,c,d) = LL(1,b,c,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,c,d))*speclog(sum(LL(2:w,b,c,d))/.5);
                    end
                elseif strcmpi(utterances(b), 'notall') == 1
                    if strcmpi(QUDs(d), 'many?') == 1
                        temp_info = 0;
                        for a = 1:w
                            temp_info = temp_info + LL(a,b,c,d)*speclog(LL(a,b,c,d)/(1/3));
                        end
                        info(b,c,d) = temp_info;
                    elseif strcmpi(QUDs(d), 'all?') == 1
                        info(b,c,d) = LL(w,b,c,d)*speclog(LL(w,b,c,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,c,d))/.5);
                    elseif strcmpi(QUDs(d), 'none?') == 1
                        info(b,c,d) = LL(1,b,c,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,c,d))*speclog(sum(LL(2:w,b,c,d))/.5);
                    end
                end
            end
        end
    end
elseif ndims(LL) == 3
    for b = 1:u
        for d = 1:q
            if strcmpi(utterances(b), 'every') == 1
                if strcmpi(QUDs(d), 'many?') == 1
                    temp_info = 0;
                    for a = 1:w
                        temp_info = temp_info + LL(a,b,d)*speclog(LL(a,b,d)/(1/3));
                    end
                    info(b,d) = temp_info;
                elseif strcmpi(QUDs(d), 'all?') == 1
                    info(b,d) = LL(w,b,d)*speclog(LL(w,b,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,d))/.5);
                elseif strcmpi(QUDs(d), 'none?') == 1
                    info(b,d) = LL(1,b,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,d))*speclog(sum(LL(2:w,b,d))/.5);
                end
            elseif strcmpi(utterances(b), 'none') == 1
                if strcmpi(QUDs(d), 'many?') == 1
                    temp_info = 0;
                    for a = 1:w
                        temp_info = temp_info + LL(a,b,d)*speclog(LL(a,b,d)/(1/3));
                    end
                    info(b,d) = temp_info;
                elseif strcmpi(QUDs(d), 'all?') == 1
                    info(b,d) = LL(w,b,d)*speclog(LL(w,b,d)/.5) + sum(LL(1:(w-1),b,c,d))*speclog(sum(LL(1:(w-1),b,d))/.5);
                elseif strcmpi(QUDs(d), 'none?') == 1
                    info(b,d) = LL(1,b,d)*speclog(LL(1,b,c,d)/.5) + sum(LL(2:w,b,d))*speclog(sum(LL(2:w,b,d))/.5);
                end
            end
        end
    end
end
                
    
    
    
    
    
    
    
    
    
    
    
    
    
    
