# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.6 02-Nov-2016, Boris Segret
# CL=2
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: a scenario file is requested (and associated data & files)
# S/: comparisons between actual and reconstructed trajectory, with MC simu for standard deviations
# F/: see technical note BIRDY NAV-002 for details

# Content Reference:

# Test Dataset => run "ifod" in Octave or Matlab from its local path to test it runs properly
# - ./inputs/EME_mini : scenario file, as given in "runifod_scenario.m" file
# - ./inputs/Trajectories/EME/* : *.eph, *.xyzv (ref ephemerids and ref trajectory)
# - ./inputs/Trajectories/EME/T0+jdv_y-axis/* : *.eph, *.xyzv (shifted eph and shifted trajectory)
# Results must be written into ./inputs/EME_out_xxx file
# (in OCTAVE some warnings about cross product may be displayed)

# own routines:
# - runifod.m, v1.4 (+ runifod_MCdrivers.m, runifod_scenario.m)
# - slctEpochs.m, v1.4
# - readEphem.m, v3.1
# - readTraj.m, v3.1
# - extractObs.m, v2.3
# - prepareObs.m, v2.3
# - computeSolution.m, v2.3
# useful test routines:
# - chi2.m, v2.1
# - ./inputs/Trajectories/fixEPHfiles.m, v1.1
# - ./inputs/Trajectories/JD2VTS_eph.m, v1.1
# - ./inputs/Trajectories/JD2VTS_traj.m, v1.1
# - ./inputs/Trajectories/prodEPHfiles.m, v1.1
# - ./inputs/Trajectories/prodYline.m, v1.8
# - ./inputs/Trajectories/prodEME.m, v1.1
# - ./inputs/Trajectories/figures.m (11/04/2016)
# - ./inputs/Trajectories/prodVTSephem.m (25/03/2016)
# - debug.main
# external routines:
# - ../ifod_eval/stat_extraction.m, v3.2
