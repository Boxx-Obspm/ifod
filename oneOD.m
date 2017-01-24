%%----------------HEADER---------------------------%%
%Author:           Boris Segret
version = '3.5';
% Version & Date:
%                  V3.5 24-01-2017 (dd-mm-yyyy)
%                  - forked from ../ifod_eval/stat_extraction.m
%                  - Introduction of a 2-step Kalman Filter
%                  - dimensionless factors in oneOD_factors.m
% CL=2 (v3.2)
%
%
% The program simulates a full on-board determination process at a given epoch.
% 1) The KF is initized at the epoch T5-(2*dtConst)-(nKF*dtKF)
% 2) Successive epochs T1, T2, T3, T4, T5 are built to be separated by dtConst
% 3) Optical "observations" are built with noise (sigma_obs) for Ti
% 4) Analytical OD is run, the 3D-solution for T3 is kept, called M(T3)
% 5) M(T3) is injected in the KF as measurement, KF provides a new estimate E(T3)
% 6) T5 is incremented by dt_KF
% 7) steps 2) to 6) are iterated nKF times and last E(T3) is returned

% The reference trajectory with its ephemerides are known, the observations are
% built in a subroutine that accesses the actual trajectory, not known by
% IFOD, however accessible in the workspace for speed and debug concerns.
%
% I/
%    <scenario> scenario file (in VTS format) path must be given in datapath below
%               see User Manual to set the scenario file
%    datapath : path for the "scenario" file, it *must* be provided in the workspace
% O/
%    <results> comparison between computed and expected results (VTS format,
%              prefixed as requested in <scenario>)

%-----------------------------------------

% in the approach below we must keep T and dt with the same number of lines
% (due to slctEpochs ===> but we wa nt to suppress slctEpochs)
% T=[floor(TimeList1(1)-2400000.5), 0; floor(TimeList1(ii_MAX)-2400000.5)+1, 0];
% dtConst in hours
% dt=dtConst.*[ones(1,Nobs-1); zeros(1,Nobs-1)];
% epochs  = slctEpochs(Nobs, TimeList1(ii), T, dt);

for ij = Nobs:nKF
  epochs(1:Nobs)   = obstime(ik+ij-Nobs+1:ik+ij);
  measur(1:Nobs,:) = measurd(ij-Nobs+1:ij,:);
  predic(1:Nobs,:) = predict(ij-Nobs+1:ij,:);
  bodies(1:Nobs)   = obsbody(ij-Nobs+1:ij);
  pRefLoc = refLoc;
  refLoc = - refState(1:3) + [ ...
    interp1(TimeList0, coord0(:,1), epochs(3), 'linear'); ...
    interp1(TimeList0, coord0(:,2), epochs(3), 'linear'); ...
    interp1(TimeList0, coord0(:,3), epochs(3), 'linear')];
  accEstimate = ([interp1(TimeList0, vel0(:,1),   epochs(3), 'linear'); ...
                interp1(TimeList0, vel0(:,2),   epochs(3), 'linear'); ...
                interp1(TimeList0, vel0(:,3),   epochs(3), 'linear')] ...
              -[interp1(TimeList0, vel0(:,1),   epochs(2), 'linear'); ...
                interp1(TimeList0, vel0(:,2),   epochs(2), 'linear'); ...
                interp1(TimeList0, vel0(:,3),   epochs(2), 'linear')] ...
               )./((epochs(3)-epochs(2))*86400.); % km/s^-2
    
  [X,A,B,elapsed_time] = computeSolution(epochs, measur, predic, algo);
%   il faut extraire le delta-acceleration de Xexp (pour l'instant fait ici)
%   plus tard il faudra l'extraire de refTrajectory
  Xexp = expectedOD (TimeList0, NbLE0, TimeListE0, dist0, coord0, vel0, ...
                     epochs, bodies, ...
                     TimeList1, NbLE1, TimeListE1, dist1,coord1,vel1);
  if ij == Nobs
        isInit=true;
        % dimensionless approach
        oneOD_factors; % fx, fv, fa, ft
        pState=[(X(7:9))./fx; ...
                 (refState(4:6)-(refLoc-pRefLoc)./dtKF)./fv; ...
                 accEstimate./fa];
        pSigma=eye(9);
        isInit=false;
  end
%     u = Xexp(24:26)'./sa; % dimensionless delta-acceleration (unit: in sa)
%     Z = (refLoc + X(7:9))./fx;       % position wrt refState (unit: in fx)
  Z = X(7:9)./fx;       % position wrt refState (unit: in fx)
%     [nState, nSigma] = kf(isInit, pState, pSigma, dtKF/st, u, m, sigma_acc, sigma_dist);
% --------> function [uX, uP]=kf(isInit, eX, eP, dt, Z, sx,sv,sa)
  update = true;
  [nState, nSigma, Kg] = kf(isInit, update, pState, pSigma, dtKF/ft, Z, sx,sv,sa);
  iDebug=2; debug;
  pState = nState; % new state vector
  pSigma = nSigma; % new covariance matrix
  if ij == nKF
      update = false; dt = epochs(5)-epochs(3);
      [nState, nSigma, Kg] = kf(isInit, update, pState, pSigma, dt/ft, Z, sx,sv,sa);
      iDebug=3; debug;
      X(13:15) = (nState(1:3)).*fx;
  end
% the returned X(7:9) is the last KF-solution based on measurement at t3
% the returned X(13:15) is the last predicted KF-solution at t5
X(7:9) = (pState(1:3)).*fx;

end
