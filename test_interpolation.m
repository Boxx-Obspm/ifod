%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V2.1 05-02-2016 (dd-mm-yyyy)
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
%CL=1
%
% Inputs are extracted and interpolated at 4 specific timesteps ii+[timeStep], then
% the theoretical shift between the reference and the actual trajectory is output.
%
% 1. Input:
%     <ref_trajectory>
%     ii        = timestep of the trajectory to start interpolating
%     timeStep  = 1x3 integer vector, nb of indices for 3 additional points of the trajectory
%     <actual_trajectory>
% 2. Outputs:
%     dr        = 4x1 double float vector giving the difference between the distance to Jupiter of the actual and reference trajectory at 4 different times.
%     Dvectr    = 4x1 double float vector giving the difference between the corrdinates of the actual and reference trajectory at 4 different times.
%     Dvelocity = 4x1 double float vector giving the difference between the velocity of the actual and reference trajectory at 4 different times.

function [dr, Dvectr, Dvelocity] = ...
   test_interpolation(TimeList0,distance0,coordinates0,velocity0, ...
                      ii,timeStep, ...
                      TimeList1,distance1,coordinates1,velocity1)

TimeList         =[TimeList1(ii);TimeList1(ii+timeStep(1));TimeList1(ii+timeStep(1)+timeStep(2));TimeList1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
out_distance1    =[distance1(ii);distance1(ii+timeStep(1));distance1(ii+timeStep(1)+timeStep(2));distance1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
out_coordinates1 =[coordinates1(ii,:);coordinates1(ii+timeStep(1),:);coordinates1(ii+timeStep(1)+timeStep(2),:);coordinates1(ii+timeStep(1)+timeStep(2)+timeStep(3),:)];
out_velocity1    =[velocity1(ii,:);velocity1(ii+timeStep(1),:);velocity1(ii+timeStep(1)+timeStep(2),:);velocity1(ii+timeStep(1)+timeStep(2)+timeStep(3),:)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(1)));                                                                                                                        %
if (i==1)
i=2;
end                                                                                                                                                       %                                                  
distance0_1 =distance0(i-1)     +(TimeList(1)-TimeList0(i-1))*(distance0(i)-distance0(i-1))          /(TimeList0(i)-TimeList0(i-1));                     %
x0_1        =coordinates0(i-1,1)+(TimeList(1)-TimeList0(i-1))*(coordinates0(i,1)-coordinates0(i-1,1))/(TimeList0(i)-TimeList0(i-1));                     %
y0_1        =coordinates0(i-1,2)+(TimeList(1)-TimeList0(i-1))*(coordinates0(i,2)-coordinates0(i-1,2))/(TimeList0(i)-TimeList0(i-1));                     %
z0_1        =coordinates0(i-1,3)+(TimeList(1)-TimeList0(i-1))*(coordinates0(i,3)-coordinates0(i-1,3))/(TimeList0(i)-TimeList0(i-1));                     %
vx0_1       =velocity0(i-1,1)   +(TimeList(1)-TimeList0(i-1))*(velocity0(i,1)-velocity0(i-1,1))      /(TimeList0(i)-TimeList0(i-1));                     %
vy0_1       =velocity0(i-1,2)   +(TimeList(1)-TimeList0(i-1))*(velocity0(i,2)-velocity0(i-1,2))      /(TimeList0(i)-TimeList0(i-1));                     %
vz0_1       =velocity0(i-1,3)   +(TimeList(1)-TimeList0(i-1))*(velocity0(i,3)-velocity0(i-1,3))      /(TimeList0(i)-TimeList0(i-1));                     %                                                                                                                                                        
 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(2)));                                                                                                                        %
if (i==1)
i=2;
end                                                                                                                                                       %
distance0_2 =distance0(i-1)     +(TimeList(2)-TimeList0(i-1))*(distance0(i)-distance0(i-1))          /(TimeList0(i)-TimeList0(i-1));                     %
x0_2        =coordinates0(i-1,1)+(TimeList(2)-TimeList0(i-1))*(coordinates0(i,1)-coordinates0(i-1,1))/(TimeList0(i)-TimeList0(i-1));                     %
y0_2        =coordinates0(i-1,2)+(TimeList(2)-TimeList0(i-1))*(coordinates0(i,2)-coordinates0(i-1,2))/(TimeList0(i)-TimeList0(i-1));                     %
z0_2        =coordinates0(i-1,3)+(TimeList(2)-TimeList0(i-1))*(coordinates0(i,3)-coordinates0(i-1,3))/(TimeList0(i)-TimeList0(i-1));                     %
vx0_2       =velocity0(i-1,1)   +(TimeList(2)-TimeList0(i-1))*(velocity0(i,1)-velocity0(i-1,1))      /(TimeList0(i)-TimeList0(i-1));                     %
vy0_2       =velocity0(i-1,2)   +(TimeList(2)-TimeList0(i-1))*(velocity0(i,2)-velocity0(i-1,2))      /(TimeList0(i)-TimeList0(i-1));                     %
vz0_2       =velocity0(i-1,3)   +(TimeList(2)-TimeList0(i-1))*(velocity0(i,3)-velocity0(i-1,3))      /(TimeList0(i)-TimeList0(i-1));                     %
                                                                                                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(3)));                                                                                                                        %
if (i==1)
i=2;
end                                                                                                                                                          %
distance0_3 =distance0(i-1)     +(TimeList(3)-TimeList0(i-1))*(distance0(i)-distance0(i-1))          /(TimeList0(i)-TimeList0(i-1));                     %
x0_3        =coordinates0(i-1,1)+(TimeList(3)-TimeList0(i-1))*(coordinates0(i,1)-coordinates0(i-1,1))/(TimeList0(i)-TimeList0(i-1));                     %
y0_3        =coordinates0(i-1,2)+(TimeList(3)-TimeList0(i-1))*(coordinates0(i,2)-coordinates0(i-1,2))/(TimeList0(i)-TimeList0(i-1));                     %
z0_3        =coordinates0(i-1,3)+(TimeList(3)-TimeList0(i-1))*(coordinates0(i,3)-coordinates0(i-1,3))/(TimeList0(i)-TimeList0(i-1));                     %
vx0_3       =velocity0(i-1,1)   +(TimeList(3)-TimeList0(i-1))*(velocity0(i,1)-velocity0(i-1,1))      /(TimeList0(i)-TimeList0(i-1));                     %
vy0_3       =velocity0(i-1,2)   +(TimeList(3)-TimeList0(i-1))*(velocity0(i,2)-velocity0(i-1,2))      /(TimeList0(i)-TimeList0(i-1));                     %
vz0_3       =velocity0(i-1,3)   +(TimeList(3)-TimeList0(i-1))*(velocity0(i,3)-velocity0(i-1,3))      /(TimeList0(i)-TimeList0(i-1));                     %
                                                                                                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(4)));                                                                                                                        %
if (i==1)
i=2; 
end                                                                                                                                                         % 
distance0_4 =distance0(i-1)     +(TimeList(4)-TimeList0(i-1))*(distance0(i)     -distance0(i-1))     /(TimeList0(i)-TimeList0(i-1));                     %
x0_4        =coordinates0(i-1,1)+(TimeList(4)-TimeList0(i-1))*(coordinates0(i,1)-coordinates0(i-1,1))/(TimeList0(i)-TimeList0(i-1));                     %
y0_4        =coordinates0(i-1,2)+(TimeList(4)-TimeList0(i-1))*(coordinates0(i,2)-coordinates0(i-1,2))/(TimeList0(i)-TimeList0(i-1));                     %
z0_4        =coordinates0(i-1,3)+(TimeList(4)-TimeList0(i-1))*(coordinates0(i,3)-coordinates0(i-1,3))/(TimeList0(i)-TimeList0(i-1));                     %
vx0_4       =velocity0(i-1,1)   +(TimeList(4)-TimeList0(i-1))*(velocity0(i,1)   -velocity0(i-1,1))   /(TimeList0(i)-TimeList0(i-1));                     %
vy0_4       =velocity0(i-1,2)   +(TimeList(4)-TimeList0(i-1))*(velocity0(i,2)   -velocity0(i-1,2))   /(TimeList0(i)-TimeList0(i-1));                     %
vz0_4       =velocity0(i-1,3)   +(TimeList(4)-TimeList0(i-1))*(velocity0(i,3)   -velocity0(i-1,3))   /(TimeList0(i)-TimeList0(i-1));                     %
                                                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                                                                                                         

out_distance0=[distance0_1;distance0_2;distance0_3;distance0_4]; % distance0 is the interpolation at 4 different time of the reference trajectory of the distance between BIRDY and JUPITER. 
out_coordinates0=[x0_1 y0_1 z0_1;x0_2 y0_2 z0_2;x0_3 y0_3 z0_3;x0_4 y0_4 z0_4]; % coordinates0 is the interpolation at 4 different time of the reference trajectory of BIRDY's corrdinates.
out_velocity0=[vx0_1 vy0_1 vz0_1;vx0_2 vy0_2 vz0_2;vx0_3 vy0_3 vz0_3;vx0_4 vy0_4 vz0_4];% velocity0 is the interpolation at 4 different time of the reference trajectory of BIRDY's velocity. 

Dvectr = out_coordinates0 - out_coordinates1; 
Dvelocity = (out_velocity1 - out_velocity0)/1000;
dr = out_distance1 - out_distance0;

end