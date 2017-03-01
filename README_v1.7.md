# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.7 01-Mar-2017, Boris Segret
# CL=1
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: a scenario file is requested (and associated data & files)
# S/: comparisons between actual and reconstructed trajectory, with MC simu for standard deviations
# F/: see technical note BIRDY NAV-002 for details

# Content Reference:

# Test Dataset => run "ifod" in Octave or Matlab from its local path to test it runs properly
# - ../ifod_tests/datasets/EME_mini : scenario file, as given in "runifod_scenario.m" file
# - ../ifod_tests/datasets/Trajectories/EME/* : *.eph, *.xyzv (ref ephemerids and ref trajectory)
# - ../ifod_tests/datasets/Trajectories/EME/T0+jdv_y-axis/* : *.eph, *.xyzv (shifted eph and shifted trajectory)
# Results written into EME_out_xxx file and log_ifod
# (in OCTAVE some warnings about cross product may be displayed)

# own routines:
# - README_v1.7.md
# - runifod.m, v1.5 (+ runifod_MCdrivers.m, runifod_scenario.m)
# - readEphem.m, v3.1
# - readTraj.m, v3.1
# - extractObs.m, v2.3
# - prepareObs.m, v2.3
# - computeSolution.m, v2.3
# - oneOD.m, v3.6 (+ oneOD_factors.m)
# - debug.m, v1.1
# useful test routines:
# - runbash (shell)
# - ../myJobs (shell & SLURM on tycho.obspm.fr)
# - ../ifod_tests/datasets/EME_mini + related files
# - ../ifod_tests/figures.m (11/04/2016)
# - ../ifod_tests/fixEPHfiles.m, v1.1
# - ../ifod_tests/JD2VTS_eph.m, v1.1
# - ../ifod_tests/JD2VTS_traj.m, v1.1
# - ../ifod_tests/prodEME.m, v1.1
# - ../ifod_tests/prodEPHfiles.m, v1.1
# - ../ifod_tests/prodVTSephem.m (25/03/2016)
# - ../ifod_tests/prodYline.m, v1.8
# external routines:
# - ../ifod_eval/stat_extraction.m, v3.3.2
