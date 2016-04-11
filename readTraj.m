%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V3 30-03-2016 (dd/mm/yyyy)
%                  - new program from former reference_trajectory.m
%                  - input trajectory are expected in 8-column VTS format (dates in 2 columns: MJD+sec.)
%CL=1
%Version & Date:
%                  from  V3 30-03-2016 Boris Segret
%                  until V2 11-09-2015 Tristan Mallet & Oussema Sleimi
%
%
%This program reads the input data.
%
% 1. Inputs: a trajectory file
% 2. Outputs:
%     NbLines     = integer, Nb of records
%     TimeSteps   = nx1 double float vector giving the date corresponding at each point of the reference trajectory in Julian day.
%     coordinates = nx3 double float matrix giving the coordinates x,y,z of BIRDY at each point of the reference trajectory in the ecliptic J2000 in km.
%     velocities  = nx3 double float matrix giving the velocity vx,vy,vz of BIRDY  at each point of the reference trajectory in the ecliptic J2000 in km.

function [NbLines, TimeSteps, coordinates, velocities] = readTraj(fpath)

% read a trajectory file from the META_STOP tag
f1=fopen(fpath,'rt');
	l=' ';
	while 1
		l=fgetl(f1);
		if strfind(l,'META_STOP')>0
			break;
		end;
	end;
[data, nb] = fscanf(f1,'%f %f %f %f %f %f %f %f', [8 inf]);
%[data, nb] = fscanf(f1,'%f %f %f %f %f %f %f %f %f %f %f %f', [12 inf]); % anomalie: 12 colonnes au lieu de 7
data = data';
% alternative (plus tard): continuer la boucle sur le fichier d'entree et
% eliminer les colonnes en trop, plus flexible si colonnes additionnelles:
% [A, nb]=fscanf(f1,'%f %f %f %f %f %f %f %f %f %f %f %f', [12 1]);
% l=fgetl(f1);
% data = [data; A'];

fclose(f1);

NbLines = size(data,1);
%TimeSteps = data(:,1); % this variable contains the date (in Julian day) for each point of the reference trajectory.
TimeSteps = 2400000.5+data(:,1)+data(:,2)./86400.; % date in decimal Julian Day
coordinates = [data(:,3) data(:,4) data(:,5)]; % those variables contain the coordinates of BIRDY at each point of the reference trajectory (in km in the J2000 ecliptic).
velocities  = [data(:,6) data(:,7) data(:,8)]; % those variables contain the velocity of BIRDY at each point of the reference trajectory (in km/s in the J2000 ecliptic).

end