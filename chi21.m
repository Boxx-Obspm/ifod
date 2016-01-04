%%----------------HEADER---------------------------%%
%Author:          Tristan Mallet & Oussema SLEIMI
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program uses the output from 'Calculation_C_X_Y' in order to
%calculate the chi2
%
% 1. Input:
%     C    =  21x19 double Matrix that contains measures from both trakectory (reference and shifted)
%     Xexp =  19x1 double vector of unknows build by using data from both actual and reference trajectories
%     Y    =  21x1 double vector of knows values that contains measures from both trakectory (reference and shifted)
% 2. Outputs:
%     chi2= chi2 criteria applied on C,X and Y check technical note Nav-002 for more details.


function[chi2]= chi21(Xexp,C,Y) %% X 19 dimensions vector


chi2=norm(-Y+C*Xexp).^2;


end