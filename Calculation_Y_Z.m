%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet & Oussema SLEIMI
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program uses the output from 'trajectoires_voisines' in order to
%calculate [Y]=[D]*[Z] (see NAV-002, equation (45))
%
% 1. Input:
%     lat0  = variable that gives the latitude of the astral body observed from the reference trajectory
%     long0 = variable that gives the longitude of the astral body observed from the reference trajectory
%     lat1  = variable that gives the latitude of the astral body observed from the shifted trajectory
%     long1 = variable that gives the longitude of the astral body observed from the shifted trajectory
%     D     = 
% 2. Outputs:
%     Y =  21x1 double vector of known values that contains measures from both trajectories (reference and actual)

function[Y]= Calculation_Y_Z(lat0,long0,lat1, long1,D)
%% On Board Data


l01=degtorad(lat0(1)); %latitude at the instant t1 (radian)
L01=degtorad(long0(1)); %longitude at the instant t1 (radian)
l02=degtorad(lat0(2));%latitude at the instant t2 (radian)
L02=degtorad(long0(2));%longitude at the instant t2 (radian)
l03=degtorad(lat0(3));%latitude at the instant t3 (radian)
L03=degtorad(long0(3));%longitude at the instant t3 (radian)
l04=degtorad(lat0(4));%latitude at the instant t4 (radian)
L04=degtorad(long0(4));%longitude at the instant t4 (radian)

%% Data measured by the planet tracker

l1=degtorad(lat1(1)); %latitude at the instant t1 (radian)
L1=degtorad(long1(1)); %longitude at the instant t1 (radian)
l2=degtorad(lat1(2));%latitude at the instant t2 (radian)
L2=degtorad(long1(2));%longitude at the instant t2 (radian)
l3=degtorad(lat1(3));%latitude at the instant t3 (radian)
L3=degtorad(long1(3));%longitude at the instant t3 (radian)
l4=degtorad(lat1(4));%latitude at the instant t4 (radian)
L4=degtorad(long1(4));%longitude at the instant t4 (radian)


%% Definition of Z and Y
dl1=l1-l01;   
dl2=l2-l02;
dl3=l3-l03;
dl4=l4-l04;

dL1=L1-L01;
dL2=L2-L02;
dL3=L3-L03;
dL4=L4-L04;


Z=[dL1;dl1;dL2;dl2;dL3;dl3;dL4;dl4];

Y=D*Z;
end