%%D-RSA with QUD Component Model Script in Matlab. Specific world state version.  Functions in RSA F
clc;
clear;
addpath('RSA F');

%This is the model for concerning ourselves with particular world states.

%total list of utterances
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

%frogs we are dealing with
tot_frogs = {'Paco',
    'Pablo',
    'Juan',
    'Brian'};
which_frogs = [1,4];
frogs = uttselect(which_frogs, tot_frogs);
tot = numel(frogs);
%prior of each frogs jump (this currently sucks)
frogProbs = [.5 .9 .9 .5];

%indivPrior for each frog 
for i = 1:tot
    indivPrior(i) = frogProbs(which_frogs(i));
end

%statePrior, given the frog probabilities
iter = 1000;
statePrior = statePrior(frogs, indivPrior, iter);


%worldPrior - webppl style
% sim = [];
% tj = [];
% for t = 1:10000
%     for i = 1:tot
%     sim(i,t) = webpplFlip(indivPrior(i));
%     end
%     tj(t) = sum(sim(:,t));
% end
% for i = 1:(tot + 1)
%     total_prior(i) = sum(tj == (i - 1));
% end
% iter = sum(total_prior);
% for i = 1:(tot + 1)
%     total_prior(i) = total_prior(i)/iter;
% end
% 
% for i = 1:1000
%     world = worldPrior(frogs, indivPrior);
%     x = numel(world);
%     tot(i) = x;
% end
% y(1) = sum(tot(:) == 0)/1000;
% y(2) = sum(tot(:) == 1)/1000;
% y(3) = sum(tot(:) == 2)/1000

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



