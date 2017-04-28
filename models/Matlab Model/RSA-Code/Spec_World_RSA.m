%%D-RSA with QUD Component Model Script in Matlab. Specific world state version.  Functions in RSA F
clc;
clear;
addpath('RSA F');
%This is the model for concerning ourselves with particular world states.
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