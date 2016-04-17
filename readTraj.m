%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V3.1 10-04-2016 (dd/mm/yyyy)
%                  - input trajectory are expected in 8-column VTS format (dates in 2 columns: MJD+sec.)
%                  - REMAINING ISSUE: the input must have exactly 8 columns (no tolerance for additional columns)
%                  (former "reference_trajectory.m")
%CL=2
%Version & Date:
%                  from  V3 30-03-2016 Boris Segret
%                  until V2 11-09-2015 Tristan Mallet & Oussema Sleimi
%
% This program parses an input file for a trajectory into the requested arrays for ifod
%
% 1. Inputs:
%     fpath       = trajectory file in VTS format
%
% 2. Outputs:
%     NbLines     = integer, Nb of records
%     TimeSteps   = double float NbLines-vector, dates (decimal JD)
%     coordinates = double float NbLines-vector, coordinates x,y,z (km)
%     velocities  = double float NbLines-vector, velocity vx,vy,vz (km/s)

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
data = data';
% alternative (plus tard): continuer la boucle sur le fichier d'entree et eliminer
% les colonnes en trop, plus flexible si colonnes additionnelles (mais plus lent):
% [A, nb]=fscanf(f1,'%f %f %f %f %f %f %f %f %f %f %f %f', [12 1]);
% l=fgetl(f1);
% data = [data; A'];

fclose(f1);

NbLines = size(data,1);
TimeSteps = 2400000.5+data(:,1)+data(:,2)./86400.; % dates in decimal JD
coordinates = [data(:,3) data(:,4) data(:,5)];
velocities  = [data(:,6) data(:,7) data(:,8)];

end
