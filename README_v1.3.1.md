# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.3.1 17-04-2016, Boris Segret
# CL=2
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: "./inputs/scenario" file is requested (and points to associated data & files)
# S/: timesteped comparisons between actual and reconstructed trajectory
# F/: see technical note BIRDY NAV-002 for details

# Content Reference:
# own routines:
# - runifod.m, v1.1
# - slctEpochs.m, v1.3
# - readEphem.m, v3.1
# - readTraj.m, v3.1
# - extractObs.m, v2.3
# - prepareObs.m, v2.3
# - computeSolution.m, v2.2
# - chi2.m, v2.1
# useful test routines:
# - ./inputs/Trajectories/fixEPHfiles.m, v1.1
# - ./inputs/Trajectories/JD2VTS_eph.m, v1.1
# - ./inputs/Trajectories/JD2VTS_traj.m, v1.1
# - ./inputs/Trajectories/prodEPHfiles.m, v1.1
# - ./inputs/Trajectories/prodYline.m, v1.8
# - ./inputs/Trajectories/figures.m
# data:
# - ./inputs/scenario and associated data & files
# external routines:
# - ../ifod_eval/data_extraction.m
# - ../ifod_eval/data_plots_full.m
