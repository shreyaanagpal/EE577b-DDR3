
# NC-Sim Command File
# TOOL:	ncsim	08.20-p001
#
#
# You can restore this configuration with:
#
#     ncsim -STATUS -NOCOPYRIGHT -MESSAGES -NCFATAL INVSUP -NOWARN DLBRLK -TCL -NOLOG -NOKEY -INPUT ./scripts/runscript.tcl -GUI tb -tcl -update -input /home/scf-23/nhourani/RTL_folder_3/ddr3_scr_scw.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 1
set show_force 1
set force_reset_by_reinvoke 0
database -open -shm -into ncsim.shm ncsim.shm -default
probe -create -database ncsim.shm tb -all -memories -depth all
probe -create -database ncsim.shm tb -all -memories -depth all
probe -create -database ncsim.shm tb -all -memories -depth all
probe -create -database ncsim.shm tb -all -memories -depth all

simvision -input /home/scf-23/nhourani/RTL_folder_3/ddr3_scr_scw.tcl.svcf
