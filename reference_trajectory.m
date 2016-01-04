%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet & Oussema Sleimi
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program reads the input data.
%
% 1. Inputs: written in the code
%     the reference trajectory file

% 2. Outputs:
%     TimeList0    = nx1 double float vector giving the date corresponding at each point of the reference trajectory in Julian day.
%     lat0         = nx1 double float vector giving the latitude of Jupiter at each point of the reference trajectory in degree.
%     long0        = nx1 double float vector giving the longitude of Jupiter at each point of the reference trajectory in degree.
%     distance0    = nx1 double float vector giving the distance between BIRDY location and Jupiter at each point of the reference trajectory in km.
%     coordinates0 = nx3 double float matrix giving the coordinates x,y,z of BIRDY at each point of the reference trajectory in the ecliptic J2000 in km.
%     velocity0    = nx3 double float matrix giving the velocity vx,vy,vz of BIRDY  at each point of the reference trajectory in the ecliptic J2000 in km.

%function [TimeList0,lat0,long0,distance0,coordinates0,velocity0]=reference_trajectory()

%we get a path that Octave can follow to the file we need
chemin1='./Inputs/Trajectories/T0/58122+SOI_v6.4_jdv000_312.xyzv'; 
chemin2='./Inputs/Trajectories/T0/58122+SOI_v6.4_jdv000_312_ephjup.xyzv';

%To read the trajectory file from the META_STOP tag
chemin1=fopen(chemin1,'rt');
	l=' ';
	while 1
		l=fgetl(chemin1);
		if strfind(l,'META_STOP')>0
			break;
		end;
	end;
chemin2=fopen(chemin2,'rt');
	l=' ';
	while 1
		l=fgetl(chemin2);
		if strfind(l,'META_STOP')>0
			break;
		end;
	end;
	
data0_distance=dlmread(chemin1);
data0_latlong=dlmread(chemin2);
fclose(chemin1);
fclose(chemin2);

TimeList0=data0_latlong(:,1); % this variable contains the date (in Julian day) for each point of the reference trajectory.
lat0=data0_latlong(:,2); % this variable contains the latitude of the observed planet (in  degree)for each point of the reference trajectory.
long0=data0_latlong(:,3); % this variable contains the longitude of the observed planet (in  degree) for each point of the reference trajectory.
distance0=data0_latlong(:,4); % this variable contains the distance between for each point of the reference trajectory and the observed planet (in km).

coordinates0=[data0_distance(:,2) data0_distance(:,3) data0_distance(:,4)];  % those variables contain the coordinates of BIRDY at each point of the reference trajectory (in km in the J2000 ecliptic).
velocity0=[data0_distance(:,5) data0_distance(:,6) data0_distance(:,7)]; % those variables contain the velocity of BIRDY at each point of the reference trajectory (in km in the J2000 ecliptic).

%end