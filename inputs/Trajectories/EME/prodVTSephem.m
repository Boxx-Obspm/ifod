% Production scenario simplifie
% Author: Boris Segret
% v.xxx, 25/03/2016
% CL=0

% purpose:
% - produce a rectilinear trajectory from 1 to 5 AU at *constant* velocity
% - produce the associated ephemerides of N objects
% - displays the scenario in .eps / .pdf

AU=150000000.;      % Astronomical Unit
day=86400.;         % 1 day in seconds
Xs=[0.  1.*AU 0.];  % km
Vs=[30. 0.    0.];  % km/s
dVn=0.;             % dVn*Vs is applied in perpendicular direction (on XY plane)
Ts=2458125.0;       % JD
Re=5.*AU;           % km
dt= 1.;             % time sampling (days)

P(1,:)=[1.*AU    0.     0.]; % km
P(2,:)=[2.*AU    0.     0.]; % km
P(3,:)=[2.*AU 1.*AU 0.1*AU]; % km
P(4,:)=[1.*AU    0. 0.1*AU]; % km

%fo='Y-line';
%fo='Y-line+1kX'; Xs=[1000. 1.*AU       0.];  % +1000 km
%fo='Y-line+1kY'; Xs=[0.    1.*AU+1000. 0.];  % +1000 km
%fo='Y-line+1kZ'; Xs=[0.    1.*AU    1000.];  % +1000 km
%fo='XY-curve'; dVn=0.000033;       % dVn*Vs is applied in perpendicular direction (on XY plane)
fo='XY-curve+1kY'; dVn=0.000033; Xs=[0.    1.*AU+1000. 0.]; % dVn*Vs is applied in perpendicular direction (on XY plane)

[status, msg, msgid] = mkdir(fo);  % ok if alredy exists (overwrites with new content)
% propagation
fid=fopen([fo '/' fo '.xyzv'],'w'); fprintf(fid, 'META_STOP\n'); fclose(fid);
for j=1:length(P(:,3))
    fid=fopen([fo '/' fo '_P' num2str(j,'%03i') '.eph'],'w'); fprintf(fid, 'META_STOP\n'); fclose(fid);
end
i=0; Xc=Xs; Tc=Ts; Vc=Vs;
r=norm(Xc);
while and(r < Re, i<1000)
  i=i+1;
  % - ephemerides from the current location
  for j=1:length(P(:,3))
    vect=(P(j,:)-Xc); d=norm(vect);
    lat =atan(vect(3)/norm([vect(1:2) 0])).*180./pi();
    % sign "-" because longitudes on the sky are in anti-trigonometric order
    lng =-(1-2*(vect(2)<0))*acos(vect(1)/norm(vect(1:2))).*180./pi();
    % output:
    fid=fopen([fo '/' fo '_P' num2str(j,'%03i') '.eph'],'a');
    fprintf(fid, '%15.6f %13.8f %13.8f %14.3f\n', Tc, lat, lng, d);
    fclose(fid);
  end
  fid=fopen([fo '/' fo '.xyzv'],'a');
  fprintf(fid, '%15.6f %17.6f %17.6f %17.6f %12.8f %12.8f %12.8f 0. 0. 0. 0. 0.\n', Tc, Xc, Vc);
  fclose(fid);
  % - next trajectory point
  Vc = Vc + [Vc(2) -Vc(1) 0.].*dVn;
  Xc = Xc + Vc.*dt*day;
  Tc = Tc + dt;
  r=norm(Xc);
end

% plots
fid=fopen([fo '/' fo '.xyzv'],'r'); fgetl(fid); % don't read META_STOP
%[MTX, nbc] = fscanf(fid, '%g %g %g %g %g %g %g\n', [7 inf]);
[MTX, nbc] = fscanf(fid, '%g %g %g %g %g %g %g %g %g %g %g %g\n', [12 inf]);
fclose(fid);
Xc=MTX(2,:)'./AU;
Yc=MTX(3,:)'./AU;
Zc=MTX(4,:)'./AU;
Vx=MTX(5,:)';
Vy=MTX(6,:)';
Vz=MTX(7,:)';
clrs(1,1:3)=[1 0 0];
clrs(2,1:3)=[0 1 0];
clrs(3,1:3)=[0 0 1];
clrs(4,1:3)=[.5 0 1];
clrs(5,1:3)=[0 1 1];
clrs(6,1:3)=[1 1 0];
figure(1); clf;
subplot(2,1,1); hold on; plot(Xc,Zc,'-k'); axis equal; axis([0 3 -0.1 0.2]); xlabel('X (AU)'); ylabel('Z (AU)');
title(['Trajectory ' fo], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
subplot(2,1,2); hold on; plot(Xc,Yc,'-k'); axis equal; axis([0 3 -0.1 1.1]); xlabel('X (AU)'); ylabel('Y (AU)');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
figure(2); clf;
subplot(2,2,1); hold on; xlabel('Long.(deg)');    ylabel('Lat.(deg)');     axis([-180. 180. -90. 90.]);
title(['Ephemerides ' fo], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
subplot(2,2,2); hold on; xlabel('time (days)'); ylabel('distances (AU)');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
subplot(2,2,3); hold on; xlabel('Long.(deg)');    ylabel('time (days)'); xlim([-180. 180.]);
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
subplot(2,2,4); hold on; xlabel('time (days)'); ylabel('Lat.(deg)');     ylim([-90. 90.]);
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
  for j=1:length(P(:,3))
    figure(1);
    subplot(2,1,1); plot(P(j,1)./AU, P(j,3)./AU, 'o', 'color', clrs(j,1:3));
    subplot(2,1,2); plot(P(j,1)./AU, P(j,2)./AU, 'o', 'color', clrs(j,1:3));
    fid=fopen([fo '/' fo '_P' num2str(j,'%03i') '.eph'],'r'); fgetl(fid); % don't read META_STOP
    [MTX, nbc] = fscanf(fid, '%g %g %g %g\n', [4 inf]);
    fclose(fid);
    Tc=MTX(1,:)';
    la=MTX(2,:)';
    ln=MTX(3,:)';
    dd=MTX(4,:)'./AU;
    figure(2);
    subplot(2,2,1); hold on; plot(ln, la, '-.', 'color', clrs(j,1:3));
    subplot(2,2,2); hold on; plot(Tc-Tc(1), dd, '-.', 'color', clrs(j,1:3));
    subplot(2,2,3); hold on; plot(ln, Tc-Tc(1), '-.', 'color', clrs(j,1:3));
    subplot(2,2,4); hold on; plot(Tc-Tc(1), la, '-.', 'color', clrs(j,1:3));
  end
ff=[fo '/' fo '_trj.png']; print(1,ff,'-dpng');
ff=[fo '/' fo '_eph.png']; print(2,ff,'-dpng');
%- figure savings to SVG (may crash, thus at the end)
%ff=[fo '/' fo '_trj.svg']; print(1,ff,'-dsvg');
%ff=[fo '/' fo '_eph.svg']; print(2,ff,'-dsvg');
