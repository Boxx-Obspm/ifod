%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  V. 1.2, 03-03-2016 (dd/mm/yyyy) for clarifications only
%                  until V1, 11-09-2015, Tristan Mallet
%CL=1
%
%
% Produces the 3 preceeding intervals (in decimal days) wrt to the date of "ii"
% for the 3 measurements to be considered in the OD in addition of ii.
%
% 1. Inputs:
%    ii : date (time step on the trajectory) where the OD is performed
%      ==> unit ??
%    T  : Nx2 matrix, Nx(MJD_day, seconds_in_day), dates where the measurement sampling changes
%    dt : (N-1)x3 matrix, with dt1, dt2, dt3, intervals (in hours) between measurements before "ii"
%     'trajectory_name/trajectory_name_ephjup' : The actual trajectory we consider
%
% 2. Outputs:
%   timeStep : 1*3 vector (ii-dt1, ii-dt2, ii-dt3)


function [timeStep]=time_step(ii,T,dt,trajectory_name,trajectory_name_ephjup)
[TimeList1,lat1,long1,distance1,coordinates1,velocity1]=actual_trajectory(trajectory_name,trajectory_name_ephjup);
% second call to actual_trajectory!!
% the need is only to access Timelist1

MJD_0=2400000.5;
SEC_0=86400;
% THESIS : considérer jour sideral ou jour solaire? (ici jour solaire)
T=T(:,1)+MJD_0+T(:,2)/SEC_0;
% implicite clearing & redefining of T!! => now decimal JD
	for k = 1:length(T)-1 % The size of T (number of sampling changes can be edited).
		if (TimeList1(ii)<T(1))
			timeStep=dt(1,:)/SEC_0*3600;
			break;
		elseif (TimeList1(ii)<T(k+1) && TimeList1(ii)>=T(k))
			timeStep=dt(k,:)/SEC_0*3600;
			break;
		else timeStep=dt(k+1,:)/SEC_0*3600;
        end
	
    end
  
%   # ici les timeStep étaient en nb de jours décimaux (ce qui est bien), je les renomme dt1, dt2, dt3
%   # puis ils sont convertis en nb de "pas".... mais pourquoi???
%   # donc timeStep(1) : nb de pas du fichier depuis ii et le plus proche *après* ii+dt1
%   #              (2) : nb de pas du fichier depuis (ii+timeStep(1)) et le plus proche *après* ii+timeStep(1)+dt2
%   #                    (notons que timeStep(1) n'est *plus* dt1 en jours décimaux mais un pas de fichier)
%   #              (3) : nb de pas du fichier depuis (ii+timeStep(1)+timeStep(2)) et le plus proche *après* ii+timeStep(1)+timeStep(2)+dt3
%   # pas trop grave mais tres fort risque de fournir 2 mesures identiques à l'algorithme
%   
%   # en plus c'est tres long car le calcul a lieu sur la totalite du vecteur des dates
	timeStep(1)=sum((TimeList1<=TimeList1(ii)+timeStep(1))) -ii;
	timeStep(2)=sum((TimeList1<=TimeList1(ii+timeStep(1))+timeStep(2))) -ii-timeStep(1);
	timeStep(3)=sum((TimeList1<=TimeList1(ii+timeStep(1)+timeStep(2))+timeStep(3))) -ii-timeStep(1)-timeStep(2);
end
