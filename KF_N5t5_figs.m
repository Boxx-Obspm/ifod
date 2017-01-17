%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:   V3.3 26-08-2016 (dd/mm/yyyy)
%                  - forked from V3.2
%                  - adaptation to N=5 measurements, errorbars on the 3rd point of X
%                  REMAINING ISSUE: some figures are not compatible with multiple foreground objects
%CL=1
%Version & Date:
%                  V3.2 24-08-2016
%                  - adaptation to show errorbars from the mean of 2nd and 3rd point of X (not of the 1st)
%                  V3.1 06-05-2016
%                  (forked from stat_plots_full.m, v3.1)
%                  V3.0 27-04-2016
%                  (forked from data_plots_full.m, v2.1)
%                  V2.1 11-04-2016 Boris Segret
%                  - specific plots for quick analysis of results
%                  - adapted to output files produced by data_extraction.m in version v2.1
%                  (forked from data_plots.m)
%                  V1 11-09-2015 Tristan Mallet
%
%
% This program plots the critical outputs from the dataExtraction file.
%
% 1. Inputs: fname = name of the result file to read (in the workspace)
%
% 2. Outputs: some plots
%

clear;
NbCol = 94;
inPath  = 'E:\myGits\ifod_kf\ifod\inputs\';
outPath = '.\pics_N=5\';
%------ for real data, the Y results must be inverted (bug)!
fname = [inPath 'EME_out_E-1asec,06h']; scn = 'EME_mini'; tlim=225.;
scn = [outPath scn];

pf=fopen(fname,'rt');
while not(feof(pf))
  l=fgetl(pf);
  if not(isempty(l))
    if not(isempty(strfind(l,'META_STOP')))
      l=fgetl(pf);
      data = sscanf(l, '%f', [1 NbCol]);
      break;
    end;
    if strfind(l,'SCENARIO')>0
      ttl=l;
%       scn=ttl(strfind(ttl,':')+1:length(ttl));
    end
  end;
end;
while not(feof(pf));
  l=fgetl(pf);
  if not(isempty(l))
    data = [data; sscanf(l, '%f', [1 NbCol])];
  end;
end;

fclose(pf);
tt = -data(1,1)+data(:,1)+data(:,2)/86400.;
% for real data, the Y results must be inverted (bug)!
% data(:,17)=-data(:,17); data(:,20)=-data(:,20); data(:,23)=-data(:,23); data(:,26)=-data(:,26); 
% data(:,33)=-data(:,33); 
% recalculer Transversal & Longitudinal shifts
%   unitvvector = unit_speed_vector(ii,vel1);
% 	trans_err=norm(cross(X(1:3)', unitvvector)); % data(:,7)
% 	long_err=dot(X(1:3)', unitvvector);          % data(:,8)

mm = median(abs(data));
% im=23;ie=49;is=75;
im=29;ie=55;is=81;
xm = data(:,im+0); xe = data(:,ie+0); stdx=data(:,is+0);
ym = data(:,im+1); ye = data(:,ie+1); stdy=data(:,is+1);
zm = data(:,im+2); ze = data(:,ie+2); stdz=data(:,is+2);
irm=34;ire=60;irs=86;
rm = data(:,irm); re = data(:,ire); stdr=data(:,irs);
ivm=37;ive=63;ivs=89;


%----------------------------------------------------
% (transversal & longitudinal shifts)
figure(11); clf;
hold on; plot(tt, data(:,4), 'ob', tt, data(:,3), 'xk');
idy=find(abs(data(:,4))<=2*mm(4)); mn1=mean(data(idy,4)); sg1 = max([1 std(data(idy,4))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([0 10000]);
xlabel('time (days)'); ylabel('Shift from Reference (km)'); title('Transversal shift');
legend('reconstructed', 'expected');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(12); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
% errorbar(tt, data(:,4)-data(:,3), data(:,5), '-r');
plot(tt, data(:,4)-data(:,3), '-r');
idy=find(abs(data(:,4))<=2*mm(4)); mn1=mean(data(idy,4)-data(idy,3)); sg1 = max([.001 std(data(:,5))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-250 250]);
xlabel('time (days)'); ylabel('Shift error (km)');  title('Transversal error');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(13); clf;
hold on; plot(tt, data(:,7), 'ob', tt, data(:,6), 'xk');
idy=find(abs(data(:,7))<=2*mm(8)); mn2=mean(data(idy,7)); sg2 = max([1 std(data(idy,7))]); ylim([mn2-3*sg2 mn2+3*sg2]);
xlim([0 tlim]); ylim([-10000 5000]);
xlabel('time (days)'); ylabel('Shift from Reference (km)'); title('Longitudinal shift');
legend('reconstructed', 'expected');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(14); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
% errorbar(tt, data(:,7)-data(:,6), data(:,8), '-r');
plot(tt, data(:,7)-data(:,6), '-r');
idy=find(abs(data(:,7))<=2*mm(7)); mn2=mean(data(idy,7)-data(idy,6)); sg2 = max([.001 std(data(:,8))]); ylim([mn2-3*sg2 mn2+3*sg2]);
xlim([0 tlim]); ylim([-400 400]);
xlabel('time (days)'); ylabel('Shift error (km)'); title('Longitudinal error');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(15); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, data(:,4)-data(:,3), data(:,5), '-r');
% plot(tt, data(:,4)-data(:,3), '-r');
idy=find(abs(data(:,4))<=2*mm(4)); mn1=mean(data(idy,4)-data(idy,3)); sg1 = max([.001 std(data(:,5))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-2500 2500]);
xlabel('time (days)'); ylabel('Shift error (km)');  title('Transversal error');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(16); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, data(:,7)-data(:,6), data(:,8), '-r');
% plot(tt, data(:,7)-data(:,6), '-r');
idy=find(abs(data(:,7))<=2*mm(7)); mn2=mean(data(idy,7)-data(idy,6)); sg2 = max([.001 std(data(:,8))]); ylim([mn2-3*sg2 mn2+3*sg2]);
xlim([0 tlim]); ylim([-6500 +6500]);
xlabel('time (days)'); ylabel('Shift error (km)'); title('Longitudinal error');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');


%- figure savings to PNG
ff=[scn '_transversal.png']; print(11,ff,'-dpng');
ff=[scn '_transvshift.png']; print(12,ff,'-dpng');
ff=[scn '_transvsherr.png']; print(15,ff,'-dpng');
ff=[scn '_longitudnal.png']; print(13,ff,'-dpng');
ff=[scn '_longitshift.png']; print(14,ff,'-dpng');
ff=[scn '_longitsherr.png']; print(16,ff,'-dpng');

%-------------------------------------------
% (dX; dY; dZ)
%
figure(21); clf; 
hold on;
plot(tt, xe, '-k');
errorbar(tt, xm, stdx, 'ob');
idy=find(abs(xm)<=2*mm(im)); mn1=mean(xm(idy)); sg1 = max([1 std(stdx(idy))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-10000 10000]);
xlabel('time (days)'); ylabel('dX (km)');  %legend('reconstructed', 'expected');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(27); clf; 
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k'); errorbar(tt, xm-xe, stdx, '-r');
idy=find(abs(xm)<=2*mm(im)); mn1=mean(xm(idy)-xe(idy)); sg1 = max([1 std(stdx(idy))]); ylim([mn1-sg1 mn1+sg1]);
xlim([0 tlim]); ylim([-6000 6000]);
xlabel('time (days)'); ylabel('dX error (km)'); set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(22); clf; 
hold on;
plot(tt, ye, '-k');
errorbar(tt, ym, stdy, 'ob');
idy=find(abs(ym)<=2*mm(im+1)); mn1=mean(ym(idy)); sg1 = max([1 std(stdy)]); ylim([mn1-3*sg1 mn1+3*sg1]);
% ylim([mn1-0.3*abs(mn1) mn1+0.3*abs(mn1)]);
xlim([0 tlim]); ylim([-5000 20000]);
xlabel('time (days)'); ylabel('dY (km)'); %legend('reconstructed', 'expected');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(28); clf; 
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k'); errorbar(tt, ym-ye, stdy, '-r');
idy=find(abs(ym)<=2*mm(im+1)); mn1=mean(ym(idy)-ye(idy)); sg1 = max([1 std(stdy)]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-6000 6000]);
xlabel('time (days)'); ylabel('dY error (km)'); set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(23); clf; 
hold on;
plot(tt, ze, '-k');
errorbar(tt, zm, stdz, 'ob');
idy=find(abs(zm)<=2*mm(im+2)); mn1=mean(zm(idy)); sg1 = max([1 std(stdz(idy))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-5000 5000]);
xlabel('time (days)'); ylabel('dZ (km)');  % legend('reconstructed', 'expected');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(29); clf; 
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k'); errorbar(tt, zm-ze, stdz, '-r');
idy=find(abs(zm)<=2*mm(im+2)); mn1=mean(zm(idy)-ze(idy)); sg1 = max([1 std(stdz)]); ylim([mn1-3.*sg1 mn1+3.*sg1]);
xlim([0 tlim]); ylim([-3000 3000]);
xlabel('time (days)'); ylabel('dZ error (km)'); set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

%- figure savings to PNG
ff=[scn '_dX.png'];  print(21,ff,'-dpng');
ff=[scn '_dY.png'];  print(22,ff,'-dpng');
ff=[scn '_dZ.png'];  print(23,ff,'-dpng');
ff=[scn '_dXerror.png'];  print(27,ff,'-dpng');
ff=[scn '_dYerror.png'];  print(28,ff,'-dpng');
ff=[scn '_dZerror.png'];  print(29,ff,'-dpng');

%-----------------------------------------------------------------
figure(31); clf; % (dr), shift of distance to 1st foreground object
hold on;
plot(tt, data(:,ire-2), '-k');
errorbar(tt, data(:,irm-2), data(:,irs-2), 'ob');
idy=find(abs(data(:,irm-2))<=2*mm(irm-2)); mn1=mean(data(idy,irm-2));
sg1 = max([1 std(data(idy,irs-2))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-15000 15000]);
xlabel('time (days)'); ylabel('dr (km)'); %  legend('reconstructed', 'expected');
title(['Distance shift to 1st foreground body'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(36); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, data(:,irm-2)-data(:,ire-2), data(:,irs-2), '-r');
idy=find(abs(data(:,irm-2))<=2*mm(irm-2)); mn1=mean(data(idy,irm-2)-data(idy,ire-2));
sg1 = max([1 std(data(idy,irs-2))]); ylim([mn1-sg1 mn1+sg1]);
xlim([0 tlim]); ylim([-10000 10000]);
xlabel('time (days)'); ylabel('dr error (km)');
title(['Distance error wrt expected (1st foreground body)'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(32); clf; % (dr), shift of distance to 2nd foreground object
hold on;
plot(tt, data(:,ire-1), '-k');
errorbar(tt, data(:,irm-1), data(:,irs-1), 'ob');
idy=find(abs(data(:,irm-1))<=2*mm(irm-1)); mn1=mean(data(idy,irm-1));
sg1 = max([1 std(data(idy,irs-1))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-15000 15000]);
xlabel('time (days)'); ylabel('dr (km)'); %  legend('reconstructed', 'expected');
title(['Distance shift to 2nd foreground body'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(37); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, data(:,irm-1)-data(:,ire-1), data(:,irs-1), '-r');
idy=find(abs(data(:,irm-1))<=2*mm(irm-1)); mn1=mean(data(idy,irm-1)-data(idy,ire-1));
sg1 = max([1 std(data(idy,irs-1))]); ylim([mn1-sg1 mn1+sg1]);
xlim([0 tlim]); ylim([-10000 10000]);
xlabel('time (days)'); ylabel('dr error (km)');
title(['Distance error wrt expected (2nd foreground body)'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(33); clf; % (dr), shift of distance to 3rd foreground object
hold on;
plot(tt, re, '-k');
errorbar(tt, rm, stdr, 'ob');
idy=find(abs(rm)<=2*mm(irm)); mn1=mean(rm(idy));
sg1 = max([1 std(stdr(idy))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-15000 15000]);
xlabel('time (days)'); ylabel('dr (km)'); %  legend('reconstructed', 'expected');
title(['Distance shift to 3rd foreground body'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(38); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, rm-re, stdr, '-r');
idy=find(abs(rm)<=2*mm(irm)); mn1=mean(rm(idy)-re(idy));
sg1 = max([1 std(stdr)]); ylim([mn1-sg1 mn1+sg1]);
xlim([0 tlim]); ylim([-10000 10000]);
xlabel('time (days)'); ylabel('dr error (km)');
title(['Distance error wrt expected (3rd foreground body)'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(34); clf; % (dr), shift of distance to 4th foreground object
hold on;
plot(tt, data(:,ire+1), '-k');
errorbar(tt, data(:,irm+1), data(:,irs+1), 'ob');
idy=find(abs(data(:,irm+1))<=2*mm(irm+1)); mn1=mean(data(idy,irm+1)); 
sg1 = max([1 std(data(idy,irs+1))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-15000 15000]);
xlabel('time (days)'); ylabel('dr (km)'); %  legend('reconstructed', 'expected');
title(['Distance shift to 4th foreground body'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(39); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, data(:,irm+1)-data(:,ire+1), data(:,irs+1), '-r');
idy=find(abs(data(:,irm+1))<=2*mm(irm+1)); mn1=mean(data(idy,irm+1)-data(idy,ire+1));
sg1 = max([1 std(data(idy,irs+1))]); ylim([mn1-sg1 mn1+sg1]);
xlim([0 tlim]); ylim([-10000 10000]);
xlabel('time (days)'); ylabel('dr error (km)');
title(['Distance error wrt expected (4th foreground body)'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

figure(35); clf; % (dr), shift of distance to 5th foreground object
hold on;
plot(tt, data(:,ire+2), '-k');
errorbar(tt, data(:,irm+2), data(:,irs+2), 'ob');
idy=find(abs(data(:,irm+2))<=2*mm(irm+2)); mn1=mean(data(idy,irm+2)); 
sg1 = max([1 std(data(idy,irs+2))]); ylim([mn1-3*sg1 mn1+3*sg1]);
xlim([0 tlim]); ylim([-15000 15000]);
xlabel('time (days)'); ylabel('dr (km)'); %  legend('reconstructed', 'expected');
title(['Distance shift to 5th foreground body'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');
%
figure(40); clf;
hold on; plot([tt(1) tt(length(tt))], [0. 0.], '-k');
errorbar(tt, data(:,irm+2)-data(:,ire+2), data(:,irs+2), '-r');
idy=find(abs(data(:,irm+2))<=2*mm(irm+2)); mn1=mean(data(idy,irm+2)-data(idy,ire+2));
sg1 = max([1 std(data(idy,irs+2))]); ylim([mn1-sg1 mn1+sg1]);
xlim([0 tlim]); ylim([-10000 10000]);
xlabel('time (days)'); ylabel('dr error (km)');
title(['Distance error wrt expected (5th foreground body)'], 'FontWeight','bold');
set(gca, 'XColor', 'm'); set(gca, 'YColor', 'm');

%- figure savings to PNG
ff=[scn '_distto1stB.png']; print(31,ff,'-dpng');
ff=[scn '_distto2ndB.png']; print(32,ff,'-dpng');
ff=[scn '_distto3rdB.png']; print(33,ff,'-dpng');
ff=[scn '_distto4thB.png']; print(34,ff,'-dpng');
ff=[scn '_distto5thB.png']; print(35,ff,'-dpng');
ff=[scn '_distto1stBerror.png']; print(36,ff,'-dpng');
ff=[scn '_distto2ndBerror.png']; print(37,ff,'-dpng');
ff=[scn '_distto3rdBerror.png']; print(38,ff,'-dpng');
ff=[scn '_distto4thBerror.png']; print(39,ff,'-dpng');
ff=[scn '_distto5thBerror.png']; print(40,ff,'-dpng');



%- figure savings to SVG (may crash, thus at the end)
% ff=[scn '_shifts.svg']; print(1,ff,'-dsvg');
% ff=[scn '_dXdV.svg']; print(2,ff,'-dsvg');
% ff=[scn '_dr.svg']; print(3,ff,'-dsvg');
% ff=[scn '_uniV.svg']; print(4,ff,'-dsvg');
% ff=[scn '_lglt.svg']; print(5,ff,'-dsvg');

