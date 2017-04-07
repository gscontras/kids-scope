function [qstate] = QUDFun(LL, QUDs)
%QUDFun(QUD, state). This function inputs an normalized LL, and moves through each QUD to compute the partition space. I'm not exactly sure how to handle this yet.

q = length(QUDs);
u = size(LL,2);
s = size(LL,3);
w = size(LL,1);

qstate = [];

%if ndims(LL) == 4
    for b = 1:u
        for c = 1:s
            for d = 1:q
                if strcmpi(QUDs(d),'many?') == 1
                    qstate(:,b,c,d) = LL(:,b,c,d);
                elseif strcmpi(QUDs(d), 'all?') == 1
                    qstate(w,b,c,d) = LL(w,b,c,d);
                    for a = 1:(w-1)
                        qstate(a,b,c,d) = sum(LL(1:(w-1),b,c,d));
                    end
                elseif strcmpi(QUDs(d), 'none?') == 1
                    qstate(1,b,c,d) = LL(1,b,c,d);
                    for a = 2:w
                        qstate(a,b,c,d) = sum(LL(2:w,b,c,d));
                    end
%                 elseif strcmpi(QUDs(d), 'any?') == 1
%                     qstate(w,b,c,d) = LL(w,b,c,d);
%                     for a = 
                end
            end
        end
    end
% elseif ndims(LL) == 3
%     for b = 1:u
%         for c = 1:s
%             for d = 1:q
%                 if strcmpi(QUDs(d),'many?') == 1
%                     qstate(:,b,d) = LL(:,b,d);
%                 elseif strcmpi(QUDs(d), 'all?') == 1
%                     qstate(w,b,d) = LL(w,b,d);
%                     for a = 1:(w-1)
%                         qstate(a,b,d) = sum(LL(1:(w-1),b,d));
%                     end
%                 elseif strcmpi(QUDs(d), 'none?') == 1
%                     qstate(1,b,d) = LL(1,b,d);
%                     for a = 1:(w-1)
%                         qstate(a,b,d) = sum(LL(2:w,b,d));
%                     end
%                 end
%             end
%         end
%     end
%end

                