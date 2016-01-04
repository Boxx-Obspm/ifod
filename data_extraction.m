%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet
%Version & Date:   V1 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
% This program writes the critical outputs in the dataExtraction file in the VTS format.
%
% 1. Inputs:
%    VTS text-file : scenario-i 
% 2. Outputs:
%    text file 'algo_scenario-i : text file which displays the results of the accuracy of the matrix inversion method.

function [data]=data_extraction()
	
data=[];
MJD_0=2400000.5;
SEC_0=86400;
#for n=0 : 5 scenario=fopen(strcat('./Inputs/Scenarios/scenario-',num2str(n)),'r')
scenario=fopen('./Inputs/Scenarios/scenario-4','r'); #we open the scenario file
	l=' ';
	while 1
		l=fgetl(scenario);
		if strfind(l,'META_STOP')>0 #We start reading the file from the META_STOP tag
			break;
		end;
	end;
	scenario_num=fgetl(scenario) #Reading of the 4 rows of the considered scenario
	trajectory_name=fgetl(scenario)
	trajectory_name_ephjup=fgetl(scenario)
	algo=fgetl(scenario)
	sampling=fgetl(scenario)
fclose(scenario);

#Extraction of the trajectory data
[TimeList1,lat1,long1,distance1,coordinates1,velocity1]=actual_trajectory(trajectory_name,trajectory_name_ephjup);
[TimeList0,lat0,long0,distance0,coordinates0,velocity0]=reference_trajectory();

ii_MAX=length(TimeList1);

timeStep=fopen(strcat('./Inputs/Data/',sampling),'r'); #we open the file timeStep-i
	l=' ';
	while 1
		l=fgetl(timeStep);
		if strfind(l,'META_STOP')>0
			break;
		end;
	end;
	sampling_data=dlmread(timeStep);
	T=[sampling_data(:,1),sampling_data(:,2)] #we pick the sampling data and stock it in T and dt
	dt=[sampling_data(:,3),sampling_data(:,4),sampling_data(:,5)]
fclose(timeStep);

for ii = 1:1:ii_MAX
	[timeStep]=time_step(ii,T,dt,trajectory_name,trajectory_name_ephjup);
[dr,Dvectr,Dvelocity]=test_interpolation(ii,timeStep,trajectory_name,trajectory_name_ephjup);
[X,A,B,elapsed_time]=annul_grad(ii,timeStep,algo,trajectory_name,trajectory_name_ephjup);
	[Xexp]=Calculate_Xexpected(dr, Dvectr, Dvelocity);

	diff=X-Xexp;
	
	% Extraction of the day in MJD (integer):
	day=fix(TimeList1(ii)-MJD_0);
	
	% Extraction of the seconds
	sec=mod(TimeList1(ii)-MJD_0,1)*SEC_0;
	
	% Extraction of the transversal difference betwwen the reference and the actual trajectories
	trans_traj=norm(cross((coordinates1(ii,:)-coordinates0(ii,:))',unit_speed_vector(ii,velocity1)));
	
	% Extraction of the longitunal difference between the reference and the actual trajectories
	long_traj=dot((coordinates1(ii,:)-coordinates0(ii,:))',unit_speed_vector(ii,velocity1));
	
	% Extraction of the latitude and the longitude differences of seeing Jupiter from the reference and actual trajectories
	lat_angle=lat1(ii)-lat0(ii);
	long_angle=long1(ii)-long0(ii);

	% Extraction of transversal error :
	trans_err=norm(cross(diff(1:3),unit_speed_vector(ii,velocity1)));

	% Extraction of longitudinal error :
	long_err=dot(diff(1:3),unit_speed_vector(ii,velocity1));

	% Extraction of rectilinearity of the speed
	speed_angle=atan2(norm(cross(velocity1(ii,:), velocity1(ii+timeStep(1)+timeStep(2)+timeStep(3),:))), dot(velocity1(ii,:), velocity1(ii+timeStep(1)+timeStep(2)+timeStep(3),:)))*180/pi;

	% Extraction of uniformity of the speed
	norme=(norm(velocity1(ii,:))-norm(velocity1(ii+timeStep(1)+timeStep(2)+timeStep(3),:)));
	
	% Extraction of the rank of the A matrix
	A_rank=rank(A);
	
	% Extraction of the 3 next dates of the pictures
	date=[TimeList1(ii+timeStep(1))-MJD_0,TimeList1(ii+timeStep(1)+timeStep(2))-MJD_0,TimeList1(ii+timeStep(1)+timeStep(2)+timeStep(3))-MJD_0];
	
	% Extraction of the CPU time
	CPU=elapsed_time;
	
data=vertcat(data, [day,sec,trans_traj,long_traj,lat_angle,long_angle,trans_err,long_err,speed_angle,norme,A_rank,date,CPU,X']); %we create the matrix using concatenation

endfor

# Creation and redaction of the text-file :

dataExtraction=fopen('dataExtraction','w')

fprintf(dataExtraction,'NAV_Results Version : 1.1\nGenerated by BIRDY NAV TEAM\nDate : %salgo : %s\n\n', ctime(time()), algo);
fprintf(dataExtraction,'OBJECT_NAME : BIRDY\nID_NAME : BIRDY\nSCENARIO : %s\nTRAJECTORY_NAME : %s\n\n',scenario_num, trajectory_name);

fprintf(dataExtraction,'META_START\n\n');

fprintf(dataExtraction,'Time Step :\n');
fprintf(dataExtraction,'%15d%15f\n',T');

fprintf(dataExtraction,'\nSamplings :\n');
fprintf(dataExtraction,'%15d%15d%15d\n',dt');

fprintf(dataExtraction,"\n\nCOLUMN #01 : Day of the date (in MJD)\nCOLUMN #02 : Seconds in the day (in seconds)\nCOLUMN #03 : Transversal difference between the reference and the actual trajectories (in km)\nCOLUMN #04 : Longitudinal difference between the reference and the actual trajectories (in km)\nCOLUMN #05 : Latitude difference of Jupiter between the reference trajectory point of view and the actual trajectory one (in degrees)\nCOLUMN #06 : Longitude difference of Jupiter between the reference trajectory point of view and the actual trajectory one(in degrees)\nCOLUMN #07 : Transversal Error (in km)\nCOLUMN #08 : Longitudinal Error (in km)\nCOLUMN #09 : Rectilinearity of speed (in degrees)\nCOLUMN #10 : Uniformity of speed (in m/s)\nCOLUMN #11 : Rank of A\nCOLUMN #12 : date 2 (in seconds)\nCOLUMN #13 : date 3 (in seconds)\nCOLUMN #14 : date 4 (in seconds)\nCOLUMN #15 : performance (in CPU seconds)\nCOLUMN #16 to #34 : Vector X\n\n");

	fprintf(dataExtraction,"1");
for i = 2 : 34
	fprintf(dataExtraction,"%15d",i);
endfor

fprintf(dataExtraction,'\nMETA_STOP\n');

fprintf(dataExtraction, "%0.3d%15.3f%15.3f%15.3f%15.3f%15.3f%15.3f%15.3f%15.3f%15.3e%15.3f%15.3f%15.3f%15.3f%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e%15.3e\n",data');

fclose(dataExtraction)

edit dataExtraction

#We rename and replace the result file, if it already exists, the new file overwrites the old one.

new_name = strcat('results_',scenario_num,'_1.0');
rename('dataExtraction',new_name);
movefile(new_name,'Results');

#endfor
end