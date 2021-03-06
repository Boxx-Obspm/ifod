ft = 3600.;  % in seconds (time factor)
fx = 1000.;  sx = 500./fx; % km (distance factor and measurement accuracy)
fv = 0.28;  sv = 0.0001/fv; % km/s (velocity factor and measurement accuracy)
fa = 7.7E-5; sa = 0.00000001*max([norm(accEstimate) 0])./fa; % km/s^2 (acceleration factor and accuracy)
