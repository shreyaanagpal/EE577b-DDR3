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
output [DEPTH_P2:0] fillcount; //if it is full,we need onemore bit

//output types
reg [WIDTH-1:0] data_out;
reg [DEPTH_P2:0] fillcount; //if it is full,we need onemore bit
reg [DEPTH_P2-1:0] wr_ptr, rd_ptr;
reg [WIDTH-1:0] mem [2**DEPTH_P2-1:0];
reg full;
wire full_bar;
reg empty;
wire empty_bar;
reg wenq;
reg renq;
integer i;

always @(posedge clk, posedge reset) 
  begin
    if(reset==1)
      begin 
        wr_ptr    <= 'd0; //initialize pointers
	rd_ptr    <= 'd0; 
	fillcount <= 'd0; //initialize fill counter
        data_out  <= 'd0; //no data out
        i         <= 0; //init loop counter
        for(i=0; i<32; i=i+1)begin //init entire FIFO
          mem[i] <= 0;
          i <=i+1;
        end
      end
    else begin
     //read and write should be able to occur in parallel  

      if(wenq)
        begin
	  mem[wr_ptr] <= data_in;
	  wr_ptr      <= wr_ptr + 1;
        end
    
      if(renq)
        begin
          data_out <= mem[rd_ptr];      
          rd_ptr <= rd_ptr + 1;
        end
    end
  end

//write and read enables
always @(put,get,full,empty) 
begin
  wenq = 0;
  renq = 0;
  if(put==1 && full==0) begin //not full
    wenq = 1;
  end
  if(get==1 && empty==0) begin //not empty
    renq = 1;
  end
end

//depth calculation
always@(wr_ptr, rd_ptr, fillcount)
begin
  fillcount = wr_ptr - rd_ptr;
  //check for fullness
  if (fillcount[DEPTH_P2]==1 && |fillcount[DEPTH_P2-1:0])
  begin
    full  = 1;
    empty = 0;
  end
  else if (|fillcount[DEPTH_P2:0]==0)
  begin
    empty = 1;
    full  = 0;
  end
  else
  begin
    empty = 0;
    full  = 0;
  end
end

assign empty_bar = ~empty;
assign full_bar  = ~full;

endmodule 