%%D-RSA with QUD Component Model Script in Matlab.  Functions in RSA F
clc;
clear;
addpath('RSA F');
%This is the basic RSA that runs the model once for one sett of parameter
%settings.  Running the model multiple times while adjusting the parameters
%per run occurs in RSA_MultiManip



%% Parameters and Priors
%total available utterances
utterances = {'ambi',
    'null',
    'none',
    'every',
    'notall',
    'nottwo',
    'nottwoB',
    'notsome'};

%select utterances for this run. Number is place of utterance in list
utt = [2,7];
u = numel(utt);
utt = uttselect(utt,utterances);
%speaker optimality parameter
opt = 2.5;

% %getting the costs
% for i = 1:u
%     costs(i) = cost(utt{1});
% end


%world states
%specify descrete occurances

%worlds for 'every-not' (amb)
%worlds = [0 1 2 3];

%worlds for 'nottwo'
worlds = [0 1 2 3 4];

tot = worlds(end);
w = numel(worlds);
prior_w = [];

%available QUDs
tot_QUDs = {'many?',
    'all?',
    'none?',
    '<two?',
    'two?'};
QUDs = [1,4];
QUDs = uttselect(QUDs, tot_QUDs);
q = numel(QUDs);

%scopes
scopes = {'surface', 'inverse'};
s = numel(scopes);

%favored probability number
fv = .8;
unfw = (1 - fv)/(w - 1);
unfq = (1 - fv)/(q - 1);
wu = 1/w;
qu = 1/q;
%prior settings:
world_prior_sett = 0;
scope_prior_sett = 0;
qud_prior_sett = 0;

%type of prior on worlds


%unifrom prior 0
if world_prior_sett == 0
    for i = 1:w
        prior_w(i) = 1/w;
    end
else
    %manually adjust priors 1
    prior_w = [unfw unfw fv];
end


%scopes priors
if scope_prior_sett == 0
    scopes_p = [.5 .5];
else
    scopes_p = [.1 .9];
end

%type of priors on QUD
if qud_prior_sett == 0
    for i = 1:q
        QUD_prior(i) = 1/q;
    end
else
    %manually adjust prior. You will need to
    %alter this matrix if you change how many QUDs are in the model.  Order
    %in this Matrix indicates order in QUDs matrix
    QUD_prior = [fv unfq];
end

%% Literal Listener
%rows are worlds
%colums are utterances
%3rd dimension is scope
%4th dimension is QUDs
%so in a matrix LL(a,b,c,d), a is always worlds, b is always utterances, c
%is always scopes, and d is always QUDs

%meaning function
Lit = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                Lit(a,b,c,d) = meaning(utt(b), worlds(a), tot, scopes(c)).*prior_w(a);
            end
        end
    end
end

%get the sums that we will divide by in order to get the right probs
%for the qstate
sums_Lit = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                sums_Lit(a,b,c,d) = sum(Lit(:,b,c,d));
            end
        end
    end
end

%now lets calculate the probability for the Literal Listener matrix
temp_Lit = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                temp_Lit(a,b,c,d) = (meaning(utt(b), worlds(a), tot, scopes(c)).*prior_w(a))/sums_Lit(a,b,c,d);
            end
        end
    end
end
temp_Lit(isnan(temp_Lit))=0;
%Partition probability for QUD component, this is the delta function
p_Lit = QUDFun(temp_Lit, QUDs);
%% Speaker
%speaker time
%currently no utterance prior here

%This is the utility function, assuming utterance cost is uniform.
%Will need to change if utterance cost becomes an issue
temp_S = exp(opt.*(log(p_Lit)));
%probability of utterance, given state, scope, and qud
p_S = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                p_S(a,b,c,d) = temp_S(a,b,c,d)/sum(temp_S(a,:,c,d));
            end
        end
    end
end
p_S(isnan(p_S))=0;


%% Pragmatic Listener
%pragmatic Listener time
temp_PL = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                    temp_PL(a,b,c,d) = p_S(a,b,c,d).*QUD_prior(d).*scopes_p(c).*prior_w(a);
            end
        end
    end
end


%normalizing for scopes marginal
scopes_PL = [];
for b = 1:u
    for c = 1:s
        scopes_PL(b,c) = sum(sum(sum(temp_PL(:,b,c,:))))/sum(sum(sum(sum(temp_PL(:,b,:,:)))));
    end
end


%normalizing for world state marginal
worlds_PL = [];
for b = 1:u
    for a = 1:w
        worlds_PL(a,b) = sum(sum(sum(temp_PL(a,b,:,:))))/sum(sum(sum(sum(temp_PL(:,b,:,:)))));
    end
end

%normalizing for qud marginal
qud_PL = [];
for b = 1:u
    for d = 1:q
        qud_PL(b,d) = sum(sum(sum(temp_PL(:,b,:,d))))/sum(sum(sum(sum(temp_PL(:,b,:,:)))));
    end
end


%getting joint probability for PL, P(world,scope,qud | utterance)
jp_PL = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                jp_PL(a,b,c,d) = temp_PL(a,b,c,d)/sum(sum(sum(sum(temp_PL(:,b,:,:)))));
            end
        end
    end
end
jp_PL(isnan(jp_PL))=0;


%% Pragmatic Speaker
%marginal P(u|w) for pragmatic speaker (passing joint for PL)
utterance_PS = [];
for b = 1:u
    for a = 1:w
        utterance_PS(a,b) = sum(sum(sum(jp_PL(a,b,:,:))))/sum(sum(sum(sum(jp_PL(a,:,:,:)))));
    end
end

utterance_PS(3,2)