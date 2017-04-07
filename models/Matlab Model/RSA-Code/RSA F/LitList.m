function [LL, M] = LitList(w, v)
%LitList(w, v).  This function takes as input a world state and spits out a
%literal listener probability matrix L(w|u).  The utterances are 'hard
%coded' into this function, but in the future I may want to figure out how
%to specify which utterances I want to use in the input to the function. V
%determines the type of vocabulary we are using. V = 0 for everynot. V = 1
%for two not two.
if length(w) < 1 
    error('there needs to exist a world in order to compute probabilities over world states')
end

LL = [];
tot = w(end);

if v == 0
    %what utterances are being used? 
    %everysum = 0;
    nonesum = 0;
    notallsum = 0;
    allsum = 0;

    for i = 1:length(w)
        notallsum = notallsum + notallScope(w(i), tot);
        nonesum = nonesum + noneScope(w(i), tot);
        allsum = allsum + every(w(i), tot);
    end

    for i = 1:length(w)
        %The 'not all' utterance unambi
        LL(1,i) = notallScope(w(i), tot)/notallsum;
        %the 'none' utterance unambi
        LL(2,i) = noneScope(w(i), tot)/nonesum;
        %the 'every' utterance
        LL(3,i) = every(w(i), tot)/allsum;
    end
    %The ambi 'every not' utterance
    LL(4,:) = (LL(1,:) + LL(2,:))/2;
    
elseif v == 1
    %what utterances are being used?
    twonotsum = 0;
    nottwosum = 0;

    for i = 1:length(w)
        twonotsum = twonotsum + twonot(w(i), tot);
        nottwosum = nottwosum + nottwo(w(i), tot);
    end

    for i = 1:length(w)
        %The 'two' utterance unambi
        LL(1,i) = twonot(w(i), tot)/twonotsum;
        %the 'nottwo' utterance unambi
        LL(2,i) = nottwo(w(i), tot)/nottwosum;
    end
    %The ambi 'every not' utterance
    LL(3,:) = (LL(1,:) + LL(2,:))/2;
    
elseif v == 2
    %what utterances are being used? 
    %A Null utterance
    notallsum = 0;
    nonesum = 0;

    for i = 1:length(w)
        notallsum = notallsum + notallScope(w(i), tot);
        nonesum = nonesum + noneScope(w(i), tot);
    end

    for i = 1:length(w)
        %The 'not all' utterance unambi
        LL(1,i) = notallScope(w(i), tot);%/notallsum;
        %the 'none' utterance unambi
        LL(2,i) = noneScope(w(i), tot);%/nonesum;
    end
    %The ambi 'every not' utterance
    LL(1,:) = (LL(1,:) + LL(2,:))/(notallsum + nonesum);
    LL(2,:) = 1/length(w);  
    for i = 1:length(w)
        %The 'not all' utterance unambi
        M(1,i) = notallScope(w(i), tot)/notallsum;
        %the 'none' utterance unambi
        M(2,i) = noneScope(w(i), tot)/nonesum;
    end
    M(3,:) = 1/length(w);
end
    

