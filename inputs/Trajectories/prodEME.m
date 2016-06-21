%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V1.1 10-04-2016 (dd/mm/yyyy)
%                  - produce Ephemeris in VTS-Format for a given body (target) from a given trajectory (source)
%CL=2
%Version & Date:
%                  V1.0 09-04-2016 (dd/mm/yyyy) Boris Segret
%
% I/: Sfpath, Tfpath: Source's and Target's trajectory files
%     - Sfpath (Source) is VTS-formatted
%     - Tfpath (Target) is IMCCE-formatted
% O/: VTS-formatted ephemerides of T from S, time stepped on S on the common time interval.
% F/: - S to T directions are expressed in latitudes, longitudes and distances
%     - light(travel is not taken into account

function myData = prodEME()
clear;
global cubesat ceresData jupiterData earthData marsData saturnData;
au2km = 149597870.7; % km (source obspm.fr, 29/01/2014)
cubesat = readVTS('EME/58122+SOI_v6.4_jdv000_312_vts.xyzv', 1./au2km);
ceresData = readImcce('EME/Ceres.imcce', 1.);
jupiterData = readImcce('EME/Jupiter.imcce', 1.);
earthData = readImcce('EME/Earth.imcce', 1.);
marsData = readImcce('EME/Mars.imcce', 1.);
saturnData = readImcce('EME/Saturn.imcce', 1.);
t0c=cubesat(1,1);
t0p=ceresData(1,1)-t0c;

clrs(1,1:3)=[0 0 1];
clrs(2,1:3)=[1 0 0];
clrs(3,1:3)=[0 1 0];
clrs(4,1:3)=[.5 0 1];
clrs(5,1:3)=[0 1 1];
clrs(6,1:3)=[1 1 0];

figure(10);
plot3(cubesat(:,2),cubesat(:,3),cubesat(:,4),'b');
hold on;
plot3(ceresData(:,2),ceresData(:,3),ceresData(:,4),'k');
plot3(jupiterData(:,2),jupiterData(:,3),jupiterData(:,4),'k');
plot3(earthData(:,2),earthData(:,3),earthData(:,4),'k');
plot3(marsData(:,2),marsData(:,3),marsData(:,4),'k');
plot3(saturnData(:,2),saturnData(:,3),saturnData(:,4),'k');

figure(11); clf;
% mettre en AU, echelle egales (log? fonction loglog(X1,Y1)), légendes => puis montrer la
% différence entre 0dv et 1m/s dv "expected"
plot(cubesat(:,2),cubesat(:,3),'.k');
hold on; axis equal; minx=0.;maxx=0.;miny=0.;maxy=0.;
plot(earthData(:,2),earthData(:,3), 'color', clrs(1,1:3));
minx = min([minx earthData(:,2)']); maxx = max([maxx earthData(:,2)']); miny = min([miny earthData(:,3)']); maxy = max([maxy earthData(:,3)']);
plot(marsData(:,2),marsData(:,3), 'color', clrs(2,1:3));
minx = min([minx marsData(:,2)']); maxx = max([maxx marsData(:,2)']); miny = min([miny marsData(:,3)']); maxy = max([maxy marsData(:,3)']);
plot(ceresData(:,2),ceresData(:,3), 'color', clrs(3,1:3));
minx = min([minx ceresData(:,2)']); maxx = max([maxx ceresData(:,2)']); miny = min([miny ceresData(:,3)']); maxy = max([maxy ceresData(:,3)']);
%plot(jupiterData(:,2),jupiterData(:,3), 'color', clrs(4,1:3));
%minx = min([minx jupiterData(:,2)']); maxx = max([maxx jupiterData(:,2)']); miny = min([miny jupiterData(:,3)']); maxy = max([maxy jupiterData(:,3)']);
%plot(saturnData(:,2),saturnData(:,3), 'color', clrs(5,1:3));
%minx = min([minx saturnData(:,2)']); maxx = max([maxx saturnData(:,2)']); miny = min([miny saturnData(:,3)']); maxy = max([maxy saturnData(:,3)']);
legend('CubeSat', 'Earth','Mars','Ceres','Jupiter','Saturn');
axis([floor(minx)-0.5 floor(maxx+1) floor(miny)-0.5 floor(maxy)+1]);
myData=1;
end

function [outs] = readImcce(Tfpath, scale)
v_inputs = '2.0';

tf=fopen(Tfpath,'rt');
l=fgetl(tf);
while not(isempty(l))
  if not(isempty(strfind(l,'META_STOP')))
    l=fgetl(tf);
    comas = strfind(l,',');
    TBody = l(1:comas(1)-1);
    tStep = datenum(l(comas(1)+4:comas(2)-1), 'yyyy-mm-ddTHH:MM:SS.FFF');
    tdata = scale.*sscanf(l(comas(2)+1:length(l)), '%f, %f, %f, %f, %f, %f, %f', [1 7]);
    l=fgetl(tf);
    break;
  end;
  l=fgetl(tf);
end;
while not(isempty(l))
  tStep = [tStep; datenum(l(comas(1)+4:comas(2)-1), 'yyyy-mm-ddTHH:MM:SS.FFF')];
  tdata = [tdata; scale.*sscanf(l(comas(2)+1:length(l)), '%f, %f, %f, %f, %f, %f, %f', [1 7])];
  if feof(tf)
    break;
  end
  l=fgetl(tf);
end;
fclose(tf);

outs = [tStep, tdata];
end

function [outs] = readVTS(Tfpath, scale)
v_inputs = '2.0';

%epochs = sdata(:,1)+sdata(:,2)/86400.;
tf=fopen(Tfpath,'rt');
l=fgetl(tf);
while not(isempty(l))
  if not(isempty(strfind(l,'META_STOP')))
    l=fgetl(tf);
    tStep = sscanf(l(1:22), '%f %f', [1 2]);
    tdata = scale.*sscanf(l(22:length(l)), '%f %f %f %f %f %f', [1 6]);
    l=fgetl(tf);
    break;
  end;
  l=fgetl(tf);
end;
while not(isempty(l))
  tStep = [tStep; sscanf(l(1:22), '%f %f', [1 2])];
  tdata = [tdata; scale.*sscanf(l(22:length(l)), '%f %f %f %f %f %f', [1 6])];
  if feof(tf)
    break;
  end
  l=fgetl(tf);
end;
fclose(tf);

numDates = tStep(:,1) + tStep(:,2)/86400.;
outs = [numDates, tdata];
end

%
%
%adata = [tnumdata' tdata'];
%
%nlgn  = min([size(sdata,1) size(tdata,1)]);
%sdata = sdata(1:nlgn,1:5);
%tdata = tdata(1:nlgn,1:3).*uneAU;
%
%dr  = tdata(:,1:3)-sdata(:,3:5);
%lat = atan(dr(:,3)./sqrt(dr(:,1).^2+dr(:,2).^2)).*180./pi();
%% sign "-" because longitudes on the sky are in anti-trigonometric order
%% lng =-(1-2*(dr(:,2)<0)).*acos(dr(:,1)./sqrt(dr(:,1).^2+dr(:,2).^2)).*180./pi();
%lng =mod((1-2*(dr(:,2)<0)).*acos(dr(:,1)./sqrt(dr(:,1).^2+dr(:,2).^2)).*180./pi(),360.);
%dst=sqrt(dr(:,1).^2+dr(:,2).^2+dr(:,3).^2);
%
%outs = [sdata(:,1:2) lat lng dst];
%
%ff=fopen([Tfpath '_vts.eph'],'w');
%fprintf(ff,'NAV_input version : %s\nGenerated by BIRDY NAV TEAM\nDate : %s\n\n', v_inputs, datestr(now));
%fprintf(ff,'TARGET_NAME : %s\nAS SEEN FROM : %s\nREFERENCE_FRAME : heliocentric ecliptic J2000\n\n', Tfpath, Sfpath);
%fprintf(ff,'NO LIGHT-TRAVEL DELAY INCLUDED\n');
%fprintf(ff,'META_START\n\n');
%fprintf(ff,'COLUMN #01 : Day of the date (in MJD)\n');
%fprintf(ff,'COLUMN #02 : Seconds in the day (in seconds)\n');
%fprintf(ff,'COLUMN #03 : Latitude of the target body (in degrees)\n');
%fprintf(ff,'COLUMN #04 : Longitude of the target body (in degrees)\n');
%fprintf(ff,'COLUMN #05 : Distance of the target body (km)\n');
%fprintf(ff,'\nMETA_STOP\n\n');
%
%fprintf(ff, '%7i %13.6f %13.8f %13.8f %14.3f\n', outs');
%fclose(ff);
%end
