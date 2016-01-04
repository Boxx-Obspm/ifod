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

ii_max=length(TimeList1);
#ii=fix(rand*ii_max)

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
[TimeList0,~,~,distance0,coordinates0,velocity0]=reference_trajectory(); % we call this function to get the needed inputs from the reference trajectory.

TimeList     =[TimeList1(ii);TimeList1(ii+timeStep(1));TimeList1(ii+timeStep(1)+timeStep(2));TimeList1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
distance1    =[distance1(ii);distance1(ii+timeStep(1));distance1(ii+timeStep(1)+timeStep(2));distance1(ii+timeStep(1)+timeStep(2)+timeStep(3))];
coordinates1 =[coordinates1(ii,:);coordinates1(ii+timeStep(1),:);coordinates1(ii+timeStep(1)+timeStep(2),:);coordinates1(ii+timeStep(1)+timeStep(2)+timeStep(3),:)];
velocity1    =[velocity1(ii,:);velocity1(ii+timeStep(1),:);velocity1(ii+timeStep(1)+timeStep(2),:);velocity1(ii+timeStep(1)+timeStep(2)+timeStep(3),:)];

i=1+sum((TimeList0<TimeList(1)));                                                                                                                        %
if (i==1)
i=2;
endif                                                                                                                                                         %                                                  

vx0_1       =velocity0(i-1,1)   +(TimeList(1)-TimeList0(i-1))*(velocity0(i,1)-velocity0(i-1,1))      /(TimeList0(i)-TimeList0(i-1));                     %
vy0_1       =velocity0(i-1,2)   +(TimeList(1)-TimeList0(i-1))*(velocity0(i,2)-velocity0(i-1,2))      /(TimeList0(i)-TimeList0(i-1));                     %
vz0_1       =velocity0(i-1,3)   +(TimeList(1)-TimeList0(i-1))*(velocity0(i,3)-velocity0(i-1,3))      /(TimeList0(i)-TimeList0(i-1));                     %                                                                                                                                                        

i=1+sum((TimeList0<TimeList(2)));                                                                                                                        %
if (i==1)
i=2;
endif                                                                                                                                                       %

vx0_2       =velocity0(i-1,1)   +(TimeList(2)-TimeList0(i-1))*(velocity0(i,1)-velocity0(i-1,1))      /(TimeList0(i)-TimeList0(i-1));                     %
vy0_2       =velocity0(i-1,2)   +(TimeList(2)-TimeList0(i-1))*(velocity0(i,2)-velocity0(i-1,2))      /(TimeList0(i)-TimeList0(i-1));                     %
vz0_2       =velocity0(i-1,3)   +(TimeList(2)-TimeList0(i-1))*(velocity0(i,3)-velocity0(i-1,3))      /(TimeList0(i)-TimeList0(i-1));                     %

i=1+sum((TimeList0<TimeList(3)));
if (i==1)
i=2;
endif
vx0_3       =velocity0(i-1,1)   +(TimeList(3)-TimeList0(i-1))*(velocity0(i,1)-velocity0(i-1,1))      /(TimeList0(i)-TimeList0(i-1));
vy0_3       =velocity0(i-1,2)   +(TimeList(3)-TimeList0(i-1))*(velocity0(i,2)-velocity0(i-1,2))      /(TimeList0(i)-TimeList0(i-1));
vz0_3       =velocity0(i-1,3)   +(TimeList(3)-TimeList0(i-1))*(velocity0(i,3)-velocity0(i-1,3))      /(TimeList0(i)-TimeList0(i-1));

i=1+sum((TimeList0<TimeList(4)));
if (i==1)
i=2; 
endif

vx0_4       =velocity0(i-1,1)   +(TimeList(4)-TimeList0(i-1))*(velocity0(i,1)   -velocity0(i-1,1))   /(TimeList0(i)-TimeList0(i-1));                     %
vy0_4       =velocity0(i-1,2)   +(TimeList(4)-TimeList0(i-1))*(velocity0(i,2)   -velocity0(i-1,2))   /(TimeList0(i)-TimeList0(i-1));                     %
vz0_4       =velocity0(i-1,3)   +(TimeList(4)-TimeList0(i-1))*(velocity0(i,3)   -velocity0(i-1,3))   /(TimeList0(i)-TimeList0(i-1));                     %


velocity0=[vx0_1 vy0_1 vz0_1;vx0_2 vy0_2 vz0_2;vx0_3 vy0_3 vz0_3;vx0_4 vy0_4 vz0_4];% velocity0 is the interpolation at 4 different time of the reference trajectory of BIRDY's velocity. 

speed_angle=atan2(norm(cross(velocity0(1,:), velocity0(4,:))), dot(velocity0(1,:), velocity0(4,:)))*180/pi
norme=norm(velocity0(1,:))-norm(velocity0(4,:))