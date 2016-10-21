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
set design_name FIFO_2clk;

#setting WCLK (ns)
set clk_period_wclk 50.0;
set posedge_wclk 0.0;
set negedge_wclk [expr $clk_period_wclk * 0.5];

#setting RCLK (ns)
set clk_period_rclk 2.50;
set posedge_rclk 0.0;
set negedge_rclk [expr $clk_period_rclk * 0.5];

# Reading source verilog file.
# Copy your verilog file into ./src/ before synthesis.
read_verilog ./design/FIFO_2clk.v ;

# Setting $design_name as current working design.
# Use this command before setting any constraints.
current_design $design_name ;

# If you have multiple instances of the same module,
# use this so that DesignCompiler optimize each instance separately
uniquify ;

# Linking your design into the cells in standard cell libraries.
# This command checks whether your design can be compiled
# with the target libraries specified in the .synopsys_dc.setup file.
link ;

# Setting timing constraints for sequential logic.
# => clock period, input delay, output delay

# (1) Setting clock period.
create_clock -name "wclk" -period $clk_period_wclk -waveform [list $posedge_wclk $negedge_wclk] [get_ports wclk];
create_clock -name "rclk" -period $clk_period_rclk -waveform [list $posedge_rclk $negedge_rclk] [get_ports rclk];

# (2) Setting additional constraints for clock signal,
# so that clock network should be ideal network without any buffers.
set_dont_touch_network wclk ;
set_dont_touch_network rclk;
set_ideal_network wclk ;
set_ideal_network rclk;

# (3) Setting input path delays on input ports(except clock) relative to a clock edge .
# Input signals will arrive after this delay.
set_input_delay 1.0 -clock rclk {re};
set_input_delay 1.0 -clock wclk {we};
set_input_delay 1.0 -clock wclk {data_in};

# (4) Setting output path delays on output ports relative to a clock edge.
# output signals should be generated before this delay.
set_output_delay 1.0 -clock rclk {empty_bar};
set_output_delay 1.0 -clock rclk {data_out};
set_output_delay 1.0 -clock wclk {full_bar};

# (5) Setting false paths
set_false_path -from wclk -to rclk;

# "check_design" checks the internal representation of the
# current design for consistency and issues error and
# warning messages as appropriate.
check_design > report/$design_name.check_design ;

# Performing synthesis and optimization on the current_design.
compile ;

# For better synthesis result, use "compile_ultra" command.
# compile_ultra is doing automatic ungrouping during optimization,
# therefore sometimes it's hard to figure out the critical path 
# from the synthesized netlist.

# Writing the synthesis result into Synopsys dcc format
# You can read the saved ddc file into DesignCompiler later using
# write -format ddc -hierarchy -out db/$design_name.ddc ;

# Generating timing and are report of the synthezied design.
report_timing > report/$design_name.timing ;
report_area > report/$design_name.area ;

# Writing synthesized gate-level verilog netlist.
# This verilog netlist will be used for post-synthesis gate-level simulation.
change_names -rules verilog -hierarchy ;
write -format verilog -hierarchy -out netlist/$design_name.syn.v ;

# Writing Standard Delay Format (SDF) back-annotation file.
# This delay information can be used for post-synthesis simulation.
write_sdf sdf/$design_name.sdf;
