%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  V2.1 10-03-2016 (dd-mm-yyyy)
%                  - few clarifications
%Version & Date:
%                  until V2   11-09-2015, Tristan Mallet & Oussema SLEIMI
%CL=1
%
% This program computes the chi2 value for X, C, Y matrices
%
% 1. Input:
%     C =  21x19 double Matrix that contains measures from both trakectory (reference and shifted)
%     X =  19x1 double vector of unknowns build by using data from both actual and reference trajectories
%     Y =  21x1 double vector of known values that contains measures from both trakectory (reference and shifted)
% 2. Outputs:
%     chi2 = double scalar, criteria applied on C, X and Y check technical note Nav-002 for more details.


function [val]= chi2(X,C,Y) %% X 19 dimensions vector

val = norm(-Y+C*Xexp).^2;

end
