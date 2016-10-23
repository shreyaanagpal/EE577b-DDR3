//------------------------------
// Title : 2 Clock Async FIFO TB
// Author: Najib Hourani
// USC ID: 7152521623
// E-mail: nhourani@usc.edu
//------------------------------

//Note: put & get signals must be synchronous to producer and consumer, respectively

`timescale 1ns/10ps
module tb;

parameter DATA_WIDTH = 4,
          FIFO_DEPTH = 4,
          PTR_WIDTH  = 3;

reg clk, reset, put, get;
wire empty_bar, full_bar;
wire [DATA_WIDTH-1:0] data_out;
reg  [DATA_WIDTH-1:0] data_in;
integer i=0;

//override parameters via instantiation
<<<<<<< HEAD
FIFO_2clk #(DATA_WIDTH,FIFO_DEPTH) u1(
									  .clk(clk),
                                      .reset(reset),
                                      .we(put),
                                      .re(get),
                                      .empty_bar(empty_bar),
                                      .full_bar(full_bar),
                                      .data_out(data_out),
                                      .data_in(data_in));
=======
FIFO_2clk #(DATA_WIDTH,FIFO_DEPTH,PTR_WIDTH) u1(.rclk(rclk),
	                                         .wclk(wclk),
                                                 .reset(reset),
                                                 .we(put),
                                      		 .re(get),
                                                 .empty_bar(empty_bar),
                                                 .full_bar(full_bar),
                                                 .data_out(data_out),
                                                 .data_in(data_in));
>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
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
  data_in = i+1;
  get = 0;
<<<<<<< HEAD
  #1.6;
  put = 0;
=======
  #100;
>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
end
//empty the FIFO
put = 0;
#10;
for(i=0; i<FIFO_DEPTH; i=i+1)  
begin
  get = 1;
<<<<<<< HEAD
  #1.6;
  put = 0;
  get = 0;
end
#1000;
=======
  #25;
end
#400;
//read and write simultaneously 
for(i=0; i<FIFO_DEPTH; i=i+1)
begin
  get = 1;
  put = 1;
  data_in = 4'hA + i;
  #100;
end
#600;
>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
$finish;
end

//rclk (200 MHz: T=5ns)
always 
#1.6 clk=~clk;

endmodule


