%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  V2.1 03-03-2016 (dd-mm-yyyy)
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
%CL=1
%
% ifod algorithm: <reconstructed_shift> is estimated from the on-board measured
% directions of a foreground body compared with the expected directions.
%
% Inputs:
%     <expected_directions>
%     ii        = timestep of the trajectory to start interpolating
%     timeStep  = 1x3 integer vector, nb of indices for 3 additional points of the trajectory
%     algo : algorithm we use to inverse the problem
%     <measured_directions>
% Outputs:
%    
%     X  = 19x1  double float vector giving the p-vector solution of the problem
%     A  = 19x19 double float vector giving the pxp-matrix A (cf NAv-002 for more details).
%     B  = 1x19 double float vector giving the p-vector B (cf NAv-002 for more details).
%     elapsed_time = 

function [X,A,B,elapsed_time]=annul_grad(in_TimeList0, in_lat0, in_long0, in_distance0,...
    ii, timeStep, algo, ...
    in_TimeList1, in_lat1, in_long1)
%we call the needed sub-programs to operate this one.

[TimeList, out_lat0, out_long0, out_distance0, out_lat1, out_long1] = ...
   on_board_interpolation (in_TimeList0, in_lat0, in_long0, in_distance0, ...
                           ii,timeStep, ...
                           in_TimeList1, in_lat1, in_long1);

[C,D]= Calculation_C_D(TimeList, out_lat0, out_long0, out_distance0);
[Y]= Calculation_Y_Z(out_lat0, out_long0, out_lat1, out_long1, D);

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
%switch (algo)
	
%	case 'PINV'	%we solve the problem by inversion.
 X=pinv(A)*(-B');
 % X=pinv(S*A)*S*(-B');
 
 
 %	case 'FMIN'	%we solve the problem by using fminunc
 	
 %	case 'MC'
 	
 %	case 'SD'
 	
%endswitch
elapsed_time=cputime-t;

end
