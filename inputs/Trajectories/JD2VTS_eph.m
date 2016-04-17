% Production scenario simplifie
% Author: Boris Segret
% v.1.1, 17/04/2016
% CL=0 <=== !!

% Converts a JD-dated trajectory file into VTS MJD dated and 8-column file

function outs = JD2VTS_eph(fpath)
v_inputs = '2.0';
% read a trajectory file from the META_STOP tag
% rewrites the header without changes
f1=fopen(fpath,'rt');
ff=fopen([fpath '_vts.eph'],'w');
l=' ';
while 1
    l=fgetl(f1); 
    if strfind(l,'NAV_input')>0
        l=['NAV_input version : ' v_inputs];
        fprintf(ff,'%s\n',l);
    end
    if strfind(l,'COLUMN #01 : date (in JD)')>0
        l='COLUMN #01 : day in MJD';
        fprintf(ff,'%s\n',l);
        l='COLUMN #02 : nb of seconds in the day in MJD';
        fprintf(ff,'%s\n',l);
    elseif strfind(l,'COLUMN #')>0
        nbc = str2num(l(9:10))+1;
        if nbc <= 5
            l=[l(1:8) sprintf('%02i',nbc) l(11:length(l))];
            fprintf(ff,'%s\n',l);
        end
    end
    if strfind(l,'META_STOP')>0
        fprintf(ff,'%s\n',l);
        break;
    end;
end;
data = fscanf(f1,'%f %f %f %f %f %f %f %f %f %f %f %f', [12 inf]);
data = data';
fclose(f1);

%NbLines    = size(data,1);
dates(:,1) = floor(data(:,1)-2400000.5);
dates(:,2) = mod(data(:,1)-0.5,1).*86400;
outs = [dates data(:,2:4)];

fprintf(ff, '%7i %13.6f %13.8f %13.8f %14.3f\n', outs');
fclose(ff);
