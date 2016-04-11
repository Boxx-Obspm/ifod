%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V3 30-03-2016 (dd/mm/yyyy)
%                  - new program from former reference_trajectory.m
%                  - longitudes in ECLIPTIC (input) are converted into long trigo (output)
%                  - input format is VTS (dates in 2 columns: MJD+sec.)
%CL=1
%Version & Date:
%                  from  V3 30-03-2016 Boris Segret
%                  until V2 11-09-2015 Tristan Mallet & Oussema Sleimi
%
%
%This program reads the input data.
%
% 1. Inputs: an ephemeride file
% 2. Outputs:
%     NbLines    = integer, Nb.of records
%     TimeSteps  = nx1 double float vector, dates in decimal Julian day.
%     latitudes  = nx1 double float vector giving the latitude of Jupiter at each point of the reference trajectory in degree.
%     longitudes = nx1 double float vector giving the longitude of Jupiter at each point of the reference trajectory in degree.
%     distances  = nx1 double float vector giving the distance between BIRDY location and Jupiter at each point of the reference trajectory in km.

function [NbLines, TimeSteps, latitudes, longitudes, distances] = readEphem(fpath)

% read an ephemeride file from the META_STOP tag
f2=fopen(fpath,'rt');
	l=' ';
	while 1
		l=fgetl(f2);
		if strfind(l,'META_STOP')>0
			break;
		end;
	end;
[data, nb] = fscanf(f2,'%f %f %f %f %f', [5 inf]);
data = data';
fclose(f2);

NbLines    = size(data,1);
%TimeSteps  = data(:,1); % this variable contains the date (in Julian day) for each point of the reference trajectory.
TimeSteps  = 2400000.5+data(:,1)+data(:,2)./86400.; % this variable contains the date (in Julian day) for each point of the reference trajectory.
latitudes  = data(:,3); % this variable contains the latitude of the observed planet (in  degree)for each point of the reference trajectory.
% the "-" sign is requested to convert Ecliptic longitudes into trigonometric longitudes
longitudes = -data(:,4); % this variable contains the longitude of the observed planet (in  degree) for each point of the reference trajectory.
distances  = data(:,5); % this variable contains the distance between for each point of the reference trajectory and the observed planet (in km).

end