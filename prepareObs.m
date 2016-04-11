%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  Vxxx dd-mm-2016 (dd-mm-yyyy)
%                  - former "on_board_interpolation"
%                  - use of embedded "interp1" function
%                  V2.2 03-03-2016 (dd-mm-yyyy), Boris Segret
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
% CL=1
%
% The inputs are extracted and interpolated at 4 specific timesteps ii+[timeStep]
%
% I/
%     epochs    = timestep of the trajectory to start interpolating
%     <actual_ephemerides>
% O/
%     TimeList      = 4x1 double float vector giving the 4 times of measurement in Julian Day.
%     out_lat0      = 4x1 double float vector giving the interpolated latitude of Jupiter seen from the reference trajectory.
%     out_long0     = 4x1 double float vector giving the interpolated longitude of Jupiter seen from the reference trajectory.
%     out_distance0 = 4x1 double float vector giving the interpolated distance between BIRDY and Jupiter from the reference trajectory.

function predict = prepareObs(epochs, nbofBodies, NbLE0, TimeList0, lat0, long0, dist0)

for ii=1:length(epochs)
  i=1+mod(ii-1,nbofBodies);
  out_lat0(ii)  = interp1(TimeList0(i,1:NbLE0(i)), lat0(i,1:NbLE0(i)),  epochs(ii), 'linear');
  out_long0(ii) = interp1(TimeList0(i,1:NbLE0(i)), long0(i,1:NbLE0(i)), epochs(ii), 'linear');
  out_distance0(ii)  = interp1(TimeList0(i,1:NbLE0(i)), dist0(i,1:NbLE0(i)),  epochs(ii), 'linear');
end

predict = [out_lat0' out_long0' out_distance0'];

end

