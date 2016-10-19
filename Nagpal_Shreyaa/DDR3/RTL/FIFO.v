module FIFO (clk, reset, data_in, put, get, data_out, empty_bar, full_bar, fillcount);

parameter DEPTH_P2 = 5; 
parameter WIDTH    = 8;

//inputs
input [WIDTH-1:0] data_in;
input put;
input get;
input reset;
input clk;

//outputs
output [WIDTH-1:0] data_out;
output empty_bar;
output full_bar;
output [DEPTH_P2:0] fillcount; //n+1 bit "fillcount" 

//output types
reg [WIDTH-1:0] data_out;
reg [DEPTH_P2:0] fillcount; //depth?
reg [DEPTH_P2-1:0] wr_ptr, rd_ptr; //n+1 bit pointers (6-bits) [5:0]
reg [WIDTH-1:0] mem [2**DEPTH_P2-1:0];
reg full;
reg full_bar;
reg empty;
reg empty_bar;
reg wenq;
reg renq;
integer i;

always @(posedge clk) 
  begin
    if(reset==0)
      begin 
        wr_ptr    <= 'd0; //initialize pointers
	rd_ptr    <= 'd0; 
        data_out  <= 'd0; //no data out
        i         <= 0; //init loop counter
        for(i=0; i<2**DEPTH_P2; i=i+1)begin //init entire FIFO
          mem[i] <= 0;
          i <=i+1;
        end
      end
    else begin
     //read and write should be able to occur in parallel  

      if(wenq)
        begin
	  mem[wr_ptr[DEPTH_P2-1:0]] <= data_in; //pointer width is 6 (5+1). Only care about 5 bits [4:0]
	  wr_ptr <= wr_ptr + 1;
        end
    
      if(renq)
        begin
          data_out <= mem[rd_ptr[DEPTH_P2-1:0]];      
          rd_ptr <= rd_ptr + 1;
        end
    end
  end

//write and read enables
always @(put, get, full, empty) 
begin
  if(put==1 & full==0) 
    wenq = 1;
  else
    wenq = 0;
  if(get==1 & empty==0) //not empty
    renq = 1;
  else
    renq = 0;
end

//empty calculation
always @(wr_ptr,rd_ptr)
begin
  if (wr_ptr - rd_ptr == 0)
    begin
      empty     = 1;
      empty_bar = 0;
    end
  else
    begin
      empty = 0;
      empty_bar = 1;
    end
end

//full calculation
always@(wr_ptr,rd_ptr)
begin
  fillcount = wr_ptr - rd_ptr;
  if (fillcount[DEPTH_P2]==1 & |fillcount[DEPTH_P2-1:0]==0)
    begin
      full     = 1;
      full_bar = 0;
    end
  else
    begin
      full     = 0;
      full_bar = 1;
    end
end

endmodule 
