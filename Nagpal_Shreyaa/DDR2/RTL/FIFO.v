module FIFO (clk, reset, data_in, put, get, data_out, empty_bar, full_bar, fillcount);

parameter DEPTH_P2 = 5; 
parameter WIDTH = 8;

input [WIDTH-1:0] data_in;
input put, get;
input reset, clk;

output [WIDTH-1:0] data_out;
output empty_bar, full_bar;
output [DEPTH_P2:0] fillcount; //if it is full,we need onemore bit
wire [WIDTH-1:0] data_out;
wire empty_bar, full_bar;

reg [DEPTH_P2:0] fillcount; //if it is full,we need onemore bit
reg [DEPTH_P2-1:0] wr_ptr, rd_ptr;
reg [WIDTH-1:0] mem [2**DEPTH_P2-1:0];
reg full, empty;
wire wenq, renq;
reg [DEPTH_P2-1:0]temp;

always @(posedge clk) 
  begin
    if(reset)
	  begin
		wr_ptr <= 0;
		rd_ptr <= 0;
		fillcount <= 0; 
		temp <= 0;
	  end
	else if(wenq)
		begin
			mem[wr_ptr] <= data_in;
			wr_ptr <= wr_ptr + 1;
			fillcount <= fillcount + 1;
		end
	else if(renq)
		begin
			fillcount <= fillcount - 1;
			temp <= rd_ptr + 1;
			rd_ptr <= temp;
			
	end
  end

assign full_bar = ~full;
assign empty_bar = ~empty;
assign data_out = get?mem[rd_ptr]:0;
assign wenq = ~full & put;
assign renq= ~empty & get;
always@(*)
begin
	empty=0;
	full=0;
	if(fillcount == 6'b100000)
	begin
		full = 1;
		empty = 0;
	end
	else if(fillcount == 6'b000000)
	begin
		empty = 1;
		full =0;
	end
	
end	
endmodule 