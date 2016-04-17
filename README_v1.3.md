# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.3 10-04-2016, Boris Segret
# CL=2
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: "./inputs/scenario" file is requested (and points to associated data & files)
# S/: timesteped comparisons between actual and reconstructed trajectory
# F/: see technical note BIRDY NAV-002 for details

# Content Reference:
% own routines:
# - chi2.m, v2.1
# - computeSolution.m, v2.2
# - extractObs.m, v2.3
# - prepareObs.m, v2.3
# - readEphem.m, v3.1
# - readTraj.m, v3.1
# - runifod.m, v1.1
# - slctEpochs.m, v1.3
# data:
# - ./inputs/scenario and associated data & files
# external routines:
# - ../ifod_eval/data_extraction.m
# - ../ifod_eval/data_plots_full.m
