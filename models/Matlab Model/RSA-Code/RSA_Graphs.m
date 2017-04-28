%Graphs
clc;
clear;
addpath('RSA F');
addpath('Data');
%save(filename,variables) 
%load(filename)

qud = load('twonot_qud.mat');
scope = load('twonot_scope.mat');
world = load('twonot_world.mat');

quds = qud.m_u_ps;
scopes = scope.m_u_ps;
worlds = world.m_u_ps;




%csvwrite('world_manip',worlds);
%csvwrite('qud_manip9',quds);
%csvwrite('scope_manip',scopes);

% super_endorse = [3 .1 2 .9494
%     3 .5 2 .9600
%     3 .9 2 .9722];
%csvwrite('super_endorse',super_endorse);

super_endorse = [3 .1 2 .9890
    3 .5 2 .9915
    3 .9 2 .9943];
%csvwrite('super_endorse9',super_endorse);


    
    

% w_2 = [];
% for z = 1:5
%     w_2(z) = wPSmj_utt_2(3,1,z);
% end
% w_2(2:3) = [];
% x = w_2(3);
% w_2(3) = w_2(2);
% w_2(2) = x;
% subplot(1,3,1);
% bar(w_2)
% ylim([.2 .72]);
% set(gca, 'XTickLabel', {'0 jump', 'Uniform ', 'all jump'});
% %title('PS Endorsement probability of Ambi in world state 2/3');
% %ylabel('Probability of pragmatic speaker endorsing the ambiguous utterance');
% xlabel('Favored world state');
% 
% s_2 = [];
% for z = 1:5
%     s_2(z) = sPSmj_utt_2(3,1,z);
% end
% s_2(2) = [];
% s_2(3) = [];
% subplot(1,3,3);
% bar(s_2,'g')
% ylim([.2 .72]);
% set(gca, 'XTickLabel', {'.1', '.5', '.9'});
% %title('Pragmatic Speaker endorsement probability of the ambiguous utterance in world state 2/3');
% %ylabel('Probability of Endorsement');
% xlabel('Prior on inverse scope');
% 
% 
% q_2 = [];
% for z = 1:4
%     q_2(z) = qPSmj_utt_2(3,1,z);
% end;
% q_2(1:3) = sort(q_2(1:3));
% q_2(4) = [];
% subplot(1,3,2);
% bar(q_2,'m')
% ylim([.2 .72]);
% set(gca, 'XTickLabel', {'0 jump? ', 'how many? ', ' all jump?'});
% %title('PS Endorsement probability of Ambi in world state 2/3');
% %ylabel('Probability of Endorsement');
% xlabel('Favored QUD');
% % set(findobj('type','axes'),'fontsize',12)

% twos_2 = [];
% for z = 1:5
%     twos_2(z) = twosPSmj_utt_2(2,1,z);
% end
% twos_2 = sort(twos_2);
% % figure
% % bar(twos_2);
% % ylim([0 1]);
% % set(gca, 'XTickLabel', {'.1', '.3', '.5', '.7', '.9'});

% m_matrix = [];
% for i = 1:48
%     m_matrix(i,:) = m_find(w_priors, s_priors, q_priors, m_u_ps, i);
% end

%normal graphs

% uniform = [3, .3, 3, .4496];
% worlds = [

% sq_matrix = [];
% for i = 1:27
%     sq_matrix(i,:) = m_find(uw_priors, s_priors, q_priors, sq_u_ps, i);
% end
    
% %%%multi_plots
% f = 1;
% c = 3;
% figure(1)
% for p = 1:9
%     subplot(3,3,p)
%     bar(m_matrix(f:c,4))
%     set(gca, 'XTickLabel', {'.1', '.5', '.9'});
%     %title('w = ' m_matrix);
%     ylim([0 1]);
%     f = f + 3;
%     c = c + 3;
% end
% 
% f = 1;
% c = 3;
% figure(2)
% for p = 1:3
%     subplot(3,3,p)
%     bar(sq_matrix(f:c,4))
%     set(gca, 'XTickLabel', {'.1', '.5', '.9'});
%     %title('w = ' m_matrix);
%     ylim([0 1]);
%     f = f + 3;
%     c = c + 3;
% end








% figure;
% bar(w_2)
% ylim([0 1]);
% set(gca, 'XTickLabel', {'0', '1', '2', '3', 'Uniform'});
% %title('PS Endorsement probability of Ambi in world state 2/3');
% %ylabel('Probability of pragmatic speaker endorsing the ambiguous utterance');
% %xlabel('Favored world state');

% figure;
% bar(s_2,'g')
% ylim([0 1]);
% set(gca, 'XTickLabel', {'.1', '.3', '.5', '.7', '.9'});
% %title('Pragmatic Speaker endorsement probability of the ambiguous utterance in world state 2/3');
% %ylabel('Probability of Endorsement');
% %xlabel('Prior on inverse scope');

% figure;
% bar(q_2,'m')
% ylim([0 1]);
% set(gca, 'XTickLabel', {'none?', 'many?', 'all?', 'Uniform'});
% %title('PS Endorsement probability of Ambi in world state 2/3');
% %ylabel('Probability of Endorsement');
% %xlabel('Favored QUD');






%%Pragmatic Listener Graphs
% figure;
% bar(wPLm_s_2(:,1))
% ylim([0 1]);
% set(gca, 'XTickLabel', {'0', '1', '2', '3', 'Unif'});
% title('PL Marginal Probability of surface scope');
% ylabel('Probability of Surface Scope');
% xlabel('Favored World State (.7 to favored; .1 to others)');
% 
% figure;
% bar(sPLm_s_2(:,1))
% ylim([0 1]);
% set(gca, 'XTickLabel', {'.9', '.7', '.5', '.3', '.1'});
% title('PL Marginal Probability of surface scope');
% ylabel('Probability of Surface Scope');
% xlabel('Prior Probability of surface scope');
% 
% 
% figure;
% bar(qPLm_s_2(:,1))
% ylim([0 1]);
% set(gca, 'XTickLabel', {'many?', 'all?', 'none?', 'Unif'});
% title('PL Marginal Probability of surface scope');
% ylabel('Probability of Surface Scope');
% xlabel('Favored QUD (.8 to favored; .1 to others)');





