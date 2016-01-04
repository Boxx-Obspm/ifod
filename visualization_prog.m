%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet & Oussema SLEIMI
%Version & Date:   V2 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
% This program runs some tests in order to 'visualize' and 'feel' things. It
% runs all the other sub-programs. 
%
% 1. Input:
%     ii= point of the trajectory that we want to consider in order to make simulations.
%     'trajectory_name/trajectory_name_ephjup' : The actual trajectory we consider
%     plot : boolean : 1 if we want to plot the chi2 / 0 if not
%     timestep : various sampling we consider to take the pictures
%     algo : algo we use ton inverse the problem

% 2. Outputs:
%     CHI2 = 1x19 double vector. CHI2 values at ii. Each column n contains chi2(n) at time ii, for X(n) found at time ii. Since we have 19 unknowns X(n) at ii we have 19 columns.
%     diff = 1x19 double vector, difference between X(1..19) found and Xexp(1..19) expected
%     A, B refer to the matrices in NAV-006
% 3. Plots:
% running this program will plot figures from 'trajectoires_voisines' the
% chi2 for the 19 values of X and a nappe of a chi2 using two of the 19
% values of X.

function[CHI2,diff,A,B]= visualization_prog(ii,plots,timeStep,trajectory_name,trajectory_name_ephjup,algo)

    [X,A,B,elapsed_time]=annul_grad(ii,timeStep,algo,trajectory_name);
    [dr,Dvectr,Dvelocity]=test_interpolation(ii,timeStep,trajectory_name);
    [Xexp]=Calculate_Xexpected(dr, Dvectr, Dvelocity);
    
   
if (plots)
    	X0=zeros(19,1);
  	XX=X;
    
 %%    calcule chi2 pour dx dy dz r Vx Vy et Vz
 
 % keeping C an Y unchange this loop take each X(i) one by one shift it(100
 % times) and calculate the chi2 for each iteration then goes to the next
 % X(i) and do the same thing again. All the results are first store in
 % CHI2 then ploted.
 
 % needed for chi2 since we need C and Y.
    [TimeList,lat0,long0,distance0,lat1,long1]=on_board_interpolation(ii,timeStep,trajectory_name,trajectory_name_ephjup);
    [C,D]= Calculation_C_D(TimeList,lat0,long0,distance0);
    [Y]= Calculation_Y_Z(lat0,long0,lat1, long1,D); 
 
 	 for n=1:19 
     		 p=0;
  		  for j=-5:0.04:5
		       	p=p+1;
	      	  	X(n)=XX(n)+j*(XX(n)-X0(n));
	     	   	chi2= chi21(X,C,Y);
	    	    	CHI2(p,n)=chi2;
        
	        	 endfor
	 X=XX;     
     
	  endfor

  %% plot 19 courbes chi2
	for i=1:19
		 figure (i)
		 plot(CHI2(:,i))
    
 	endfor
       
  %% nappe
 	n=14;
 	p=0;
 	for j=-5:0.04:5
		p=p+1;
 		m=0;
 		X(n)=XX(n)+j*(XX(n)-X0(n));
 		for k=-5:0.04:5
 			m=m+1;
			 X(n+2)=XX(n+2)+k*(XX(n+2)-X0(n+2));
			 truc= chi21(X,C,Y);
			 CHI2nappe(m,p)=truc; 
			           
		endfor
	X=XX;
	endfor
 	X=XX;
	figure
	surf (CHI2nappe)
	figure
	mesh (CHI2nappe)
  
  %% Comparison between Xexp and Xcal
  
 	diff=(X-Xexp);
 	 
else
	
	diff=X-Xexp;
	disp('to display the plots --> plots=1');
	
endif

end




