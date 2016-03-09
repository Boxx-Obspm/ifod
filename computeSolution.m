%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  Vxxx dd-mm-2016
%                  - re-written from annul_grad, Calculation_C_D, Calculation_Y_Z
%                  - inputs: 4 observables and predictions only
%                  V2.1 03-03-2016 (dd-mm-yyyy) Boris Segret
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
%CL=1
%
% ifod algorithm: <reconstructed_shift> is estimated from the on-board measured
% directions of a foreground body compared with the expected directions.
%
% Inputs:
%     et = 4x1, double matrix, 4 epoch times (in decimal days)
%     o  = 4x2, double matrix, 4 observables (lat,long) in deg (algorithm with 4 obs)
%     p  = 4x3, double matrix, 4 predictions (lat, long, distance) in  (deg,deg,km)
%     m  = string, method used [PINV|FMIN|MC|SD]
% Outputs:
%     X  = 19x1  double float vector giving the p-vector solution of the problem
%     A  = 19x19 double float vector giving the pxp-matrix A (cf NAv-002 for more details).
%     B  = 1x19 double float vector giving the p-vector B (cf NAv-002 for more details).
%     cd = computation duration

function [X,A,B,cd] = computeSolution (et,o,p,algo)
%we call the needed sub-programs to operate this one.

[C,D] = Calculation_CD(et, p);
[Y]   = Calculation_YZ(p(:,1:2), o, D);

%we calculate the matrix A.
m=21;
 for k=1:19
     for j=1:19
         s=0;
         p=0;
         for i=1:m
             s=C(i,k)*C(i,j);
             p=p+s;
         end
         p=2*p;
         A(k,j)=p;
     end
 end

%we calculate the matrix B.
for k=1:19
    s=0;
    p=0;
 for i=1:m
    s=C(i,k)*Y(i);
    p=p+s;
 end
 p=-2*p;
 B(k)=p;
end

% #scale matrix
% 
% #S=[ 1, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0,   0,    0,    0,   0,   0,   0;
% #    0, 1, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0,   0,    0,    0,   0,   0,   0;
% #  0, 0, 1,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0,    0,    0,    0,   0,   0,   0;
% #    0, 0, 0,  1,  0,  0,  0,  0,  0,  0,  0,  0,   0, 0,    0,    0,   0,   0,   0;
% #    0, 0, 0,  0,  1,  0,  0,  0,  0,  0,  0,  0,   0, 0,    0,    0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  1,  0,  0,  0,  0,  0,  0,   0, 0,     0,    0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  1,  0,  0,  0,  0,  0,   0,    0, 0,    0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  1,  0,  0,  0,  0,   0,    0, 0,    0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  1,  0,  0,  0,   0,    0,  0,    0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  0,  1,  0,  0,   0,    0,    0, 0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  1,  0,   0,    0,    0, 0,   0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  1,   0,    0,    0,  0,   0,   0,   0;
% #    0, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,   1,    0,    0,    0, 0,   0,   0;
% #    0, 0, 0,  0, 0,  0,  0,  0,  0,  0,  0,  0,   0,    1,    0,    0,   0, 0,   0;
% #    0, 0, 0,  0,  0, 0,  0,  0,  0,  0,  0,  0,   0,    0,    1,    0,   0,   0, 0;
% #    0, 0, 0,  0,  0,  0, 0,  0,  0,  0,  0,  0,   0,    0,    0,    1, 0,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  0, 0,  0,  0,   0,    0,    0,    0, 1/1000,   0,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  0,  0, 0,  0,   0,    0,    0,    0,   0, 1/1000,   0;
% #    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0, 0,   0,    0,    0,    0,   0,   0, 1/1000];

t=cputime;
switch (algo)
	case 'PINV'	%we solve the problem by inversion.
   X=pinv(A)*(-B');
  otherwise
%  X=pinv(S*A)*S*(-B');
 
%	case 'FMIN'	%we solve the problem by using fminunc
 	
%	case 'MC'
 	
%	case 'SD' 	
end
cd=cputime-t;

end

%%------------------------------------------------------------------------------
% internal functions
% Calculation_CD
% Calculation_YZ
%%------------------------------------------------------------------------------

function [C,D] = Calculation_CD (et, p)
% et: epoch times, 4x1 double
% p : predicted trajectory (lat, long, dist), 4x3 double, in (deg,deg,km)
% C, D: matrices defined in NAV-002

% we convert Julian Day into time in seconds
% ==> WHY?!?
dt2=(et(2)-et(1))*86400; %dt2 is the time between the first and second measurment.
dt3=(et(3)-et(2))*86400; %dt3 is the time between the second and third measurment.
dt4=(et(4)-et(3))*86400; %dt4 is the time between the third and fourth measurment.

r01=p(1,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t1.
r02=p(2,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t2.
r03=p(3,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t3.
r04=p(4,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t4.

l01=p(1,1)*pi/180.; %latitude at the instant t1 (radian)
L01=p(1,2)*pi/180.; %longitude at the instant t1 (radian)
l02=p(2,1)*pi/180.; %latitude at the instant t2 (radian)
L02=p(2,2)*pi/180.; %longitude at the instant t2 (radian)
l03=p(3,1)*pi/180.; %latitude at the instant t3 (radian)
L03=p(3,2)*pi/180.; %longitude at the instant t3 (radian)
l04=p(4,1)*pi/180.; %latitude at the instant t4 (radian)
L04=p(4,2)*pi/180.; %longitude at the instant t4 (radian)

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

%%------------------------------------------------------------------------------

%function[Y]= Calculation_YZ(lat0,long0,lat1, long1,D)
function [Y] = Calculation_YZ (pdir, odir, D)
% pdir: predicetd directions, 4x2 double in deg
% odir: observed directions, 4x2 double in deg
% D: matrix as defined in NAV-002
% Y: matrix defined in NAV-002

l01=pdir(1,1)*pi/180.; %latitude at the instant t1 (radian)
L01=pdir(1,2)*pi/180.; %longitude at the instant t1 (radian)
l02=pdir(2,1)*pi/180.; %latitude at the instant t2 (radian)
L02=pdir(2,2)*pi/180.; %longitude at the instant t2 (radian)
l03=pdir(3,1)*pi/180.; %latitude at the instant t3 (radian)
L03=pdir(3,2)*pi/180.; %longitude at the instant t3 (radian)
l04=pdir(4,1)*pi/180.; %latitude at the instant t4 (radian)
L04=pdir(4,2)*pi/180.; %longitude at the instant t4 (radian)

%% Data measured by the planet tracker

l1=odir(1,1)*pi/180.; %latitude at the instant t1 (radian)
L1=odir(1,2)*pi/180.; %longitude at the instant t1 (radian)
l2=odir(2,1)*pi/180.;%latitude at the instant t2 (radian)
L2=odir(2,2)*pi/180.;%longitude at the instant t2 (radian)
l3=odir(3,1)*pi/180.;%latitude at the instant t3 (radian)
L3=odir(3,2)*pi/180.;%longitude at the instant t3 (radian)
l4=odir(4,1)*pi/180.;%latitude at the instant t4 (radian)
L4=odir(4,2)*pi/180.;%longitude at the instant t4 (radian)


%% Definition of Z and Y
dl1=l1-l01;   
dl2=l2-l02;
dl3=l3-l03;
dl4=l4-l04;
dL1=L1-L01;
dL2=L2-L02;
dL3=L3-L03;
dL4=L4-L04;

Z=[dL1;dl1;dL2;dl2;dL3;dl3;dL4;dl4];
Y=D*Z;
end
