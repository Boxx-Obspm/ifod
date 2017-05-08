# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.8 28-Mar-2017, Boris Segret
# CL=2
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: a scenario file is requested (and associated data & files)
# S/: comparisons between actual and reconstructed trajectory, with MC simu for standard deviations
# F/: see technical note BIRDY NAV-002 for details

# Content Reference:

# Test Dataset => run "ifod" in Octave or Matlab from its local path to test it runs properly
# - ../ifod_tests/datasets/EME_mini : scenario file, as given in "runifod_scenario.m" file
# - ../ifod_tests/datasets/Trajectories/* : *.eph, *.xyzv (ref ephemerids and ref trajectory)
# - ../ifod_tests/datasets/Trajectories/T0+jdv_y-axis/* : *.eph, *.xyzv (shifted eph and shifted trajectory)
# Results written into <datasets/EME_mini/>../outs/Ebtest_xxx file and log_ifod
# (in OCTAVE some warnings about cross product may be displayed)
# not tested in OCTAVE yet

# own routines:
============> # - README_v1.9.md <================ 1.9 = NEXT DELIVERY (May 2017)
# - runifod.m, v1.6 (+ runifod_MCdrivers.m, runifod_scenario.m)
# - readEphem.m, v3.1
# - readTraj.m, v3.1
# - extractObs.m, v2.3
# - prepareObs.m, v2.3
# - computeSolution.m, v2.3.1
# - oneOD.m, v3.7 (+ oneOD_factors.m)
# - debug.m, v1.2
# useful test routines:
# - runbash (shell)
# - ../myJobs (shell & SLURM on tycho.obspm.fr)
# - ../ifod_tests/datasets/EME_mini + related files
# - ../ifod_tests/fixEPHfiles.m, v1.1
# - ../ifod_tests/JD2VTS_eph.m, v1.1
# - ../ifod_tests/JD2VTS_traj.m, v1.1
# - ../ifod_tests/prodEPHfiles.m, v1.1
# external routines:
# - ../ifod_eval/stat_extraction.m, v3.3.4
