//------------------------------
// Title : 2 Clock Async FIFO TB
// Author: Najib Hourani
// USC ID: 7152521623
// E-mail: nhourani@usc.edu
//------------------------------

//Note: put & get signals must be synchronous to producer and consumer, respectively

`timescale 1ns/10ps
module tb;

parameter DATA_WIDTH = 32,
          FIFO_DEPTH = 16;

reg clk, reset, put, get;
wire empty_bar, full_bar;
wire [DATA_WIDTH-1:0] data_out;
reg  [DATA_WIDTH-1:0] data_in;
integer i=0;

//override parameters via instantiation
FIFO_2clk #(DATA_WIDTH,FIFO_DEPTH) u1(
									  .clk(clk),
                                      .reset(reset),
                                      .we(put),
                                      .re(get),
                                      .empty_bar(empty_bar),
                                      .full_bar(full_bar),
                                      .data_out(data_out),
                                      .data_in(data_in));
initial
begin
data_in = 'd0; 
clk    = 1;
reset   = 1;
put     = 0;
get     = 0;
#50;
reset   = 0;

//fill the FIFO
for(i=0; i<FIFO_DEPTH; i=i+1)  
begin
  put = 1;
  data_in = i;
  get = 0;
  #1.6;
  put = 0;
end

//empty the FIFO
put = 0;
get = 1;

//put and get at the same time
for(i=0; i<FIFO_DEPTH; i=i+1)  
begin
  put = 1;
  data_in = i;
  get = 1;
  #1.6;
  put = 0;
  get = 0;
end
#1000;
$finish;
end

//rclk (200 MHz: T=5ns)
always 
#1.6 clk=~clk;

endmodule


