%%----------------HEADER---------------------------%%
% Author:           Boris Segret
% Version & Date:
%                   V1.0 11-12-2017 (dd-mm-yyyy)
%                   - part of the IFOD debugging
%                   - called from various location of ifod_eval/stat_extraction and ifod/oneOD.m
%                   - stores the elementary results at KF level or MC cycle level
% CL=2
%	go see his tutorials : http://home.wlu.edu/~levys/kalman_tutorial/ 
%	Linear kalman filter applied on Orbit Determination

function [uX, uP, dK]=kf(isInit, update, eX, eP, dt, Z, sx,sv,sa)

% State-transition model:
A = [ eye(3)   dt.*eye(3) zeros(3) ; ...
      zeros(3) eye(3)     dt.*eye(3); ...
      zeros(3) zeros(3)   eye(3)];
% B = zeros(9);
% process noise spectral density: covariances of (x,v,a) model per unit of time
% Q = blkdiag(0.001*sx*eye(3), sv*eye(3), sa*eye(3));
% Forme ci-dessous est + credible (car prop.à dt) et se rattacherait au
% gradient d'accélération:
Q = blkdiag(0.5*sa*(dt^2)*eye(3), sa*dt*eye(3), sa*eye(3));
C = [eye(3) zeros(3,6)];
% R = blkdiag(sx.*eye(3), sv.eye(3), sa.*eye(3));
R = sx.*eye(3);

if isInit
    uX = eX;
    uP = eye(9);
    dG = 1;
    % [(dt^2/2)*sPredi dt*sPredi]'*[(dt^2/2)*sPredi dt*sPredi]; % Es (process noise) converted into covariance matrix
    return;
end

% prediction:
nX = A*eX;
nP = A*eP*A'+Q;
% update:
K  = nP * C' / ( C*nP*C' + R);
dK = det(K'*K);
if update
    uX = nX + K*(Z-C*nX);
    uP = (eye(9)-K*C)*nP;
else
    uX = nX;
    uP = nP;
end
return;
