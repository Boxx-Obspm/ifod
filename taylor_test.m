clear
clc
#scenario=fopen('./Inputs/Scenarios/scenario-0','r'); #we open the scenario file
scenario=fopen('./Inputs/Scenarios/scenario-1','r'); #we open the scenario file
#scenario=fopen('./Inputs/Scenarios/scenario-2','r'); #we open the scenario file
#scenario=fopen('./Inputs/Scenarios/scenario-3','r'); #we open the scenario file
#scenario=fopen('./Inputs/Scenarios/scenario-4','r'); #we open the scenario file
#scenario=fopen('./Inputs/Scenarios/scenario-5','r'); #we open the scenario file
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

[TimeList1,lat1,long1,distance1,coordinates1,velocity1]=actual_trajectory(trajectory_name,trajectory_name_ephjup);
[TimeList0,lat0,long0,distance0,coordinates0,velocity0]=reference_trajectory();

ii_max=length(TimeList1);
ii=fix(rand*ii_max)

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

	[timeStep]=time_step(ii,T,dt,trajectory_name,trajectory_name_ephjup);
	[TimeList,lat0,long0,distance0,lat1,long1]=on_board_interpolation(ii,timeStep,trajectory_name,trajectory_name_ephjup)
	[dr,Dvectr,Dvelocity]=test_interpolation(ii,timeStep,trajectory_name,trajectory_name_ephjup)
	[Xexp]=Calculate_Xexpected(dr, Dvectr, Dvelocity)
	
l01=degtorad(lat0(1)); %latitude at the instant t1 (radian)
L01=degtorad(long0(1)); %longitude at the instant t1 (radian)

l1=degtorad(lat1(1)); %latitude at the instant t1 (radian)
L1=degtorad(long1(1)); %longitude at the instant t1 (radian)

dl1=l1-l01;   

dL1=L1-L01;

r01=distance0(1);
	
C=[1 0 0 cos(l01)*cos(L01); 0 1 0 cos(l01)*sin(L01); 0 0 1 sin(l01)]
D=[r01*cos(l01)*sin(L01) r01*cos(L01)*sin(l01); -r01*cos(l01)*cos(L01) r01*sin(l01)*sin(L01); 0 -r01*cos(l01)]
Z=[dL1;dl1]
Xexp=[Xexp(1);Xexp(2);Xexp(3);Xexp(13)]
X=pinv(C)*D*Z

diff=C*X-C*Xexp