%%----------------HEADER---------------------------%%
% Author:           Boris Segret
% Version & Date:
%                   V1.1 14-03-2016 (dd-mm-yyyy)
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
datapath='./inputs/';
data_extraction;

%data_plots_full(outputs);
data_plots_full;
