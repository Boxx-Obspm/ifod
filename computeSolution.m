%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  Vxxx dd-mm-2016
%                  - new notations for A and B matrices (tech.note 2016)
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
%     et   = 4x1, double matrix, 4 epoch times (in decimal days)
%     ob   = 4x2, double matrix, 4 observables (lat,long trigo) in deg (algorithm with 4 obs)
%     pr   = 4x3, double matrix, 4 predictions (lat, long trigo, distance) in  (deg,deg,km)
%     algo = string, method used [PINV|FMIN|MC|SD]
% Outputs:
%     X  = 19x1  double float p-vector as solution of the problem (in km and km/s)
%     A  = 19x19 double float vector giving the pxp-matrix A (cf NAv-002 for more details).
%     B  = 1x19 double float vector giving the p-vector B (cf NAv-002 for more details).
%     cd = CPU duration for the inversion itself (decimal milliseconds)
% Included subfunctions:
%     Calculation_CD
%     Calculation_YZ

function [X,A,B,cd] = computeSolution (et, ob, pr, algo)

tci=cputime();

[C,D] = Calculation_CD(et, pr);
[Y]   = Calculation_YZ(pr(:,1:2), ob, D);

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
         %p=2*p; % notations 2016
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
 %p=-2*p; % notations 2016
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

switch (algo)
    case 'PINV'	%we solve the problem by inversion.
    %X=pinv(A)*(-B');
    X=pinv(A)*(B'); % notations 2016
    otherwise
    %	case 'FMIN'	%we solve the problem by using fminunc

    %	case 'MC'

    %	case 'SD' 	
end
tcf=cputime();
cd=(tcf-tci)*1000.; % CPU time in milliseconds
end

%%------------------------------------------------------------------------------
% internal functions
% > Calculation_CD
% > Calculation_YZ
%%------------------------------------------------------------------------------

function [C,D] = Calculation_CD (et, pr)
% et: epoch times (in decimal Julian dates), 4x1 double
% pr : predicted trajectory (lat, long, dist), 4x3 double, in (deg,deg,km)
% C, D: matrices defined in NAV-002
%       > matrix C has no units or seconds for time parameters
%       > matrix D has no units or km for coordinates and distances parameters

% we convert Julian Days into time in seconds
dt2=(et(2)-et(1))*86400.; %dt2 is the time between the first and second measurement.
dt3=(et(3)-et(2))*86400.; %dt3 is the time between the second and third measurement.
dt4=(et(4)-et(3))*86400.; %dt4 is the time between the third and fourth measurement.

r01=pr(1,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t1.
r02=pr(2,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t2.
r03=pr(3,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t3.
r04=pr(4,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t4.

l01=pr(1,1)*pi/180.; %latitude at the instant t1 (radian)
L01=pr(1,2)*pi/180.; %longitude at the instant t1 (radian)
l02=pr(2,1)*pi/180.; %latitude at the instant t2 (radian)
L02=pr(2,2)*pi/180.; %longitude at the instant t2 (radian)
l03=pr(3,1)*pi/180.; %latitude at the instant t3 (radian)
L03=pr(3,2)*pi/180.; %longitude at the instant t3 (radian)
l04=pr(4,1)*pi/180.; %latitude at the instant t4 (radian)
L04=pr(4,2)*pi/180.; %longitude at the instant t4 (radian)

CC1= cos(l01)*cos(L01);
CS1= cos(l01)*sin(L01);
SC1= sin(l01)*cos(L01);
SS1= sin(l01)*sin(L01);
S1 = sin(l01);
C1 = cos(l01);

CC2= cos(l02)*cos(L02);
CS2= cos(l02)*sin(L02);
SC2= sin(l02)*cos(L02);
SS2= sin(l02)*sin(L02);
S2 = sin(l02);
C2 = cos(l02);

CC3= cos(l03)*cos(L03);
CS3= cos(l03)*sin(L03);
SC3= sin(l03)*cos(L03);
SS3= sin(l03)*sin(L03);
S3 = sin(l03);
C3 = cos(l03);

CC4= cos(l04)*cos(L04);
CS4= cos(l04)*sin(L04);
SC4= sin(l04)*cos(L04);
SS4= sin(l04)*sin(L04);
S4 = sin(l04);
C4 = cos(l04);


C=[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CC1,   0,   0,   0,   0,   0,   0;
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CS1,   0,   0,   0,   0,   0,   0;
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,  S1,   0,   0,   0,   0,   0,   0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   0, CC2,   0,   0,   0,   0,   0;
    0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,   0, CS2,   0,   0,   0,   0,   0;
    0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,   0,  S2,   0,   0,   0,   0,   0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,   0,   0, CC3,   0,   0,   0,   0;
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,   0,   0, CS3,   0,   0,   0,   0;
    0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,   0,   0,  S3,   0,   0,   0,   0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,   0,   0,   0, CC4,   0,   0,   0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,   0,   0,   0, CS4,   0,   0,   0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,   0,   0,   0,  S4,   0,   0,   0;
    1, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0,   0,   0,   0,   0, dt2,   0,   0;
    0, 1, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0,   0,   0,   0,   0,   0, dt2,   0;
    0, 0, 1, 0, 0,-1, 0, 0, 0, 0, 0, 0,   0,   0,   0,   0,   0,   0, dt2;
    0, 0, 0, 1, 0, 0,-1, 0, 0, 0, 0, 0,   0,   0,   0,   0, dt3,   0,   0;
    0, 0, 0, 0, 1, 0, 0,-1, 0, 0, 0, 0,   0,   0,   0,   0,   0, dt3,   0;
    0, 0, 0, 0, 0, 1, 0, 0,-1, 0, 0, 0,   0,   0,   0,   0,   0,   0, dt3;
    0, 0, 0, 0, 0, 0, 1, 0, 0,-1, 0, 0,   0,   0,   0,   0, dt4,   0,   0;
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0,-1, 0,   0,   0,   0,   0,   0, dt4,   0;
    0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,-1,   0,   0,   0,   0,   0,   0, dt4];

D=[ r01*CS1, r01*SC1, 0      , 0      , 0      , 0      , 0      , 0      ;
   -r01*CC1, r01*SS1, 0      , 0      , 0      , 0      , 0      , 0      ;
    0      ,-r01*C1 , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , r02*CS2, r02*SC2, 0      , 0      , 0      , 0      ;
    0      , 0      ,-r02*CC2, r02*SS2, 0      , 0      , 0      , 0      ;
    0      , 0      , 0      ,-r02*C2 , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , r03*CS3, r03*SC3, 0      , 0      ;
    0      , 0      , 0      , 0      ,-r03*CC3, r03*SS3, 0      , 0      ;
    0      , 0      , 0      , 0      , 0      ,-r03*C3 , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , r04*CS4, r04*SC4;
    0      , 0      , 0      , 0      , 0      , 0      ,-r04*CC4, r04*SS4;
    0      , 0      , 0      , 0      , 0      , 0      , 0      ,-r04*C4 ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
    0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ];
end

%%------------------------------------------------------------------------------

function [Y] = Calculation_YZ (pdir, odir, D)
% pdir: predicted directions, 4x2 double in deg
% odir: observed directions, 4x2 double in deg
% D: matrix as defined in NAV-002
% Y: matrix as defined in NAV-002

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
dL1=mod(pi()+L1-L01, 2*pi())-pi();
dL2=mod(pi()+L2-L02, 2*pi())-pi();
dL3=mod(pi()+L3-L03, 2*pi())-pi();
dL4=mod(pi()+L4-L04, 2*pi())-pi();

Z=[dL1;dl1;dL2;dl2;dL3;dl3;dL4;dl4];
Y=D*Z;
end
