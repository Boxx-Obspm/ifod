# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.5 05-Aug-2016, Boris Segret
# CL=2
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: "./inputs/scenario" file is requested (and points to associated data & files)
# S/: comparisons between actual and reconstructed trajectory, with MC simu for standard deviations
# F/: see technical note BIRDY NAV-002 for details

# Content Reference:

# Test Dataset => run "ifod" in Octave or Matlab from its local path to test it runs properly
# - ./inputs/EME_mini : scenario
# - ./inputs/Trajectories/EME/* : *.eph, .xyzv, ./T0+jdv_y-axis/<same files with shift>

# own routines:
# - runifod.m, v1.3 (+ runifod_MCdrivers.m, runifod_scenario.m)
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
# - ./inputs/Trajectories/figures.m (11/04/2016)
# - ./inputs/Trajectories/prodEME.m, v1.1
# external routines:
# - ../ifod_eval/stat_extraction.m, v3.0
