%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   
%                  V3.2 02-05-2017 (dd/mm/yyyy)
%                  - input trajectory files can have either 5, 8 or 11 columns
%CL=2 (V3.1)
%Version & Date:
%                  V3.1 10-04-2016 (dd/mm/yyyy)
%                  - input trajectory are expected in 8-column VTS format (dates in 2 columns: MJD+sec.)
%                  - REMAINING ISSUE: the input must have exactly 8 columns (no tolerance for additional columns)
%                  (former "reference_trajectory.m")
%                  from  V3 30-03-2016 Boris Segret
%                  until V2 11-09-2015 Tristan Mallet & Oussema Sleimi
%
% This program parses an input file for a trajectory into the requested arrays for ifod
%
% 1. Inputs:
%     fpath       = trajectory file in 5-, 8- or 11-column VTS format
%
% 2. Outputs:
%     NbLines     = integer, Nb of records
%     TimeSteps   = double float NbLines-vector, dates (decimal JD)
%     coordinates = double float NbLines-vector, coordinates x,y,z (km)
%     velocities  = double float NbLines-vector, velocity vx,vy,vz (km/s)
%     gravitation = double float NbLines-vector, gravitational field at x,y,z (units tbd)

function [NbLines, TimeSteps, dataBack] = readTraj(fpath)


% read a trajectory file after the META_STOP tag
f1=fopen(fpath,'r');
l=' '; fin = false;
while not(fin)
    l=fgetl(f1); fin =  feof(f1);
    if strfind(l,'META_STOP')>0
        break;
    end;
end;
NbLines = 0;
while not(fin)
    l=fgetl(f1); fin =  feof(f1);
    if length(l)>1
        [A, nb, errmsg, nextindex] = sscanf(l, '%f %f %f %f %f %f %f %f %f %f %f', [1 11]);
        NbLines = NbLines+1;
        if (NbLines==1)
            data = A(1:nb); % (MJD, secMJD, X, Y, Z [,VX,VY,VZ[,AX,AY,AZ]])
            if (nb~=5 && nb~=8 && nb~=11) fprintf('Wrong number of columns in %s\n', fpath); end
            nc = nb;
        else
            data = [data; A(1:nb)]; % (MJD, secMJD, X, Y, Z [,VX,VY,VZ[,AX,AY,AZ]])
            % if (mod(NbLines,10)==0) fprintf('/'); end
            % if (mod(NbLines,100)==0) fprintf(':%i\n',NbLines); end
        end
    end;
end;
fclose(f1);

% TimeSteps = 2400000.5+data(:,1)+data(:,2)./86400.; % dates in decimal JD
TimeSteps = data(:,1)+data(:,2)./86400.; % dates in decimal MJD
coordinates  = [data(:,3) data(:,4) data(:,5)];
if (nc>5) 
    velocities   = [data(:,6) data(:,7) data(:,8)];
    if (nc>8)
        gravitation  = [data(:,9) data(:,10) data(:,11)];
        dataBack = [coordinates velocities gravitation];
    else
        dataBack = [coordinates velocities];
    end;
else
    dataBack = coordinates;
end;

end
