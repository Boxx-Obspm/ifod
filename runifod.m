%%----------------HEADER---------------------------%%
% Author:           Boris Segret
% Version & Date:
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
% CL=1

clear;
codPath = '../ifod_eval';
addpath(codPath);
runifod_scenario; % can be easily modfied from a Bash script

%-----------------------------------------
Nobs = 5;

% stat_extraction : MC series per time step, inputs in runifod_MCdrivers.m
% - sigma_obs (arcsecs) : accuracy of the optical measurements
% - dtConst (hours) : time-sampling between measurements
% - pfix : postfix for the results
runifod_MCdrivers; % can be easily modfied from a Bash script
stat_extraction;   % located in codPath
%-----------------------------------------
