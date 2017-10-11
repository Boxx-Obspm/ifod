%%----------------HEADER---------------------------%%
% Author:           Boris Segret
% Version & Date:
%                   V1.6 27-03-2017 (dd-mm-yyyy)
%                   - integrated "test" scenario
%                   - key parameters gathered in this introduction runfile
%                   V1.5 15-01-2017 (dd-mm-yyyy)
%                   - all driven parameters gathered here (tests & real jobs)
%                   V1.4 06-08-2016 (dd-mm-yyyy)
%                   - Adaptation to N=5 measurements
%                   V1.3 01-05-2016 (dd-mm-yyyy)
%                   - Monte-Carlo analysis to assess algorithm sensitivity (extraction & plots)
%                   - Time-sampling and Observation accuracy as input for batch running
%                   V1.2 26-04-2016 Boris Segret
%                   - very basic run of the ifod, to be improved later
%                   - it assumes "./inputs/scenario" file provides evrything necessary
%                   - it assumes "../ifod_eval/data_extraction.m" iterates for all trajectory points
%                   - it runs standard plots for quick analyses of the results
% CL=2 (v1.6)

% F/ runifod_MCdrivers.m, runifod_scenario.m are called if non-test run

clear;
tests = false;
% tests = true;
runInOctave = false;
Nobs = 5;

% TEST / DEBUG
if (tests)
    datapath='../ifod_tests/'; % runifod_scenario.m
    fscenario='Y0_v4';      % runifod_scenario.m
    scnRealistic = false;      % runifod_scenario.m
    sigma_obs = 0.1;         % runifod_MCdrivers.m
    nKF = 8*24;                  % runifod_MCdrivers.m
    dtKF = 3600./5.;        % in seconds (measurement of 5 planets per hour)
    nbCycles= 10;               % runifod_MCdrivers.m
    pfix=['_01as,' int2str(nbCycles) 'MCx' int2str(nKF) 'KF,tests'];   % runifod_MCdrivers.m
else
    runifod_scenario; % can be easily modfied from a Bash script
    % stat_extraction : MC series per time step, inputs in runifod_MCdrivers.m
    % - sigma_obs (arcsecs) : accuracy of the optical measurements
    % - dtConst (hours) : time-sampling between measurements
    % - pfix : postfix for the results
    runifod_MCdrivers; % can be easily modfied from a Bash script
end

%-----------------------------------------

codPath = '../ifod_eval';
addpath(codPath);
stat_extraction;   % located in codPath
%-----------------------------------------
