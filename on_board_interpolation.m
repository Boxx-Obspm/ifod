%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  V2.2 03-03-2016 (dd-mm-yyyy)
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
%CL=1
%
%
% The inputs are extracted and interpolated at 4 specific timesteps ii+[timeStep]
%
% I/
%     <ref_ephemerids>
%     ii       = timestep of the trajectory to start interpolating
%     timeStep = 1x3 integer vector, nb of indices for 3 additional points of the trajectory
%     <actual_ephemerids>
% O/
%     TimeList      = 4x1 double float vector giving the 4 times of measurement in Julian Day.
%     out_lat0      = 4x1 double float vector giving the interpolated latitude of Jupiter seen from the reference trajectory.
%     out_long0     = 4x1 double float vector giving the interpolated longitude of Jupiter seen from the reference trajectory.
%     out_distance0 = 4x1 double float vector giving the interpolated distance between BIRDY and Jupiter from the reference trajectory.
%     out_long1     = 4x1 double float vector giving the longitude of Jupiter seen from the actual trajectory at the 4 times of measurements.
%     out_lat1      = 4x1 double float vector giving the latitude of Jupiter seen from the actual trajectory at the 4 times of measurements.

function [TimeList, out_lat0, out_long0, out_distance0, out_lat1, out_long1] = ...
   on_board_interpolation (TimeList0,lat0,long0,distance0, ...
                           ii,timeStep, ...
                           TimeList1,lat1,long1)

%this part simulate data from the planet tracker.
TimeList=[TimeList1(ii);TimeList1(ii+timeStep(1));TimeList1(ii+timeStep(1)+timeStep(2));TimeList1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
out_lat1=[lat1(ii);lat1(ii+timeStep(1));lat1(ii+timeStep(1)+timeStep(2));lat1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
out_long1=[long1(ii);long1(ii+timeStep(1));long1(ii+timeStep(1)+timeStep(2));long1(ii+timeStep(1)+timeStep(2)+timeStep(3))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(1)));                                                                                    %
if (i==1)
i=2;
end                                                                                                                      %
lat0_1     =lat0(i-1)     +(TimeList(1)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_1    =long0(i-1)    +(TimeList(1)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_1=distance0(i-1)+(TimeList(1)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                                                                     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(2)));                                                                                    %
if (i==1)
i=2;
end                                                                                                                      %
lat0_2     =lat0(i-1)     +(TimeList(2)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_2    =long0(i-1)    +(TimeList(2)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_2=distance0(i-1)+(TimeList(2)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(3)));                                                                                    %
if (i==1) 
i=2;
end                                                                                                                      %
lat0_3     =lat0(i-1)     +(TimeList(3)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_3    =long0(i-1)    +(TimeList(3)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_3=distance0(i-1)+(TimeList(3)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(4)));                                                                                    %
if (i==1)
 i=2;
end                                                                                                                      %
lat0_4     =lat0(i-1)     +(TimeList(4)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_4    =long0(i-1)    +(TimeList(4)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_4=distance0(i-1)+(TimeList(4)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

out_lat0=[lat0_1;lat0_2;lat0_3;lat0_4];
out_long0=[long0_1;long0_2;long0_3;long0_4];
out_distance0=[distance0_1;distance0_2;distance0_3;distance0_4];


end