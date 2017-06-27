# ifod
# In-Flight Orbit Determination in deep-space from optical sensors
# Version & Date:   V1.9 26-Jun-2017, Boris Segret
# CL=2
#
# runifod.m : main program, for MATLAB or OCTAVE
# I/: a scenario file is requested (and its associated data)
# S/: comparisons between actual and reconstructed trajectory, with MC simu for standard deviations
# F/: see technical notes
#     BIRDY NAV-002 for details on the on-board algorithm itself
#     BIRDY NAV-011 for details on the implementation of the prototype with MATLAB/OCTAVE

# Test Dataset => run "ifod" in Octave or Matlab from its local path to test it runs properly
# - ../ifod_tests/Y0_v4 (v4.0) : mini scenario file
# - ../ifod_tests/datasets/*.xva : ephemerides and ref trajectories
# Results written into <../ifod_tests/outs/>Y0v4_xxx,tests and ,tests_bin file
# v1.9 was *tested* in OCTAVE

# Content Reference:
# - README_v1.9.md: this present note
# - LICENSE, GNU Version 3, 29 June 2007
# - .gitignore: settings for github CVS
# own routines:
# - runifod.m, v1.6 (+ runifod_MCdrivers.m, runifod_scenario.m)
# - readTraj.m, v3.2
# - computeSolution.m, v2.3.1
# - kf.m, v1.1
# - oneOD.m, v3.8 (+ oneOD_factors.m)
# - debug.m, v1.2
# useful test routines:
# - runbash (shell), v1.0
# - ../myJobs (shell & SLURM on tycho.obspm.fr)
# - ../ifod_tests/Y0_v4 (v4.0) + related files
# external routines:
# - ../ifod_eval/stat_extraction.m, v4.0
