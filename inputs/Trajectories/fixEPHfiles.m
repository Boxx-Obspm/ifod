%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V1.1 09-04-2016 (dd/mm/yyyy)
%                  REMAINING ISSUE: still a bug but management of longitudes has got a temporary fix
%                  - fix longitude values as produced by Trajectory Solver until v.2015
%                  - format for VTS
%CL=2
%Version & Date:
%                  V1 02-04-2016 (dd/mm/yyyy) Boris Segret
%
% This program reads the Ephemeris data as produced by TS until versions of 2015, corrects
% the data and formats the date column into 2-column VTS-dates, then produced a
% "_vts.eph" suffixed file.
%
% I/: an ephemeride file
% O/: fixed file with "_vts.eph" suffix.
% F/: - Line of sight is reversed => (lat')=-('lat), (long')=('long)+180 [360]
%     - JD date in 1st column into E(MJD) & mod(MJD,1)*86400 in columns 1 and 2

function outs = fixEPHfiles(fpath)

% read an ephemeride file from the META_STOP tag
f2=fopen(fpath,'rt');
ff=fopen([fpath '_vts.eph'],'w');
l=' ';
while 1
    l=fgetl(f2);
    if strfind(l,'COLUMN #01 : date')>0
        l='COLUMN #01 : day in MJD';
        fprintf(ff,'%s\n',l);
        l='COLUMN #02 : nb of seconds in the day in MJD';
    elseif strfind(l,'COLUMN #')>0
        nbc = str2num(l(9:10))+1;
        if nbc <= 5
            l=[l(1:8) sprintf('%02i',nbc) l(11:length(l))];
        end
    end
    fprintf(ff,'%s\n',l);
    if strfind(l,'META_STOP')>0
        break;
    end;
end;

data = fscanf(f2,'%f %f %f %f', [4 inf]);
data = data';
fclose(f2);

data(:,2)  = -data(:,2); % this variable contains the latitude of the observed planet (in  degree)for each point of the reference trajectory.
% the "-" sign is requested to convert Ecliptic longitudes into trigonometric longitudes
data(:,3) = mod(180.+data(:,3),360.); % this variable contains the longitude of the observed planet (in  degree) for each point of the reference trajectory.
dates(:,1) = floor(data(:,1)-2400000.5);
dates(:,2) = mod(data(:,1)-0.5,1).*86400;
outs = [dates data(:,2:4)];

fprintf(ff, '%7i %13.6f %13.8f %13.8f %14.3f\n', outs');
fclose(ff);
end
