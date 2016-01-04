%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet
%Version & Date:   V1 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
% This function gives the timeStep vector which provides, for each ii, a sampling for the star tracker.
%
% 1. Inputs:
%    ii : first date we take to solve the problem
%    T is a vector which contains the dates when we want to change the sampling of the mesures
%    dt is a length(T)-1*3 matrix. It contains the different values of sampling we want.
%     'trajectory_name/trajectory_name_ephjup' : The actual trajectory we consider
%
% 2. Outputs:
%   timeStep : 1*3 vector which browses the rows of dt according to the value of T


	
function [timeStep]=time_step(ii,T,dt,trajectory_name,trajectory_name_ephjup)
[TimeList1,lat1,long1,distance1,coordinates1,velocity1]=actual_trajectory(trajectory_name,trajectory_name_ephjup);
MJD_0=2400000.5;
SEC_0=86400;
T=T(:,1)+MJD_0+T(:,2)/SEC_0;
	for k = 1:length(T)-1 % The size of T (number of sampling changes can be edited).
		if (TimeList1(ii)<T(1))
			timeStep=dt(1,:)/SEC_0*3600;
			break;
		elseif (TimeList1(ii)<T(k+1) && TimeList1(ii)>=T(k))
			timeStep=dt(k,:)/SEC_0*3600;
			break;
		else timeStep=dt(k+1,:)/SEC_0*3600;
		endif
	
	endfor
	timeStep(1)=sum((TimeList1<=TimeList1(ii)+timeStep(1)))-ii;
	timeStep(2)=sum((TimeList1<=TimeList1(ii+timeStep(1))+timeStep(2)))-ii-timeStep(1);	timeStep(3)=sum((TimeList1<=TimeList1(ii+timeStep(1)+timeStep(2))+timeStep(3)))-ii-timeStep(1)-timeStep(2);
end