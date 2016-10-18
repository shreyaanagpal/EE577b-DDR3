// pragma cdn_vip_model -class ddr3sdram
// Module:                      mt41j64m16_187
// SOMA file:                   /home/scf-03/zhan808/mt41j64m16_187.soma
// Initial contents file:       
// Simulation control flags:    

// PLEASE do not remove, modify or comment out the timescale declaration below.
// Doing so will cause the scheduling of the pins in Denali models to be
// inaccurate and cause simulation problems and possible undetected errors or
// erroneous errors.  It must remain `timescale 1ps/1ps for accurate simulation.   
`timescale 1ps/1ps

module mt41j64m16_187(
    ck,
    ckbar,
    cke,
    csbar,
    odt,
    rasbar,
    casbar,
    webar,
    dm,
    ba,
    a,
    dq,
    dqs,
    dqsbar,
    resetbar
);
    parameter memory_spec = "/home/scf-24/snagpal/RTL_folder_1/RTL_folder/design/mt41j64m16_187.soma";
    parameter init_file   = "";
    parameter sim_control = "";
    input ck;
    input ckbar;
    input cke;
    input csbar;
    input odt;
    input rasbar;
    input casbar;
    input webar;
    input [1:0] dm;
    input [2:0] ba;
    input [13:0] a;
    inout [15:0] dq;
      reg [15:0] den_dq;
      assign dq = den_dq;
    inout [1:0] dqs;
      reg [1:0] den_dqs;
      assign dqs = den_dqs;
    inout [1:0] dqsbar;
      reg [1:0] den_dqsbar;
      assign dqsbar = den_dqsbar;
    input resetbar;
initial
    $ddr3sdram_access(ck,ckbar,cke,csbar,odt,rasbar,casbar,webar,dm,ba,a,dq,den_dq,dqs,den_dqs,dqsbar,den_dqsbar,resetbar);
endmodule

