%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V3.1 10-04-2016 (dd/mm/yyyy)
%                  - REMAINING ISSUE: temporary fix about the Longitudes in ECLIPTIC
%                    => must still be clarified in the general use
%                  - REMAINING ISSUE: the input must have exactly 5 columns (no tolerance for additional columns)
%                  - input format = VTS, i.e. dates in 2 columns: MJD+sec
%                  (former "reference_trajectory.m")
%CL=2
%Version & Date:
%                  from  V3 30-03-2016 Boris Segret
%                  until V2 11-09-2015 Tristan Mallet & Oussema Sleimi
%
%
% This program parses an input file for ephemerides into the requested arrays for ifod
%
% 1. Inputs:
%     fpath      = an ephemeride file of a foreground body as seen from a time-stamped trajectory
%
% 2. Outputs:
%     NbLines    = integer, Nb.of records
%     TimeSteps  = double float NbLines-vector, dates (decimal JD)
%     latitudes  = double float NbLines-vector, latitudes (deg) of the foreground body
%     longitudes = double float NbLines-vector, longitudes (deg) of the foreground body
%     distances  = double float NbLines-vector, distances (km) of the foreground body

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
%TimeSteps  = data(:,1); % former format (dates in JD)
TimeSteps  = 2400000.5+data(:,1)+data(:,2)./86400.; % VTS format: dates in 2 first columns (MJD integer, nb.of seconds in the day as float)
latitudes  = data(:,3);
longitudes = -data(:,4); % the "-" sign is requested to fix a temporary bug with Ecliptic longitudes into trigonometric longitudes
distances  = data(:,5);

end
