%%----------------HEADER---------------------------%%
% Author:           Boris Segret
% Version & Date:
%                   V1 14-03-2016 (dd-mm-yyyy)
% CL=1

clear;
codPath = '../ifod_eval';
%scnPath = './inputs/';
%scnFile = strcat(scnPath, 'scenario');

addpath(codPath);
datapath='./inputs/';
data_extraction;

%data_plots_full(outputs);
data_plots_full;
