%%----------------HEADER---------------------------%%
%Author:           Oussema SLEIMI & Tristan Mallet
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program interpolates data as it runs on board.
%
% 1. Input:
%     ii           = Point of the trajectory that will be used to solve the problem.
%    'trajectory_name/trajectory_name_ephjup' : The actual trajectory we consider
%   timeStep : the various sampling we consider to take the pictures

% 2. Outputs:
%    
%     TimeList  = 4x1 double float vector giving the 4 times of measurement in Julian Day.
%     lat0      = 4x1 double float vector giving the interpolated latitude of Jupiter seen from the reference trajectory.
%     long0     = 4x1 double float vector giving the interpolated longitude of Jupiter seen from the reference trajectory.
%     distance0 = 4x1 double float vector giving the interpolated distance between BIRDY and Jupiter from the reference trajectory.
%     long1     = 4x1 double float vector giving the longitude of Jupiter seen from the actual trajectory at the 4 times of measurements.
%     lat1      = 4x1 double float vector giving the latitude of Jupiter seen from the actual trajectory at the 4 times of measurements.

function[TimeList,lat0,long0,distance0,lat1,long1]=on_board_interpolation(ii,timeStep,trajectory_name,trajectory_name_ephjup)

%we get the data from the inputs.
[TimeList0,lat0,long0,distance0,~,~]=reference_trajectory(); 
[TimeList1,lat1,long1,~,~,~]=actual_trajectory(trajectory_name,trajectory_name_ephjup);



%this part simulate data from the planet tracker.
TimeList=[TimeList1(ii);TimeList1(ii+timeStep(1));TimeList1(ii+timeStep(1)+timeStep(2));TimeList1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
lat1=[lat1(ii);lat1(ii+timeStep(1));lat1(ii+timeStep(1)+timeStep(2));lat1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
long1=[long1(ii);long1(ii+timeStep(1));long1(ii+timeStep(1)+timeStep(2));long1(ii+timeStep(1)+timeStep(2)+timeStep(3))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(1)));                                                                                    %
if (i==1)
i=2;
endif                                                                                                                      %
lat0_1     =lat0(i-1)     +(TimeList(1)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_1    =long0(i-1)    +(TimeList(1)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_1=distance0(i-1)+(TimeList(1)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                                                                     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(2)));                                                                                    %
if (i==1)
i=2;
endif                                                                                                                      %
lat0_2     =lat0(i-1)     +(TimeList(2)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_2    =long0(i-1)    +(TimeList(2)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_2=distance0(i-1)+(TimeList(2)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(3)));                                                                                    %
if (i==1) 
i=2;
endif                                                                                                                      %
lat0_3     =lat0(i-1)     +(TimeList(3)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_3    =long0(i-1)    +(TimeList(3)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_3=distance0(i-1)+(TimeList(3)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERPOLATION #4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1+sum((TimeList0<TimeList(4)));                                                                                    %
if (i==1)
 i=2;
 endif                                                                                                                      %
lat0_4     =lat0(i-1)     +(TimeList(4)-TimeList0(i-1))*(lat0(i)-lat0(i-1))          /(TimeList0(i)-TimeList0(i-1)); %
long0_4    =long0(i-1)    +(TimeList(4)-TimeList0(i-1))*(long0(i)-long0(i-1))        /(TimeList0(i)-TimeList0(i-1)); %
distance0_4=distance0(i-1)+(TimeList(4)-TimeList0(i-1))*(distance0(i)-distance0(i-1))/(TimeList0(i)-TimeList0(i-1)); %
                                                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lat0=[lat0_1;lat0_2;lat0_3;lat0_4];
long0=[long0_1;long0_2;long0_3;long0_4];
distance0=[distance0_1;distance0_2;distance0_3;distance0_4];


end