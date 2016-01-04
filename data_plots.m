%%----------------HEADER---------------------------%%
%Author:           Tristan Mallet
%Version & Date:   V1 11-09-2015 (dd/mm/yyyy)
%CL=1
%
%
% This program plots the critical outputs from the dataExtraction file.
%
% 1. Inputs:
%    The name of the result file to read
%    k : the column that we want to plot
%
% 2. Outputs:
%    plots= this program will plot the k column with ii as the x-axis
## Return the plot of the k column of plot_file's data ##

function [data_plots]=data_plots()
	
plot_file=input('what data do you want to plot ? (file name) : ','s');
k=input('what column do you want to plot ? :');
	plot_file=fopen(plot_file,'rt'); #we open the file dataExtraction
	l=' ';
	while 1
		l=fgetl(plot_file);
		if strfind(l,'META_STOP')>0
			break;
		end;
	end;
	data_plots=dlmread(plot_file); #we read it from the META_STOP tag.
	figure (k)
	plot(data_plots(:,k)) #we plot the k column
	switch (k)
		case 1
		ylabel ('MJD')
		case 2
		ylabel ('Seconds')
		case 3
		ylabel ('Transversal difference reference/actual (km)')
		case 4
		ylabel ('Longitudinal difference reference/actual (km)')
		case 5
		ylabel ('Latitude difference of Jupiter reference/actual (°)')
		case 6
		ylabel ('Longitude difference of Jupiter reference/actual (°)')
		case 7
		ylabel ('Transversal Error (km)')
		case 8
		ylabel ('Longitudinal Error (km)')
		case 9
		ylabel('Rectilinearity of speed (°)')
		case 10
		ylabel('Uniformity of speed (m/s)')
		case 11
		ylabel('Rank of A')
	endswitch
	xlabel ('ii (time step of the sampling)')
 
	fclose(plot_file);
end