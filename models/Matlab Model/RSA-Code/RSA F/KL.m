function [info] = KL(LL, beta, v, q_prior)
%KL(LL, beta, q_prior, v). LL is the literal listener matrix needed for this calculation.  I'm
%hard coding all the utterances we are using into this function, but, like
%the other functions, I can change this eventually. beta is the beta
%parameter setting. V determines the utterances used
if nargin < 4
    q_prior = .5;
end
if nargin < 3
    v = 0;
    q_prior = .5;
end



info = [];


if v == 0
    q1 = 'did 0 horses jump over?';
    q2 = 'did all the horses jump over?';
    q1_prior = q_prior;
    q2_prior = 1 - q1_prior;

    %asking q1
    info(1,1) = LL(1,1)*speclog(LL(1,1)/.5) + sum(LL(1,2:4)) * speclog(sum(LL(1,2:4)/.5));
    info(2,1) = LL(2,1)*speclog(LL(2,1)/.5) + sum(LL(2,2:4)) * speclog(sum(LL(2,2:4)/.5));
    info(3,1) = LL(3,1)*speclog(LL(3,1)/.5) + sum(LL(3,2:4)) * speclog(sum(LL(3,2:4)/.5));
    info(4,1) = LL(4,1)*speclog(LL(4,1)/.5) + sum(LL(4,2:4)) * speclog(sum(LL(4,2:4)/.5));

    %asking q2
    info(1,2) = LL(1,4)*speclog(LL(1,4)/.5) + sum(LL(1,1:3)) * speclog(sum(LL(1,1:3)/.5));
    info(2,2) = LL(2,4)*speclog(LL(2,4)/.5) + sum(LL(2,1:3)) * speclog(sum(LL(2,1:3)/.5));
    info(3,2) = LL(3,4)*speclog(LL(3,4)/.5) + sum(LL(3,1:3)) * speclog(sum(LL(3,1:3)/.5));
    info(4,2) = LL(4,4)*speclog(LL(4,4)/.5) + sum(LL(4,1:3)) * speclog(sum(LL(4,1:3)/.5));

    info(:,1) = (info(:,1)*q1_prior) .* beta;
    info(:,2) = (info(:,2)*q2_prior) .* beta;
    
elseif v == 1
    q1 = 'did the detective catch 2 guys?';
    q2 = 'did the detective catch everyone? ';
    q1_prior = q_prior;
    q2_prior = 1 - q1_prior;
    
    %asking q1
    info(1,1) = LL(1,2)*speclog(LL(1,2)/.5) + (LL(1,1) + sum(LL(1,3:4))) * speclog((LL(1,1) + sum(LL(1,3:4)))/.5);
    info(2,1) = LL(2,2)*speclog(LL(2,2)/.5) + (LL(2,1) + sum(LL(2,3:4))) * speclog((LL(2,1) + sum(LL(2,3:4)))/.5);
    info(3,1) = LL(3,2)*speclog(LL(3,2)/.5) + (LL(3,1) + sum(LL(3,3:4))) * speclog((LL(3,1) + sum(LL(3,3:4)))/.5);
    
    %asking q1
    info(1,2) = LL(1,4)*speclog(LL(1,4)/.5) + sum(LL(1,1:3)) * speclog(sum(LL(1,1:3))/.5);
    info(2,2) = LL(2,4)*speclog(LL(2,4)/.5) + sum(LL(2,1:3)) * speclog(sum(LL(2,1:3))/.5);
    info(3,2) = LL(3,4)*speclog(LL(3,4)/.5) + sum(LL(3,1:3)) * speclog(sum(LL(3,1:3))/.5);
    
    info(:,1) = (info(:,1)*q1_prior) .* beta;
    info(:,2) = (info(:,2)*q2_prior) .* beta;
    
elseif v == 2
    q1 = 'How many jumped?';
    q1DI = 1/3;
    q2 = 'did all the horses jump over?';
    q2DI = .5;
    q1_prior = q_prior;
    q2_prior = 1 - q1_prior;
    

    %asking q1
    info(1,1) = LL(1,1)*speclog(LL(1,1)/q1DI) + sum(LL(1,2:3)) * speclog(sum(LL(1,2:3)/q1DI));
    info(2,1) = LL(2,1)*speclog(LL(2,1)/q1DI) + sum(LL(2,2:3)) * speclog(sum(LL(2,2:3)/q1DI));

    %asking q2
    info(1,2) = LL(1,3)*speclog(LL(1,3)/q2DI) + sum(LL(1,1:2)) * speclog(sum(LL(1,1:2)/q2DI));
    info(2,2) = LL(2,3)*speclog(LL(2,3)/q2DI) + sum(LL(2,1:2)) * speclog(sum(LL(2,1:2)/q2DI));


    info(:,1) = (info(:,1)*q1_prior) .* beta;
    info(:,2) = (info(:,2)*q2_prior) .* beta; 
end
    
    
        
        
        
