%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  V2.3.1 17-03-2017
%                  - means added for debug & cpu performance monitoring
%                  V2.3 09-08-2016
%                  - Adaptations for N=5 measurements
%                  - Dimensionless calculation
%                  V2.2 02-04-2016
%                  - fix bugs (CSi vs. SCi for matrix D)
%                  - fix bugs (in Y computation to consider "modulo")
%                  - new notations for A and B matrices (tech.note 2016)
%                  - inputs: 4 observables and predictions only
%                  (re-written from annul_grad, Calculation_C_D, Calculation_Y_Z)
%                  V2.1 03-03-2016 (dd-mm-yyyy) Boris Segret
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
%CL=0
%
% ifod algorithm: <reconstructed_shift> (X) is estimated from the on-board measured
% directions of foreground bodies compared with the expected directions of these bodies.
%
% Inputs:
%            (N: number of measurements)
%     et   = Nx1, double matrix, N epoch times (in decimal days)
%     ob   = Nx2, double matrix, N observables (lat,long trigo) in deg
%     pr   = Nx3, double matrix, N predictions (lat, long trigo, distance) in  (deg,deg,km)
%     algo = string, method used [PINV|FMIN|MC|SD]
% Outputs:
%     X  = p x 1 (N=5=>p=26)  double float p-vector as solution of the problem (in km and km/s)
%     A  = p x p double float vector giving the (p x p)-matrix A (cf NAv-002 for more details).
%     B  = 1 x p double float vector giving the p-vector B (cf NAv-002 for more details).
%     cd = CPU duration for the inversion itself (decimal milliseconds)
% Included subfunctions:
%     Calculation_CD
%     Calculation_YZ

function [X,A,B,cd] = computeSolution (et, ob, pr, algo)
N = 5; % Nb.of measurements
% m = 6*N-3;
% p = 4*N+6;
% tci=cputime(); % intitialization of CPU time measurement
tci=toc; % intitialization of CPU time measurement

[C,D] = Calculation_CD(et, pr);
[Y]   = Calculation_YZ(pr(:,1:2), ob, D);

% matrix A:
A = C'*C;
% A=zeros(p,p);
% for k=1:p
%     for j=1:p
%         for i=1:m
%             A(k,j) = A(k,j) + C(i,k)*C(i,j);
%         end
%     end
% end
% to check, evaluate (F9) this:
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',A');

% matrix B:
B = Y'*C;
% B=zeros(1,p);
% for k=1:p
%     for i=1:m
%         B(k) = B(k) + C(i,k)*Y(i);
%     end
% end
% to check, evaluate (F9) this:
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',B');

switch (algo)
    case 'PINV'	%we solve the problem by inversion.
    %X=pinv(A)*(-B');
    adimX=pinv(A)*(B'); % notations 2016
    otherwise
    %	case 'FMIN'	%we solve the problem by using fminunc

    %	case 'MC' % Monte Carlo => cannot be covered aat this level (in upper algorithm)

    %	case 'SD' % sttepest descent => to come later
end

% back to X with dimensions:
Tmax = et(N)-et(1);
invU = blkdiag(pr(1,3).*eye(3), pr(2,3).*eye(3), pr(3,3).*eye(3), pr(4,3).*eye(3), pr(5,3).*eye(3), ...
    pr(1,3), pr(2,3), pr(3,3), pr(4,3), pr(5,3), ...
    (pr(1,3)./Tmax).*eye(3), (pr(1,3)./(Tmax.^2)).*eye(3));
X = invU * adimX;

% tcf=cputime();
tcf=toc;
cd=(tcf-tci)*1000.; % CPU time in milliseconds
%     fprintf('(ifod_kf) Inversion: %5.2f ms, ', cd);
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

N = 5; % Nb.of measurements
% m = 6*N-3;
% p = 4*N+6;

% we convert Julian Days into time in seconds
Tmax = et(N)-et(1);
% dimensionless dt
dt(1:N) = (et(1:N)-et(1))./Tmax; % new algorithm with N=5 (dt(1)=0)
% dt2=(et(2)-et(1))*86400.; %dt2 is the time between the first and second measurement.
% dt3=(et(3)-et(2))*86400.; %dt3 is the time between the second and third measurement.
% dt4=(et(4)-et(3))*86400.; %dt4 is the time between the third and fourth measurement.

% dimensionless (1/rhoE)=rhoE_ini/rhoE_j
invrhoE(1:N)=pr(1,3)./pr(1:N,3); % expected distances (km) of the foreground objects
% r01=pr(1,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t1.
% r02=pr(2,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t2.
% r03=pr(3,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t3.
% r04=pr(4,3); %distance (in km) between Birdy(ideal location)  and Jupiter at the instant of measurement t4.

phiE(1:N)=pr(1:N,1)*pi/180.; % expected latitudes (radian) of the foreground objects
lamE(1:N)=pr(1:N,2)*pi/180.; % expected longitudes (radian) of the foreground objects
% l01=pr(1,1)*pi/180.; %latitude at the instant t1 (radian)
% L01=pr(1,2)*pi/180.; %longitude at the instant t1 (radian)
% l02=pr(2,1)*pi/180.; %latitude at the instant t2 (radian)
% L02=pr(2,2)*pi/180.; %longitude at the instant t2 (radian)
% l03=pr(3,1)*pi/180.; %latitude at the instant t3 (radian)
% L03=pr(3,2)*pi/180.; %longitude at the instant t3 (radian)
% l04=pr(4,1)*pi/180.; %latitude at the instant t4 (radian)
% L04=pr(4,2)*pi/180.; %longitude at the instant t4 (radian)

% it is useless to convert in radians above, just use cosd and sind below instead
CC(1:N) = cos(phiE(1:N)).*cos(lamE(1:N));
CS(1:N) = cos(phiE(1:N)).*sin(lamE(1:N));
SC(1:N) = sin(phiE(1:N)).*cos(lamE(1:N));
SS(1:N) = sin(phiE(1:N)).*sin(lamE(1:N));
Cj(1:N) = cos(phiE(1:N));
Sj(1:N) = sin(phiE(1:N));

% CC1= cos(l01)*cos(L01);
% CS1= cos(l01)*sin(L01);
% SC1= sin(l01)*cos(L01);
% SS1= sin(l01)*sin(L01);
% S1 = sin(l01);
% C1 = cos(l01);

% CC2= cos(l02)*cos(L02);
% CS2= cos(l02)*sin(L02);
% SC2= sin(l02)*cos(L02);
% SS2= sin(l02)*sin(L02);
% S2 = sin(l02);
% C2 = cos(l02);

% CC3= cos(l03)*cos(L03);
% CS3= cos(l03)*sin(L03);
% SC3= sin(l03)*cos(L03);
% SS3= sin(l03)*sin(L03);
% S3 = sin(l03);
% C3 = cos(l03);

% CC4= cos(l04)*cos(L04);
% CS4= cos(l04)*sin(L04);
% SC4= sin(l04)*cos(L04);
% SS4= sin(l04)*sin(L04);
% S4 = sin(l04);
% C4 = cos(l04);

% P is a (3N)x(N) matrix
P = [CC(1), 0, 0, 0, 0;...
     CS(1), 0, 0, 0, 0;...
     Sj(1), 0, 0, 0, 0;...
     0, CC(2), 0, 0, 0;...
     0, CS(2), 0, 0, 0;...
     0, Sj(2), 0, 0, 0;...
     0, 0, CC(3), 0, 0;...
     0, 0, CS(3), 0, 0;...
     0, 0, Sj(3), 0, 0;...
     0, 0, 0, CC(4), 0;...
     0, 0, 0, CS(4), 0;...
     0, 0, 0, Sj(4), 0;...
     0, 0, 0, 0, CC(5);...
     0, 0, 0, 0, CS(5);...
     0, 0, 0, 0, Sj(5)];

% dimensionless deltaR is a (3(N-1))x(3N) matrix
% deltaR = [-eye(3),eye(3),zeros(3,9);...
%           -eye(3),zeros(3,3),eye(3),zeros(3,6);...
%           -eye(3),zeros(3,6),eye(3),zeros(3,3);...
%           -eye(3),zeros(3,9),eye(3)];
deltaR = [[-invrhoE(2).*eye(3);...
           -invrhoE(3).*eye(3);...
           -invrhoE(4).*eye(3);...
           -invrhoE(5).*eye(3)] eye(12)];

% dimensionless deltaJ is a (3(N-1))x(6) matrix
% deltaJ = [dt(2).*eye(3), 0.5.*(dt(2).^2).*eye(3);...
%           dt(3).*eye(3), 0.5.*(dt(3).^2).*eye(3);...
%           dt(4).*eye(3), 0.5.*(dt(4).^2).*eye(3);...
%           dt(5).*eye(3), 0.5.*(dt(5).^2).*eye(3)];
deltaJ = [dt(2).*invrhoE(2).*eye(3), 0.5.*(dt(2).^2).*invrhoE(2).*eye(3);...
          dt(3).*invrhoE(3).*eye(3), 0.5.*(dt(3).^2).*invrhoE(3).*eye(3);...
          dt(4).*invrhoE(4).*eye(3), 0.5.*(dt(4).^2).*invrhoE(4).*eye(3);...
          dt(5).*invrhoE(5).*eye(3), 0.5.*(dt(5).^2).*invrhoE(5).*eye(3)];

% C is a (m x p) matrix, with m=6N-3, p=4N+6
C = [ eye(3*N), P, zeros(3*N,6);...
      deltaR, zeros(3*(N-1),N), -deltaJ];
% to check, evaluate (F9) this:
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',C');

% C=[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CC1,   0,   0,   0,   0,   0,   0;
%     0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CS1,   0,   0,   0,   0,   0,   0;
%     0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,  S1,   0,   0,   0,   0,   0,   0;
%     0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   0, CC2,   0,   0,   0,   0,   0;
%     0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,   0, CS2,   0,   0,   0,   0,   0;
%     0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,   0,  S2,   0,   0,   0,   0,   0;
%     0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,   0,   0, CC3,   0,   0,   0,   0;
%     0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,   0,   0, CS3,   0,   0,   0,   0;
%     0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,   0,   0,  S3,   0,   0,   0,   0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,   0,   0,   0, CC4,   0,   0,   0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,   0,   0,   0, CS4,   0,   0,   0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,   0,   0,   0,  S4,   0,   0,   0;
%     1, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0,   0,   0,   0,   0, dt2,   0,   0;
%     0, 1, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0,   0,   0,   0,   0,   0, dt2,   0;
%     0, 0, 1, 0, 0,-1, 0, 0, 0, 0, 0, 0,   0,   0,   0,   0,   0,   0, dt2;
%     0, 0, 0, 1, 0, 0,-1, 0, 0, 0, 0, 0,   0,   0,   0,   0, dt3,   0,   0;
%     0, 0, 0, 0, 1, 0, 0,-1, 0, 0, 0, 0,   0,   0,   0,   0,   0, dt3,   0;
%     0, 0, 0, 0, 0, 1, 0, 0,-1, 0, 0, 0,   0,   0,   0,   0,   0,   0, dt3;
%     0, 0, 0, 0, 0, 0, 1, 0, 0,-1, 0, 0,   0,   0,   0,   0, dt4,   0,   0;
%     0, 0, 0, 0, 0, 0, 0, 1, 0, 0,-1, 0,   0,   0,   0,   0,   0, dt4,   0;
%     0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,-1,   0,   0,   0,   0,   0,   0, dt4];

% dimensionless Q is a (3N)x(2N) matrix
Q = [ CS(1), SC(1), 0, 0, 0, 0, 0, 0, 0, 0;...
     -CC(1), SS(1), 0, 0, 0, 0, 0, 0, 0, 0;...
     0,     -Cj(1), 0, 0, 0, 0, 0, 0, 0, 0;...
     0, 0,  CS(2), SC(2), 0, 0, 0, 0, 0, 0;...
     0, 0, -CC(2), SS(2), 0, 0, 0, 0, 0, 0;...
     0, 0, 0,     -Cj(2), 0, 0, 0, 0, 0, 0;...
     0, 0, 0, 0,  CS(3), SC(3), 0, 0, 0, 0;...
     0, 0, 0, 0, -CC(3), SS(3), 0, 0, 0, 0;...
     0, 0, 0, 0, 0,     -Cj(3), 0, 0, 0, 0;...
     0, 0, 0, 0, 0, 0,  CS(4), SC(4), 0, 0;...
     0, 0, 0, 0, 0, 0, -CC(4), SS(4), 0, 0;...
     0, 0, 0, 0, 0, 0, 0,     -Cj(4), 0, 0;...
     0, 0, 0, 0, 0, 0, 0, 0,  CS(5), SC(5);...
     0, 0, 0, 0, 0, 0, 0, 0, -CC(5), SS(5);...
     0, 0, 0, 0, 0, 0, 0, 0, 0,     -Cj(5)];
                  
% to check, evaluate (F9) this:
% fprintf('%f %f %f %f %f %f %f %f %f %f \n',Q');

% D is a (6N-3)x(2N) matrix
D = [ Q; zeros(3*(N-1),2*N)];

% D=[ r01*CS1, r01*SC1, 0      , 0      , 0      , 0      , 0      , 0      ;
%    -r01*CC1, r01*SS1, 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      ,-r01*C1 , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , r02*CS2, r02*SC2, 0      , 0      , 0      , 0      ;
%     0      , 0      ,-r02*CC2, r02*SS2, 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      ,-r02*C2 , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , r03*CS3, r03*SC3, 0      , 0      ;
%     0      , 0      , 0      , 0      ,-r03*CC3, r03*SS3, 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      ,-r03*C3 , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , r04*CS4, r04*SC4;
%     0      , 0      , 0      , 0      , 0      , 0      ,-r04*CC4, r04*SS4;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      ,-r04*C4 ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ;
%     0      , 0      , 0      , 0      , 0      , 0      , 0      , 0      ];
end

%%------------------------------------------------------------------------------

function [Y] = Calculation_YZ (pdir, odir, D)
% pdir: predicted directions, 4x2 double in deg
% odir: observed directions, 4x2 double in deg
% D: matrix as defined in NAV-002
% Y: matrix as defined in NAV-002

N = 5; % Nb.of measurements
% m = 6*N-3;
% p = 4*N+6;

dphi(1:N)=(odir(1:N,1)-pdir(1:N,1)).*pi./180.; % shift in latitudes (radian) of the foreground objects
% dlam(1:N)=(odir(1:N,2)-pdir(1:N,2)).*pi./180.; % shift in longitudes (radian) of the foreground objects
dlam(1:N)=(mod(180.+odir(1:N,2)-pdir(1:N,2), 360.)-180.).*pi./180.; % shift in longitudes (radian) of the foreground objects
% reminder: dL4=mod(pi()+L4-L04, 2*pi())-pi();

% l01=pdir(1,1)*pi/180.; %latitude at the instant t1 (radian)
% L01=pdir(1,2)*pi/180.; %longitude at the instant t1 (radian)
% l02=pdir(2,1)*pi/180.; %latitude at the instant t2 (radian)
% L02=pdir(2,2)*pi/180.; %longitude at the instant t2 (radian)
% l03=pdir(3,1)*pi/180.; %latitude at the instant t3 (radian)
% L03=pdir(3,2)*pi/180.; %longitude at the instant t3 (radian)
% l04=pdir(4,1)*pi/180.; %latitude at the instant t4 (radian)
% L04=pdir(4,2)*pi/180.; %longitude at the instant t4 (radian)

%% Data measured by the planet tracker

% l1=odir(1,1)*pi/180.; %latitude at the instant t1 (radian)
% L1=odir(1,2)*pi/180.; %longitude at the instant t1 (radian)
% l2=odir(2,1)*pi/180.;%latitude at the instant t2 (radian)
% L2=odir(2,2)*pi/180.;%longitude at the instant t2 (radian)
% l3=odir(3,1)*pi/180.;%latitude at the instant t3 (radian)
% L3=odir(3,2)*pi/180.;%longitude at the instant t3 (radian)
% l4=odir(4,1)*pi/180.;%latitude at the instant t4 (radian)
% L4=odir(4,2)*pi/180.;%longitude at the instant t4 (radian)


%% Definition of Z and Y
% dl1=l1-l01;   
% dl2=l2-l02;
% dl3=l3-l03;
% dl4=l4-l04;
% dL1=mod(pi()+L1-L01, 2*pi())-pi();
% dL2=mod(pi()+L2-L02, 2*pi())-pi();
% dL3=mod(pi()+L3-L03, 2*pi())-pi();
% dL4=mod(pi()+L4-L04, 2*pi())-pi();

Z = [dlam(1);dphi(1); dlam(2);dphi(2); dlam(3);dphi(3); dlam(4);dphi(4); dlam(5);dphi(5)];
% Z=[dL1;dl1;dL2;dl2;dL3;dl3;dL4;dl4];

Y=D*Z;
end
