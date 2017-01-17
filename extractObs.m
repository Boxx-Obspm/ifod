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
%CL=2
%
% The inputs are extracted and interpolated at 4 specific timesteps ii+[timeStep]
% Assumption: nbofBodies determines the foreground bodies to be considered for
% each interpolation. Inputs provide ephemeris for every foreground bodies.
%
% I/
%     epochs     = 4x1, double matrix, 4 epoch times (in decimal days)
%     nbofBodies = integer
%     NbLE1      = nbofBodies-vector of integer providing the length of the inputs
%     <actual_ephemerides> : TimeList1(i,:), lat1(i,:), long1(i,:) with i being
%                  the number of the considered foreground body
% O/
%     observd    = 4x2, double float vector (out_lat1, out_long1) interpolated at epochs
%               (same units like inputs)

%  observd = extractObs(epochs, nbofBodies, NbLE1, TimeListE1, lat1, long1);


function observd = extractObs(epochs, bodies, NbLE1, TimeList1, lat1, long1)

for ii=1:length(epochs)
    i=bodies(ii);
    out_lat1(ii)  = interp1(TimeList1(i,1:NbLE1(i)), lat1(i,1:NbLE1(i)),  epochs(ii), 'linear');
    out_long1(ii) = interp1(TimeList1(i,1:NbLE1(i)), long1(i,1:NbLE1(i)), epochs(ii), 'linear');
end
observd = [out_lat1' out_long1'];
end
