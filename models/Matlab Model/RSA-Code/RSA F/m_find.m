function [favs_endorse] = m_find(w_priors, s_priors, q_priors, m_u_ps, run_N)
%m_find(w_priors, s_priors, q_priors, m_u_ps, run_N).  This function searches the
%relevent matrices in the multi-dim run, and pulls out the prior for each
%run that was favored. In the case of scope, it will always pull the prior
%on inverse. run_N indicates which model run we are on the favs_endorse matrix will alwasy be as follows:
%favs_endorse = [w_prior, s_prior, q_prior, endorsement];

favs_endorse = [];
MAXw = max(w_priors(run_N,:));
world = find(w_priors(run_N,:) == MAXw);
if length(world) > 1
    favs_endorse(1) = 3;
else
    if world == 1
        favs_endorse(1) = 0;
    elseif world == 2
        favs_endorse(1) = 1;
    else
        favs_endorse(1) = 2;
    end
end

favs_endorse(2) = s_priors(run_N, 2);

MAXq = max(q_priors(run_N,:));
QUD = find(q_priors(run_N,:) == MAXq);
if length(QUD) > 1
    favs_endorse(3) = 3;
else
    if QUD == 1
        favs_endorse(3) = 1;
    elseif QUD == 2
        favs_endorse(3) = 2;
    else
        favs_endorse(3) = 0;
    end
end
    
favs_endorse(4) = m_u_ps(run_N);