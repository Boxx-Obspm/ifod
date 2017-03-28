%%----------------HEADER---------------------------%%
%Author:           Boris Segret
version = '3.7';
% Version & Date:
%                  V3.7 23-03-2017 (dd-mm-yyyy)
%                  - debug in the KF control
%                  V3.6 27-01-2017 (dd-mm-yyyy)
%                  - minor changes and comments
%                  V3.5 24-01-2017 (dd-mm-yyyy)
%                  - forked from ../ifod_eval/stat_extraction.m
%                  - Introduction of a 2-step Kalman Filter
%                  - dimensionless factors in oneOD_factors.m
%                  V3.2 was in CL=2
% CL=2 (v3.6)

% The program simulates a full on-board determination process at a given epoch.
% 1) The KF is initized at the epoch NOW-(2*dtConst)-(nKF*dtKF)
% 2) Successive epochs T1, T2, T3, T4, T5 are built to be separated by dtConst
% 3) Optical "observations" are built with noise (sigma_obs) for Ti
% 4) Analytical OD is run, the 3D-solution for T3 is kept, called M(T3)
% 5) M(T3) is injected in the KF as measurement, KF provides a new estimate E(T3)
% 6) T5 is incremented by dt_KF
% 7) steps 2) to 6) are iterated nKF times
% 8) the last E(T3) and E(NOW) are returned

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
% F/ oneOD_factors.m is called and must be present in the same directory

%-----------------------------------------

% in the approach below we must keep T and dt with the same number of lines
% (due to slctEpochs ===> but we wa nt to suppress slctEpochs)
% T=[floor(TimeList1(1)-2400000.5), 0; floor(TimeList1(ii_MAX)-2400000.5)+1, 0];
% dtConst in hours
% dt=dtConst.*[ones(1,Nobs-1); zeros(1,Nobs-1)];
% epochs  = slctEpochs(Nobs, TimeList1(ii), T, dt);

% cumul_CPU = 0.; % initized in stat_extraction.m
for ij = 1:nKF
%   epochs(1:Nobs)   = obstime(ik+ij-Nobs+1:ik+ij);
%   measur(1:Nobs,:) = measurd(ij-Nobs+1:ij,:);
%   predic(1:Nobs,:) = predict(ij-Nobs+1:ij,:);
%   bodies(1:Nobs)   = obsbody(ij-Nobs+1:ij);
  epochs(1:Nobs)   = obstime(1+Nobs*(ij-1):Nobs*ij);
  measur(1:Nobs,:) = measurd(1+Nobs*(ij-1):Nobs*ij,:);
  predic(1:Nobs,:) = predict(1+Nobs*(ij-1):Nobs*ij,:);
  bodies(1:Nobs)   = obsbody(1+Nobs*(ij-1):Nobs*ij);
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

  if ij == 1
%         isInit=true;
        % dimensionless approach
        oneOD_factors; % fx, fv, fa, ft
%         pState=[(X(7:9))./fx; ...
%                  (refState(4:6)-(refLoc-pRefLoc)./dtKF)./fv; ...
%                  accEstimate./fa]; <==== gros doute là-dessus!!!
        pState=[(X(7:9))./fx; ...
                 refState(4:6)./fv; ...
                 accEstimate./fa];
        pSigma=eye(9);
%         isInit=false;
  end
%   fprintf('Inversion: %5.2f ms, expectedOD: %5.2f ms, ', elapsed_time, (tcf-tci)*1000.);
%     u = Xexp(24:26)'./sa; % dimensionless delta-acceleration (unit: in sa)
%     Z = (refLoc + X(7:9))./fx;       % position wrt refState (unit: in fx)
  tci= toc;
  Z = X(7:9)./fx;       % position wrt refState (unit: in fx)
%     [nState, nSigma] = kf(isInit, pState, pSigma, dtKF/st, u, m, sigma_acc, sigma_dist);
% --------> function [uX, uP]=kf(isInit, eX, eP, dt, Z, sx,sv,sa)
  update = true;
%   [nState, nSigma, Kg] = kf(isInit, update, pState, pSigma, Nobs.*dtKF./ft, Z, sx,sv,sa);
  [nState, nSigma, Kg] = kf(update, pState, pSigma, Nobs.*dtKF./ft, Z, sx,sv,sa);
  pState = nState; % new state vector
  pSigma = nSigma; % new covariance matrix
  tcf = (toc-tci)*1000.;

  iDebug=2; debug; % Xexp, X (3D-OD result) and nState (KF result) are stored
  % X(floor(0.5+Nobs/2)*3-2:floor(0.5+Nobs/2)*3) = (nState(1:3)).*fx;
  % if uncommented, the returned X(7:9) is the last KF-solution based on measurement at t3

  if ij == nKF
      update = false;
      dt = 86400.*(epochs(5)-epochs(3));
      [nState, nSigma, Kg] = kf(update, pState, pSigma, dt./ft, Z, sx,sv,sa);
      iDebug=3; debug;
      X(Nobs*3-2:Nobs*3) = (nState(1:3)).*fx;
      % the returned X(13:15) is the last predicted KF-solution at t5
  end
  cumul_CPU = cumul_CPU + elapsed_time + tcf;

end
