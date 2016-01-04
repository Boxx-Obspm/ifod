%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet & Oussema SLEIMI
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program calculate C and D (cf technical note Nav-002 for more details)
%
% 1. Input:
%     TimeList = 4x1 vector variable that gives the date corresponding at each point of the trajectory
%     lat0     = 4x1 vector variable that gives the latitude of the astral body observed from the reference trajectory
%     long0    = 4x1 vector variable variable that gives the longitude of the astral body observed from the reference trajectory
%     distance0= 4x1 vector variable that gives the distance of the astral body observed from the reference trajectory


% 2. Outputs:
%     C =  21x19 double float Matrix that contains measures from reference trajectory 
%     D =  21x8 double float Matrix that contains measures from reference trajectory 
     
function[C,D]= Calculation_C_D(TimeList,lat0,long0,distance0)

    
t1=TimeList(1);
t2=TimeList(2);
t3=TimeList(3);
t4=TimeList(4);

% we convert Julian Day into time in second
dt2=(t2-t1)*86400; %dt2 is the time between the first and second measurment.
dt3=(t3-t2)*86400; %dt3 is the time between the second and third measurment.
dt4=(t4-t3)*86400; %dt4 is the time between the third and fourth measurment.

r01=distance0(1); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t1.
r02=distance0(2); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t2.
r03=distance0(3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t3.
r04=distance0(4); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t4.

l01=degtorad(lat0(1)); %latitude at the instant t1 (radian)
L01=degtorad(long0(1)); %longitude at the instant t1 (radian)
l02=degtorad(lat0(2));%latitude at the instant t2 (radian)
L02=degtorad(long0(2));%longitude at the instant t2 (radian)
l03=degtorad(lat0(3));%latitude at the instant t3 (radian)
L03=degtorad(long0(3));%longitude at the instant t3 (radian)
l04=degtorad(lat0(4));%latitude at the instant t4 (radian)
L04=degtorad(long0(4));%longitude at the instant t4 (radian)

CC11=cos(l01)*cos(L01);
CS11=cos(l01)*sin(L01);
SS11=sin(l01)*sin(L01);
S11=sin(l01);
C11=cos(l01);

CC12=cos(l02)*cos(L02);
CS12=cos(l02)*sin(L02);
SS12=sin(l02)*sin(L02);
S12=sin(l02);
C12=cos(l02);

CC13=cos(l03)*cos(L03);
CS13=cos(l03)*sin(L03);
SS13=sin(l03)*sin(L03);
S13=sin(l03);
C13=cos(l03);

CC14=cos(l04)*cos(L04);
CS14=cos(l04)*sin(L04);
SS14=sin(l04)*sin(L04);
S14=sin(l04);
C14=cos(l04);



C=[ 1, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, CC11,   0,    0,    0,   0,   0,   0;
    0, 1, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, CS11,   0,    0,    0,   0,   0,   0;
    0, 0, 1,  0,  0,  0,  0,  0,  0,  0,  0,  0, S11,    0,    0,    0,   0,   0,   0;
    0, 0, 0,  1,  0,  0,  0,  0,  0,  0,  0,  0,   0, CC12,    0,    0,   0,   0,   0;
    0, 0, 0,  0,  1,  0,  0,  0,  0,  0,  0,  0,   0, CS12,    0,    0,   0,   0,   0;
    0, 0, 0,  0,  0,  1,  0,  0,  0,  0,  0,  0,   0, S12,     0,    0,   0,   0,   0;
    0, 0, 0,  0,  0,  0,  1,  0,  0,  0,  0,  0,   0,    0, CC13,    0,   0,   0,   0;
    0, 0, 0,  0,  0,  0,  0,  1,  0,  0,  0,  0,   0,    0, CS13,    0,   0,   0,   0;
    0, 0, 0,  0,  0,  0,  0,  0,  1,  0,  0,  0,   0,    0,  S13,    0,   0,   0,   0;
    0, 0, 0,  0,  0,  0,  0,  0,  0,  1,  0,  0,   0,    0,    0, CC14,   0,   0,   0;
    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  1,  0,   0,    0,    0, CS14,   0,   0,   0;
    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  1,   0,    0,    0,  S14,   0,   0,   0;
    1, 0, 0, -1,  0,  0,  0,  0,  0,  0,  0,  0,   0,    0,    0,    0, dt2,   0,   0;
    0, 1, 0,  0, -1,  0,  0,  0,  0,  0,  0,  0,   0,    0,    0,    0,   0, dt2,   0;
    0, 0, 1,  0,  0, -1,  0,  0,  0,  0,  0,  0,   0,    0,    0,    0,   0,   0, dt2;
    0, 0, 0,  1,  0,  0, -1,  0,  0,  0,  0,  0,   0,    0,    0,    0, dt3,   0,   0;
    0, 0, 0,  0,  1,  0,  0, -1,  0,  0,  0,  0,   0,    0,    0,    0,   0, dt3,   0;
    0, 0, 0,  0,  0,  1,  0,  0, -1,  0,  0,  0,   0,    0,    0,    0,   0,   0, dt3;
    0, 0, 0,  0,  0,  0,  1,  0,  0, -1,  0,  0,   0,    0,    0,    0, dt4,   0,   0;
    0, 0, 0,  0,  0,  0,  0,  1,  0,  0, -1,  0,   0,    0,    0,    0,   0, dt4,   0;
    0, 0, 0,  0,  0,  0,  0,  0,  1,  0,  0, -1,   0,    0,    0,    0,   0,   0, dt4];

D=[ r01*CS11,r01*CC11, 0       ,0       ,0        ,0       ,0        ,0        ;
   -r01*CC11,r01*SS11, 0       ,0       ,0        ,0       ,0        ,0        ;
    0       ,-r01*C11, 0       ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       , r02*CS12,r02*CC12,0        ,0       ,0        ,0        ;
    0       ,0       ,-r02*CC12,r02*SS12,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,-r02*C12,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       , r03*CS13,r03*CC13,0        ,0        ;
    0       ,0       ,0        ,0       ,-r03*CC13,r03*SS13,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,-r03*C13,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       , r04*CS14,r04*CC14 ;
    0       ,0       ,0        ,0       ,0        ,0       ,-r04*CC14,r04*SS14 ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,-r04*C14 ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ;
    0       ,0       ,0        ,0       ,0        ,0       ,0        ,0        ];
end