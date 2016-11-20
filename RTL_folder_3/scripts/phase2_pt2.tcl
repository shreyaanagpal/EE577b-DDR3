####################################################################################
#
# EE-577b - Fall 2016
# LAB#2 part 1
# DesignCompiler synthesis script for a FIFO 
#
# use this script as a template for synthesis
#
####################################################################################

# Setting variables for synthesis
set design_name ddr3_controller;

#setting CLK (ns)
set clk_period_clk 1.6; #625 MHz clk 
set posedge_clk 0.0;
set negedge_clk [expr $clk_period_clk * 0.5];

# Reading source verilog file.
# Copy your verilog file into ./src/ before synthesis.
read_verilog ./design/FIFO_2clk.v;
read_verilog ./design/ddr3_init_engine.v;
read_verilog ./design/SSTL18DDR3INTERFACE.v;
read_verilog ./design/SSTL18DDR3.v;
read_verilog ./design/SSTL18DDR3DIFF.v;
read_verilog ./design/ddr3_ring_buffer8.v;
read_verilog ./design/Processing_logic.v;
read_verilog ./design/ddr3_controller.v;

# Setting $design_name as current working design.
# Use this command before setting any constraints.
current_design $design_name ;

# If you have multiple instances of the same module,
# use this so that DesignCompiler optimize each instance separately
uniquify;

# Linking your design into the cells in standard cell libraries.
# This command checks whether your design can be compiled
# with the target libraries specified in the .synopsys_dc.setup file.
link;

# Setting timing constraints for sequential logic.
# => clock period, input delay, output delay

# (1) Setting clock period.
create_clock -name "clk" -period $clk_period_clk -waveform [list $posedge_clk $negedge_clk] [get_ports clk];

# (2) Setting additional constraints for clock signal,
# so that clock network should be ideal network without any buffers.
set_dont_touch_network clk;
set_ideal_network clk;
set_dont_touch [find cell PLOGIC/ring_buffer/DELAY*]
get_attribute  [find cell PLOGIC/ring_buffer/DELAY*] dont_touch

# (3) Setting input path delays on input ports(except clock) relative to a clock edge .
# Input signals will arrive after this delay.
set_input_delay 1.0 -clock clk {read};
set_input_delay 1.0 -clock clk {cmd};
set_input_delay 1.0 -clock clk {din};
set_input_delay 1.0 -clock clk {sz};
set_input_delay 1.0 -clock clk {op};
set_input_delay 1.0 -clock clk {addr};
set_input_delay 1.0 -clock clk {initddr};
set_input_delay 1.0 -clock clk {waiting};

# (4) Setting output path delays on output ports relative to a clock edge.
# output signals should be generated before this delay.
set_output_delay 1.0 -clock clk {dout};
set_output_delay 1.0 -clock clk {raddr};
set_output_delay 1.0 -clock clk {fillcount};
set_output_delay 1.0 -clock clk {notfull};
set_output_delay 1.0 -clock clk {ready};
set_output_delay 1.0 -clock clk {validout};

# (5) Setting false paths
#set_false_path -from wclk -to rclk;
#set_false_path -from clk -to wr_ptr_gray_s;  #ignore double stage synchronizer
#set_false_path -from wclk -to rd_ptr_gray_s; #ignore double stage synchronizer

# "check_design" checks the internal representation of the
# current design for consistency and issues error and
# warning messages as appropriate.
check_design > report/$design_name.check_design ;
check_error  > report/$design_name.check_errors;

# Performing synthesis and optimization on the current_design.
compile -incremental_mapping -map_effort high -auto_ungroup delay
#compile 
#compile_ultra -no_seq_output_inversion;

# For better synthesis result, use "compile_ultra" command.
# compile_ultra is doing automatic ungrouping during optimization,
# therefore sometimes it's hard to figure out the critical path 
# from the synthesized netlist.

# Writing the synthesis result into Synopsys dcc format
# You can read the saved ddc file into DesignCompiler later using
# write -format ddc -hierarchy -out db/$design_name.ddc ;

# Generating timing and are report of the synthezied design.
report_timing     > report/$design_name.timing;
report_area       > report/$design_name.area;
#report_net_fanout > report/$design_name.fanout;
#report_power      > report/$design_name.power;
#report_constraint > report/$design_name.constraint;
#report_constraint -all_violators > report/$design_name.violations;

# Writing synthesized gate-level verilog netlist.
# This verilog netlist will be used for post-synthesis gate-level simulation.
change_names -rules verilog -hierarchy ;
write -format verilog -hierarchy -out netlist/$design_name.syn.v ;

# Writing Standard Delay Format (SDF) back-annotation file.
# This delay information can be used for post-synthesis simulation.
write_sdf sdf/$design_name.sdf;
