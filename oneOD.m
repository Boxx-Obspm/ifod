%%----------------HEADER---------------------------%%
%Author:           Boris Segret
version = '3.4';
% Version & Date:
%                  V3.4 8-12-2016 (dd-mm-yyyy)
%                  - forked from ../ifod_eval/stat_extraction.m
%                  - Introduction of a 2-step Kalman Filter
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
%       oneOD;


% epochs(1) = TimeList1(ii) - 4.*dtConst/24 - dtKF/86400.;
% epochs(2) = epochs(1) + dtConst/24;
% epochs(3) = epochs(2) + dtConst/24;
% epochs(4) = epochs(3) + dtConst/24;
% epochs(5) = epochs(4) + dtConst/24;  
% 
% refState = [ interp1(TimeList0, coord0(:,1), epochs(3), 'linear'); ...
%            interp1(TimeList0, coord0(:,2), epochs(3), 'linear'); ...
%            interp1(TimeList0, coord0(:,3), epochs(3), 'linear'); ...
%            interp1(TimeList0, vel0(:,1),   epochs(3), 'linear'); ...
%            interp1(TimeList0, vel0(:,2),   epochs(3), 'linear'); ...
%            interp1(TimeList0, vel0(:,3),   epochs(3), 'linear') ];
% refLoc = [0;0;0];
% 
% for iKF=1:nKF

    % STEP 2) Successive epochs T1, T2, T3, T4, T5 are built to be separated by dtConst
%     epochs = epochs + dtKF/86400.;
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
    
    % STEP 3) Optical "observations" are built with noise (sigma_obs) for Ti
    
%     % -long1/-long0 avec les donnees reelles (bug!)
%     observd = extractObs(epochs, nbofBodies, NbLE1, TimeListE1, lat1, -long1);
%     predict = prepareObs(epochs, nbofBodies, NbLE0, TimeListE0, lat0, -long0, dist0);
%     % +long1/+long0 avec les donnees simulees (bug!)
% %     predict = prepareObs(epochs, nbofBodies, NbLE0, TimeListE0, lat0, long0, dist0);
% %     observd = extractObs(epochs, nbofBodies, NbLE1, TimeListE1, lat1, long1);
%     err_obs = normrnd(0., sigma_obs/3600., [nbCycle 2*Nobs]); % AGAIN ! (see stat_extract)
%     err_obs = [err_obs(:,1) err_obs(:, 2)./cosd(observd(1,1)) ...
%                err_obs(:,3) err_obs(:, 4)./cosd(observd(2,1)) ...
%                err_obs(:,5) err_obs(:, 6)./cosd(observd(3,1)) ...
%                err_obs(:,7) err_obs(:, 8)./cosd(observd(4,1)) ...
%                err_obs(:,9) err_obs(:,10)./cosd(observd(5,1)) ];

    % STEP 4) Analytical OD is run, the 3D-solution for T3 is kept, called M(T3)
    [X,A,B,elapsed_time] = computeSolution(epochs, measur, predic, algo);
%   il faut extraire le delta-acceleration de Xexp (pour l'instant fait ici)
%   plus tard il faudra l'extraire de refTrajectory
    Xexp = expectedOD (TimeList0, NbLE0, TimeListE0, dist0, coord0, vel0, ...
                     epochs, bodies, ...
                     TimeList1, NbLE1, TimeListE1, dist1,coord1,vel1);
    if ij == Nobs
        % STEP 1) KF initizing at epochs(1)
        % dimensionless approach
        isInit=true;
        fx = 1000.;  sx = 500./fx; % km (distance factor and measurement accuracy)
        fv = 1.;  sv = 0.0001/fv; % km/s (velocity factor and measurement accuracy)
        fa = 1E-7; sa = 0.00000001*max([norm(accEstimate) 0])./fa; % km/s^2 (acceleration factor and accuracy)
        ft = 3600.;  % in seconds (time factor)
%         pState=[(refLoc + X(7:9))./fx; ...
%                  refState(4:6)./fv; ...
%                  accEstimate./fa];
        pState=[(X(7:9))./fx; ...
                 (refState(4:6)-(refLoc-pRefLoc)./dtKF)./fv; ...
                 accEstimate./fa];
        pSigma=eye(9);
%         u=[0 0 0];
%         m=[0 0 0];
%         sigma_acc = 1E-8*sv./(sa*st); % in "sa" unit (dimensionless noise on model's acceleration)
%         sigma_dist= 200./sr; % in "sr" (dimensionless noise on measured observations)
%         [pState, pSigma] = kf(isInit, pState, pSigma, dtKF/st, u, m, sigma_acc, sigma_dist); % initialisations
%         [nState, nSigma] = kf(isInit, pState, eye(9), dtKF/ft, u, m, sigma_acc, sigma_dist); % initialisations
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
% end
% the returned X(7:9) is the last KF-solution based on measurement at t3
% the returned X(13:15) is the last predicted KF-solution at t5
X(7:9) = (pState(1:3)).*fx;

end
