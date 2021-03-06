%%D-RSA with QUD Component Model Script in Matlab.  Functions in RSA F
clc;
clear;
addpath('RSA F');
%This is just like the basic model, except this script is designed to run
%the model multiple times.  I made different scripts for the purpose of
%debuging, and so I can better see how a particular manipulation affects
%the results using the BasicRSA


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
%select utterances for this run
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
%worlds for 'every-not' (amb)
%worlds = [0 1 2 3];
%worlds for 'nottwo'
worlds = [0 1 2];

tot = worlds(end);
w = numel(worlds);

%available QUDs
tot_QUDs = {'many?',
    'all?',
    'none?',
    '<two?',
    'two?'};
QUDs = [1,2,3];
QUDs = uttselect(QUDs, tot_QUDs);
q = numel(QUDs);

%scopes
scopes = {'surface', 'inverse'};
s = numel(scopes);

%favored probability number
fv = .9;
unfw = (1 - fv)/(w - 1);
unfq = (1 - fv)/(q - 1);
wu = 1/w;
qu = 1/q;
%types of priors used for runs. Set the prior type to 0 for unifrom, 1
%otherwise

%%%%worlds prior
%4 state prior
% w_prior = [fv unfw unfw unfw
%     unfw fv unfw unfw
%     unfw unfw fv unfw
%     unfw unfw unfw fv
%     .25 .25 .25 .25];

w_prior = [fv unfw unfw
    unfw fv unfw
    unfw unfw fv
    (1/3) (1/3) (1/3)];

% w_prior = [fv unfw unfw unfw unfw
%     unfw fv unfw unfw unfw
%     unfw unfw fv unfw unfw
%     unfw unfw unfw fv unfw
%     unfw unfw unfw unfw fv
%     .2 .2 .2 .2 .2];

% w_prior = [fv unfw unfw unfw unfw unfw
%     unfw fv unfw unfw unfw unfw
%     unfw unfw fv unfw unfw unfw
%     unfw unfw unfw fv unfw unfw
%     unfw unfw unfw unfw fv unfw
%     unfw unfw unfw unfw unfw fv
%     (1/6) (1/6) (1/6) (1/6) (1/6) (1/6)];



%%%%scopes prior
s_pri = [.9 .1
    .7 .3
    .5 .5
    .3 .7
    .1 .9];
% s_pri = [.9 .1
%     .5 .5
%     .1 .9];


% %%%%QUD prior
q_prior = [fv unfq unfq
    unfq fv unfq
    unfq unfq fv
    (1/3) (1/3) (1/3)];

% q_prior = [fv unfq
%     unfq fv
%     .5 .5];


%Prior set, set 1 if manipulating, 0 otherwise. 2 if wrapping worlds
world_prior_sett = 0;
scope_prior_sett = 0;
qud_prior_sett = 1;

%Interaction Variables to save
w_priors = [];
s_priors = [];
q_priors = [];
m_u_ps = [];
count = 1;

%% Model

%adding worlds to multiple runs here
%nw is the total number of different world amounts we want.  
% nw = 4;
% worlds = [0 1 2];
% tot = worlds(end);
% w = numel(worlds);
% world_count = 0;
% for h = 1:nw
%     if world_count > 0
%         worlds(w + 1) = (tot + 1);
%         tot = worlds(end);
%         w = numel(worlds);
%     end
    
%change z,y,x here depending on number of priors used
%y is QUD
%x is scope
%z is world; z is number of worlds + 1
for z = 1:4
    for y = 1:4
        for x = 1:5
            %%Type of priors used
            %unifrom prior
            if world_prior_sett == 0
                for i = 1:w
                    prior_w(i) = 1/w;
                end
            elseif world_prior_sett == 1
                %manually adjust priors
                prior_w = w_prior(z,:);
            end
                
                    
            
            if scope_prior_sett == 0
                scopes_p = [.3 .7];
                %set to .7 .3 for sent in results
            else
                scopes_p = s_pri(x,:);
            end
            
            %type of priors on QUD
            if qud_prior_sett == 0
                for i = 1:q
                    QUD_prior(i) = 1/q;
                end
            else
                QUD_prior = q_prior(y,:);
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
                   
            w_priors(count,:) = [prior_w];
            s_priors(count,:) = [scopes_p];
            q_priors(count,:) = [QUD_prior];
            %make sure utterance_PS includes the state and utterance of
            %concern. %utterance_PS(state,utterance)  Also change how the variable is saving with the
            %appropriate variable
            %y is QUD
            %x is scope
            %z is world
            manip_concern = y;
            m_u_ps(manip_concern,:) = utterance_PS(2,2);
%             m_u_ps(count,1) = w_priors(count);
%             m_u_ps(count,2) = q_priors(count);
%             m_u_ps(count,3) = utterance_PS(3,2);
%             world_PS(nw,:)
            
            count = count + 1;   
        end
    end
end
%     world_count = world_count + 1;
% end
m_u_ps


%%%Need to change what the save is called
savename = 'twonot_qud';
save(savename,'w_priors','s_priors','q_priors','m_u_ps');









