% Thanks to "StudentDave" who published the funny Quail chasing Ninja,
%   go see his tutorials : http://studentdavestutorials.weebly.com

%Linear kalman filter applied on Orbit Determination
function [nState, nSigma]=kf(isInit, pState, pSigma, dt, u, m, su, sm)

if isInit
    nState = [0;0;0; 0;0;0];
%     sPredi = su.*eye(3); % process noise: variability of acceleration (in ax, ay,az units)
%     nSigma = [(dt^2/2)*sPredi; dt*sPredi]*[(dt^2/2)*sPredi; dt*sPredi]'; % Es (process noise) converted into covariance matrix
    sPredi = [su su su]; % process noise: variability of acceleration (in ax, ay,az units)
    nSigma = [(dt^2/2)*sPredi dt*sPredi]'*[(dt^2/2)*sPredi dt*sPredi]; % Es (process noise) converted into covariance matrix
    return;
end

%% Define update equations (Coefficent matrices): A physics based model for where we expect the Quail to be [state transition (state + velocity)] + [input control (acceleration)]
A = [eye(3) dt.*eye(3); zeros(3) eye(3)] ; % state transition matrix: state prediction
B = [(dt.^2/2).*eye(3); dt.*eye(3)]; %input control matrix:  expected effect of the input accceleration on the state.
C = [eye(3), zeros(3)]; % measurement matrix: the expected measurement given the predicted state (likelihood)
% since we are only measuring position (too hard for the ninja to calculate speed), we set the velocity variable to zero.
% ==> this could be changed since we reconstruct the speed! (only with N=4)

%% define main variables
% u = [ax(1), ay(1), az(1)]; % define acceleration magnitude
% S= [0;0;0; 0;0;0]; % initized state -- it has two components: [position; velocity]
% S_estimate = S;  % state estimate of initial location estimation (what we are updating)
% SAccel = 1.*eye(3); % process noise: variability of acceleration (in ax, ay,az units)
% Znoise = 1.;  %measurement noise (in xa,ya,za units)
% varEz = Znoise^2.*ones(3);% Znoise converted into covariance matrix
% varEs = [(dt^2/2)*SAccel; dt*SAccel]*[(dt^2/2)*SAccel; dt*SAccel]'; % Es (process noise) converted into covariance matrix
% Sigma = varEs; % estimate of initial position variance (covariance matrix)

%% initize result variables
% Initialize for speed
% S_loc = []; % ACTUAL Quail flight path (norm)
% S_vel = []; % ACTUAL Quail velocity (norm)
% S_meas = []; % Quail path that the Ninja sees
% S_locMeas = []; % Quail path that the Ninja sees


%% simulate what the Ninja sees over time
% for t = 1:nt
%     % expected result
%     S= ([xa(t);ya(t);za(t);vx(t);vy(t);vz(t)]'*blkdiag(sr,sr,sr,sv,sv,sv))';
%     S_loc = [S_loc; norm(S(1:3))];
%     S_vel = [S_vel; norm(S(4:6))];
%     % measurements
%     z = [xm(t);ym(t);zm(t)];
%     S_meas = [S_meas; z'];
%     S_locMeas = [S_locMeas; norm(z).*sr];
% end

% figure(1);clf
% plot(tt, S_loc, '-r.'); hold on
% plot(tt, S_locMeas, '-k.');
% plot(tt, smooth(S_locMeas), '-g.');
% 
% figure(2);clf
% plot(tt, S_vel, '-b.')

%% Do kalman filtering
%initize estimation variables
% S_loc_estimate = []; % position estimate
% S_vel_estimate = []; % velocity estimate
% S= [0;0;0; 0;0;0];   % re-initized state
% Sigma_estimate = Sigma;
% for t = 2:nt
%     u = [ax(t), ay(t), az(t)]; % define acceleration magnitude
%     dt = (tt(nt)-tt(nt-1));

%     A = [eye(3), dt.*eye(3); zeros(3) eye(3)] ; % state transition matrix: state prediction
%     B = [(dt.^2/2).*eye(3); dt.*eye(3)]; %input control matrix:  expected effect of the input accceleration on the state.
%     sPredi = su.*eye(3); % process noise: variability of acceleration (in ax, ay,az units)
    sPredi = su.*[1.05 0.95 0.1]; % process noise: variability of acceleration (in ax, ay,az units)
    %varEs = [(dt^2/2)*sPredi; dt*sPredi]*[(dt^2/2)*sPredi; dt*sPredi]'; % Es (process noise) converted into covariance matrix
    varEs = [(dt^2/2)*sPredi dt*sPredi]'*[(dt^2/2)*sPredi dt*sPredi]; % Es (process noise) converted into covariance matrix
%     varEz = sm^2.*ones(3);% sm (std measurments) converted into covariance matrix
    varEz = sm^2.*[0.9;1;1.1]*[0.9 1 1.1];% sm (std measurments) converted into covariance matrix
    % Predict next state of the quail with the last state and predicted motion.
    nState = A * pState + B * u';
    nSigma = A * pSigma * A' + varEs;
    % predicted Ninja measurement covariance
    % Kalman Gain
    K = nSigma * C' * pinv( C*nSigma*C' + varEz);
    % Update the state estimate.
    nState = nState + K * (m(1:3) - C * nState);
    % update covariance estimation.
    nSigma =  (eye(6)-K*C)*nSigma;
%     S_loc_estimate = [S_loc_estimate; norm(S_estimate(1:3)).*sr];
%     S_vel_estimate = [S_vel_estimate; norm(S_estimate(4:6)).*sv];
% end



% %plot the evolution of the distributions
% figure(4);clf
% for T = 1:length(S_loc_estimate)
% clf
%     x = S_loc_estimate(T)-sr:.01:S_loc_estimate(T)+sr; % range on x axis
%      
%     %predicted next position
%     hold on
%     mu = predic_state(T); % mean
%     sigma = predic_var(T); % standard deviation
%     y = normpdf(x,mu,sigma); % pdf
%     y = y/(max(y));
%     hl = line(x,y,'Color','m'); % or use hold on and normal plot
%       
%     %data measured by the ninja
%     mu = S_loc_meas(T); % mean
%     sigma = NinjaVision_noise_mag; % standard deviation
%     y = normpdf(x,mu,sigma); % pdf
%     y = y/(max(y));
%     hl = line(x,y,'Color','k'); % or use hold on and normal plot
%    
%     %combined position estimate
%     mu = Q_loc_estimate(T); % mean
%     sigma = P_mag_estimate(T); % standard deviation
%     y = normpdf(x,mu,sigma); % pdf
%     y = y/(max(y));
%     hl = line(x,y, 'Color','g'); % or use hold on and normal plot
%     axis([Q_loc_estimate(T)-5 Q_loc_estimate(T)+5 0 1]);    
% 
%    
%     %actual position of the quail
%     plot(Q_loc(T));
%     ylim=get(gca,'ylim');
%     line([Q_loc(T);Q_loc(T)],ylim.','linewidth',2,'color','b');
%     legend('state predicted','measurement','state estimate','actual Quail position')
%     pause
% end
return;
