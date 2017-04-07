%%D-RSA with QUD Component Model Script in Matlab.  Functions in RSA F
clc;
clear;
addpath('RSA F');

%variables to save for multiple runs
% wp_2 = [];
% wPLm_s_2 = [];
% wPLm_w_2 = [];
% wPSmj_utt_2 = [];
%
% sp_2 = [];
% sPLm_s_2 = [];
% sPLm_w_2 = [];
% sPSmj_utt_2 = [];
%
% qp_2 = [];
% qPLm_s_2 = [];
% qPLm_w_2 = [];
% qPSmj_utt_2 = [];
%
% twosp_2 = [];
% twosPLm_s_2 = [];
% twosPLm_w_2 = [];
% twosPSmj_utt_2 = [];

%Interaction Variables
w_priors = [];
s_priors = [];
q_priors = [];
m_u_ps = [];

uw_priors =[];
sq_u_ps = [];

%types of priors used for runs. Set the prior type to 0 for unifrom, 1
%otherwise

%%%%worlds prior
%4 state prior
w_prior = [.7 .1 .1 .1
    .1 .7 .1 .1
    .1 .1 .7 .1
    .1 .1 .1 .7
    .25 .25 .25 .25];
%3 state prior
% w_prior = [.8 .1 .1
%     .1 .8 .1
%     .1 .1 .8
%     (1/3) (1/3) (1/3)];
w_sett = 1;
%z is state

%%%%scopes prior
% s_pri = [.9 .1
%     .7 .3
%     .5 .5
%     .3 .7
%     .1 .9];
s_pri = [.9 .1
    .5 .5
    .1 .9];
s_sett = 1;
%x is scope

%%%%QUD prior
q_prior = [.8 .1 .1
    .1 .8 .1
    .1 .1 .8
    (1/3) (1/3) (1/3)];
%(1/3) (1/3) (1/3)];
qud_type = 1;
%y is QUD

%change z,y,x depending on number of priors used
count = 1;
for z = 1:4
    for y = 1:4
        for x = 1:3
            %% Parameters and Priors
            %total available utterances
            utterances = {'ambi',
                'null',
                'none',
                'every',
                'notall',
                'nottwo'};
            
            %select utterances for this run
            utt = [1,2];
            u = numel(utt);
            utt = uttselect(utt,utterances);
            opt = 2.5;
            
            %getting the costs
            for i = 1:u
                costs(i) = cost(utt{1});
            end
            
            %world states
            %specify descrete occurances
            worlds = [0 1 2 3];
            %worlds = [1 2 3 4];
            tot = worlds(end);
            w = numel(worlds);
            prior_w = [];
            
            %type of prior on worlds
            %unifrom prior
            if w_sett == 0
                for i = 1:w
                    prior_w(i) = 1/w;
                end
            else
                %manually adjust priors
                prior_w = w_prior(z,:);
            end
            
            %types of scopes
            scopes = {'surface', 'inverse'};
            s = numel(scopes);
            %scopes priors
            if s_sett == 0
                scopes_p = [.5 .5];
                %set to .7 .3 for sent in results
            else
                scopes_p = s_pri(x,:);
            end
            
            
            %available QUDs
            tot_QUDs = {'many?',
                'all?',
                'none?'};
            QUDs = [1,2,3];
            QUDs = uttselect(QUDs, tot_QUDs);
            q = numel(QUDs);
            %type of priors on QUD
            if qud_type == 0
                for i = 1:q
                    QUD_prior(i) = 1/q;
                end
            elseif qud_type == 1
                %manually adjust prior, if you won't want it uniform.  You will need to
                %alter this matrix if you change how many QUDs are in the model.  Order
                %in this Matrix indicates order in QUDs matrix
                QUD_prior = q_prior(y,:);
            else
                QUD_prior = [.1 .1 .8];
            end
            
            %% Literal Listener
            %rows are worlds
            %colums are utterances
            %3rd dimension is scope
            %4th dimension is QUDs
            %so in a matrix LL(a,b,c,d), a is always worlds, b is always utterances, c
            %is always scopes, and d is always QUDs
            
            Lit = [];
            for a = 1:w
                for b = 1:u
                    for c = 1:s
                        for d = 1:q
                            Lit(a,b,c,d) = LL(utt(b), QUDs(d), worlds(a), tot, scopes(c)).*prior_w(a);
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
                            temp_Lit(a,b,c,d) = (LL(utt(b), QUDs(d), worlds(a), tot, scopes(c)).*prior_w(a))/sums_Lit(a,b,c,d);
                        end
                    end
                end
            end
            temp_Lit(isnan(temp_Lit))=0;
            %Partition probability for QUD component
            p_Lit = QUDFun(temp_Lit, QUDs);
            %% Speaker
            %speaker time
            %currently no utterance prior here
            
            %This is the utility function, assuming utterance cost is uniform.
            %Will need to change if utterance cost becomes an issue
            temp_S = exp(opt.*(log(p_Lit) -1));
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
                            temp_PL(a,b,c,d) = p_S(a,b,c,d).*prior_w(a).*QUD_prior(d).*scopes_p(c);
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
            
            %normalizing for world state marginal
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
            
%             variable dump
%             qp_2(z,:) = QUD_prior;
%             qPLm_s_2(z,:) = scopes_PL(1,:);
%             qPLm_w_2(:,z) = worlds_PL(:,1);
%             qPSmj_utt_2(:,:,z) = utterance_PS;
%             
%             wp_2(z,:) = prior_w;
%             wPLm_s_2(z,:) = scopes_PL(1,:);
%             wPLm_w_2(:,z) = worlds_PL(:,1);
%             wPSmj_utt_2(:,:,z) = utterance_PS;
%             
%             sp_2(z,:) = scopes_p;
%             sPLm_s_2(z,:) = scopes_PL(1,:);
%             sPLm_w_2(:,z) = worlds_PL(:,1);
%             sPSmj_utt_2(:,:,z) = utterance_PS;
%             
%             twosp_2(z,:) = scopes_p;
%             twosPLm_s_2(z,:) = scopes_PL(1,:);
%             twosPLm_w_2(z,:) = worlds_PL(:,1);
%             twosPSmj_utt_2(:,:,z) = utterance_PS;

            w_priors(count,:) = [prior_w];
            s_priors(count,:) = [scopes_p];
            q_priors(count,:) = [QUD_prior];
            m_u_ps(count,:) = utterance_PS(2,1);
            count = count + 1;
            
%             uw_priors(count,:) = [prior_w];
%             s_priors(count,:) = [scopes_p];
%             q_priors(count,:) = [QUD_prior];
%             sq_u_ps(count,:) = utterance_PS(2,1);
%             count = count + 1;
            
        end
    end
end

%save the variables to a .mat file. Comment out the runs you hold constant
%(if I'm holding world prior uniform, then comment out the 'wp' save line)

% save('wp_Runs_2','wp_2','wPLm_s_2','wPLm_w_2','wPSmj_utt_2');
% save('sp_Runs_2','sp_2','sPLm_s_2','sPLm_w_2','sPSmj_utt_2');
% save('qp_Runs_2','qp_2','qPLm_s_2','qPLm_w_2','qPSmj_utt_2');
% save('qsp_Runs_2','qsp_2','qsPLm_s_2','qsPLm_w_2','qsPSmj_utt_2');
% save('twosp_Runs', 'twosPSmj_utt_2', 'twosPLm_w_2', 'twosPLm_s_2', 'twosp_2');
% save('m_Run','w_priors','s_priors','q_priors','m_u_ps');
% save('qs_Run','uw_priors','s_priors','q_priors','sq_u_ps');
%save('mu_Run','w_priors','s_priors','q_priors','m_u_ps');








