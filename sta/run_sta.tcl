#run_sta.tcl file for automated sta

# Load Liberty file (Standard Cell Timing)
read_liberty osu018_stdcells.lib

# Read the synthesized Verilog netlist
read_verilog synth_railway_crossing.v

# Link the design
link_design railway_crossing_fsm

# Read the timing constraints
read_sdc railway_crossing.sdc

# Report timing results
report_checks -path_delay min_max > timing_report.txt
report_tns >> timing_report.txt
report_worst_slack >> timing_report.txt

# Exit OpenSTA
exit
