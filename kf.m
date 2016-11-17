%   go see his tutorials : http://home.wlu.edu/~levys/kalman_tutorial/ 

%Linear kalman filter applied on Orbit Determination
function [uX, uP, dK]=kf(isInit, eX, eP, dt, Z, sx,sv,sa)

% State-transition model:
A = [ eye(3)   dt.*eye(3) zeros(3) ; ...
      zeros(3) eye(3)     dt.*eye(3); ...
      zeros(3) zeros(3)   eye(3)];
% B = zeros(9);
Q = blkdiag(0.001*sx*eye(3), sv*eye(3), sa*eye(3)); % process noise: covariances du model (x,v,a)
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
uX = nX + K*(Z-C*nX);
uP = (eye(9)-K*C)*nP;
dK = det(K'*K);
return;
