%%----------------HEADER---------------------------%%
%Author:          Tristan Mallet & Oussema SLEIMI
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
%This program cancel the grad and gives us the solution X of the problem.
%
% 1. Input:
%     ii           = Point of the trajectory that will be used to solve the problem. For this case ii must be included between 1 and 987.
%     'trajectory_name/trajectory_name_ephjup' : The actual trajectory we consider
%     timestep : various sampling we consider to take the pictures
%     algo : algo we use ton inverse the problem

% 2. Outputs:
%    
%     X  = 19x1  double float vector giving the solution of the problem
%     A  = 19x19 double float vector giving the matrix A (cf NAv-002 for more details).
%     B  = 19x19 double float vector giving the matrix B (cf NAv-002 for more details).


function [X,A,B,elapsed_time]=annul_grad(ii,timeStep,algo,trajectory_name,trajectory_name_ephjup)
%we call the needed sub-programs to operate this one.
[TimeList,lat0,long0,distance0,lat1,long1]=on_board_interpolation(ii,timeStep,trajectory_name,trajectory_name_ephjup);
[C,D]= Calculation_C_D(TimeList,lat0,long0,distance0);
[Y]= Calculation_Y_Z(lat0,long0,lat1, long1,D);

close all;

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

#scale matrix

#S=[ 1, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0,   0,    0,    0,   0,   0,   0;
#    0, 1, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0,   0,    0,    0,   0,   0,   0;
#  0, 0, 1,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0,    0,    0,    0,   0,   0,   0;
#    0, 0, 0,  1,  0,  0,  0,  0,  0,  0,  0,  0,   0, 0,    0,    0,   0,   0,   0;
#    0, 0, 0,  0,  1,  0,  0,  0,  0,  0,  0,  0,   0, 0,    0,    0,   0,   0,   0;
#    0, 0, 0,  0,  0,  1,  0,  0,  0,  0,  0,  0,   0, 0,     0,    0,   0,   0,   0;
#    0, 0, 0,  0,  0,  0,  1,  0,  0,  0,  0,  0,   0,    0, 0,    0,   0,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  1,  0,  0,  0,  0,   0,    0, 0,    0,   0,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  1,  0,  0,  0,   0,    0,  0,    0,   0,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  0,  1,  0,  0,   0,    0,    0, 0,   0,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  1,  0,   0,    0,    0, 0,   0,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  1,   0,    0,    0,  0,   0,   0,   0;
#    0, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,   1,    0,    0,    0, 0,   0,   0;
#    0, 0, 0,  0, 0,  0,  0,  0,  0,  0,  0,  0,   0,    1,    0,    0,   0, 0,   0;
#    0, 0, 0,  0,  0, 0,  0,  0,  0,  0,  0,  0,   0,    0,    1,    0,   0,   0, 0;
#    0, 0, 0,  0,  0,  0, 0,  0,  0,  0,  0,  0,   0,    0,    0,    1, 0,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  0, 0,  0,  0,   0,    0,    0,    0, 1/1000,   0,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  0,  0, 0,  0,   0,    0,    0,    0,   0, 1/1000,   0;
#    0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0, 0,   0,    0,    0,    0,   0,   0, 1/1000];

t=cputime;
#switch (algo)
	
#	case 'PINV'	%we solve the problem by inversion.
 X=pinv(A)*(-B');
 # X=pinv(S*A)*S*(-B');
 
 
 #	case 'FMIN'	%we solve the problem by using fminunc
 	
 #	case 'MC'
 	
 #	case 'SD'
 	
#endswitch
elapsed_time=cputime-t;

end

 