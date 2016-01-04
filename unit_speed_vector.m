%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet
%Version & Date:   V1 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
% This function gives the velocity vector with a norm equal to 1
% It permits to quickly access the vector velocity1 without taking care of its norm.
%
% 1. Inputs:
%    ii : first point of the trajectory that will be used to solve the problem
%    velocity1 : actual velocity on each point of the trajectory
%
% 2. Outputs:
%   vel1 : unit speed vector of velocity1

function[vel1]=unit_speed_vector(ii,velocity1)
	vel1=[velocity1(ii,1);velocity1(ii,2);velocity1(ii,3)]/norm(velocity1(ii,1:3));
end