% Scenario de reference EME
% (11/04) tentatives d'illustrations rapides
%
clear;
addpath('../..');

figure(10); clf; hold on;

[NbLines, TimeSteps, lCeres, LCeres, dCeres] = readEphem('Ceres_jdv000.eph'); LCeres=mod(-LCeres+180,360)-180;
[NbLines, TimeSteps, lEarth, LEarth, dEarth] = readEphem('Earth_jdv000.eph'); LEarth=mod(-LEarth+180,360)-180;
[NbLines, TimeSteps, lMars, LMars, dMars] = readEphem('Mars_jdv000.eph'); LMars=mod(-LMars+180,360)-180;
[NbLines, TimeSteps, lJupiter, LJupiter, dJupiter] = readEphem('Jupiter_jdv000.eph'); LJupiter=mod(-LJupiter+180,360)-180;
[NbLines, TimeSteps, lSaturn, LSaturn, dSaturn] = readEphem('Saturn_jdv000.eph'); LSaturn=mod(-LSaturn+180,360)-180;
%plot(LCeres,lCeres,'x', LEarth,lEarth,'x', LMars,lMars,'x', LJupiter,lJupiter,'x', LSaturn,lSaturn,'x');
%legend('Ceres','Earth','Mars','Jupiter','Saturn');

[NbLines, TimeSteps, lCeres1, LCeres1, dCeres1] = readEphem('T0+jdv_y-axis/Ceres_jdv010.eph'); LCeres1=mod(-LCeres1+180,360)-180;
[NbLines, TimeSteps, lEarth1, LEarth1, dEarth1] = readEphem('T0+jdv_y-axis/Earth_jdv010.eph'); LEarth1=mod(-LEarth1+180,360)-180;
[NbLines, TimeSteps, lMars1, LMars1, dMars1] = readEphem('T0+jdv_y-axis/Mars_jdv010.eph'); LMars1=mod(-LMars1+180,360)-180;
[NbLines, TimeSteps, lJupiter1, LJupiter1, dJupiter1] = readEphem('T0+jdv_y-axis/Jupiter_jdv010.eph'); LJupiter1=mod(-LJupiter1+180,360)-180;
[NbLines, TimeSteps, lSaturn1, LSaturn1, dSaturn1] = readEphem('T0+jdv_y-axis/Saturn_jdv010.eph'); LSaturn1=mod(-LSaturn1+180,360)-180;
%plot(LCeres,lCeres,'o', LEarth,lEarth,'o', LMars,lMars,'o', LJupiter,lJupiter,'o', LSaturn,lSaturn,'o');
    %(LMars1-LMars).*3600,(lMars1-lMars).*3600,'o', ...
plot(...
    (LCeres1-LCeres).*3600,(lCeres1-lCeres).*3600,'o', ...
    (LEarth1-LEarth).*3600,(lEarth1-lEarth).*3600,'o', ...
    (LJupiter1-LJupiter).*3600,(lJupiter1-lJupiter).*3600,'o', ...
    (LSaturn1-LSaturn).*3600,(lSaturn1-lSaturn).*3600,'o');
legend('delta-Ceres', 'delta-Earth','delta-Jupiter','delta-Saturn');
