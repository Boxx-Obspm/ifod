%%----------------HEADER---------------------------%%
%Author:           Boris Segret
%Version & Date:
%                  V2.3 30-03-2016 (dd-mm-yyyy)
%                  - take into account several foreground bodies
%                  - use of embedded "interp1" function
%                  (former "on_board_interpolation")
%                  V2.2 03-03-2016 (dd-mm-yyyy), Boris Segret
%                  - *no* call to reference_trajectory.m
%                  - *no* changes of the inputs
%                  until V2 11-09-2015 Oussema SLEIMI & Tristan Mallet
% CL=2
%
% The inputs are extracted and interpolated at 4 specific timesteps ii+[timeStep]
% Assumption: nbofBodies determines the foreground bodies to be considered for
% each interpolation. Inputs provide ephemeris for every foreground bodies.
%
% I/
%     epochs    = timestep of the trajectory to start interpolating
%     nbofBodies = integer
%     NbLE0      = nbofBodies-vector of integer providing the length of the inputs
%     <ref_ephemerides> : TimeList0(i,:), lat0(i,:), long0(i,:), dist0(i,:) with i being
%                  the number of the considered foreground body
% O/
%     TimeList      = 4x1 double float vector giving the 4 times of measurement in Julian Day.
%     out_lat0      = 4x1 double float vector giving the interpolated latitude of Jupiter seen from the reference trajectory.
%     out_long0     = 4x1 double float vector giving the interpolated longitude of Jupiter seen from the reference trajectory.
%     out_distance0 = 4x1 double float vector giving the interpolated distance between BIRDY and Jupiter from the reference trajectory.

function predict = prepareObs(epochs, bodies, NbLE0, TimeList0, lat0, long0, dist0)

for ii=1:length(epochs)
  i=bodies(ii);
  out_lat0(ii)  = interp1(TimeList0(i,1:NbLE0(i)), lat0(i,1:NbLE0(i)),  epochs(ii), 'linear');
  out_long0(ii) = interp1(TimeList0(i,1:NbLE0(i)), long0(i,1:NbLE0(i)), epochs(ii), 'linear');
  out_distance0(ii)  = interp1(TimeList0(i,1:NbLE0(i)), dist0(i,1:NbLE0(i)),  epochs(ii), 'linear');
end

predict = [out_lat0' out_long0' out_distance0'];

end
