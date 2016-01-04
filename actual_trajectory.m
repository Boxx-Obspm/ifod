 %%----------------HEADER---------------------------%%
%Authors:           Oussema Sleimi - Tristan Mallet
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program reads the input data.
%
% 1. Inputs:
%     'trajectory_name/trajectory_name_ephjup' : The actual trajectory we consider

% 2. Outputs:
%    
%     TimeList1    = nx1 double float vector giving the date corresponding at each point of the actual trajectory in Julian day.
%     lat1         = nx1 double float vector giving the latitude of Jupiter at each point of the actual trajectory in degree.
%     long1        = nx1 double float vector giving the longitude of Jupiter at each point of the actual trajectory in degree.
%     distance1    = nx1 double float vector giving the distance between BIRDY location and Jupiter at each point of the actual trajectory in km.
%     coordinates1 = nx3 double float matrix giving the coordinates x,y,z of BIRDY at each point of the actual trajectory in the ecliptic J2000 in km.
%     velocity1    = nx3 double float matrix giving the velocity vx,vy,vz of BIRDY  at each point of the actual trajectory in the ecliptic J2000 in km.

function [TimeList1,lat1,long1,distance1,coordinates1,velocity1]=actual_trajectory(trajectory_name,trajectory_name_ephjup)

%we get a path that Octave can follow to the file we need
%concatenation of strings to be able to edit the trajectory name
chemin1=strcat('./Inputs/Trajectories/',trajectory_name);
chemin2=strcat('./Inputs/Trajectories/',trajectory_name_ephjup);

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
data1_distance=dlmread(chemin1);
data1_latlong=dlmread(chemin2);
fclose(chemin1);
fclose(chemin2);

TimeList1=data1_latlong(:,1); 
lat1=data1_latlong(:,2); 
long1=data1_latlong(:,3); 
distance1=data1_latlong(:,4);
coordinates1=[data1_distance(:,2) data1_distance(:,3) data1_distance(:,4)];
velocity1=[data1_distance(:,5) data1_distance(:,6) data1_distance(:,7)];

end
