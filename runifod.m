%%----------------HEADER---------------------------%%
% Author:           Boris Segret
% Version & Date:
%                   V1.3 01-05-2016 (dd-mm-yyyy)
%                   - Monte-Carlo analysis to assess algorithm sensitivity (extraction & plots)
%                   - Time-sampling and Observation accuracy as input for batch running
%                   V1.2 26-04-2016 Boris Segret
%                   - very basic run of the ifod, to be improved later
%                   - it assumes "./inputs/scenario" file provides evrything necessary
%                   - it assumes "../ifod_eval/data_extraction.m" iterates for all trajectory points
%                   - it runs standard plots for quick analyses of the results
% CL=2

clear;
codPath = '../ifod_eval';
%scnPath = './inputs/';
%scnFile = strcat(scnPath, 'scenario');

addpath(codPath);
runifod_scenario; % can be easily modfied from a Bash script

% data_extraction : single computation per time step
%data_extraction; 

%-----------------------------------------
Nobs = 4;
% unaccuracy on the optical observation (likely related to time-sampling)
% unaccuracy on the photocenter: not included yet
% unaccuracy on the time: not included yet

% stat_extraction : series of computations per time step
% sigma_obs (arcsecs) : accuracy of the optical measurements
% dtConst (hours) : time-sampling between measurements
runifod_MCdrivers; % can be easily modfied from a Bash script
stat_extraction;
%-----------------------------------------

%data_plots_full(outputs);
%data_plots_full;
