module FIFO (clk, reset, data_in, put, get, data_out, empty, full, fillcount);
parameter DEPTH_P2 = 5; // 2^ DEPTH_P2;
parameter WIDTH = 8; 
output reg[WIDTH-1:0] data_out; 
output reg empty, full;
output reg[DEPTH_P2:0] fillcount; //Why do we need an more bit in Figure 1?
input [WIDTH-1:0] data_in;
input put, get;
input reset, clk;

/////internal register/////
reg Depth = 32;
reg [7:0]array[0:31];
reg wenq, renq;
reg [DEPTH_P2:0]wr, rd;

////Code begins//////
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
	
	wenq <= ~full & put;
	renq <= ~empty & get;
	
	data_out <= array[rd[4:0]];
end
//assign data_out = array[rd[4:0]];

always@(posedge clk)
begin
	if(reset)
	begin
		wr <= 0;
		rd <= 0;
		fillcount <= 0;
	end
	
	else if(wenq)
	begin
		array[wr] <= data_in;
		wr <= wr + 1;
		fillcount <= fillcount + 1;
	end
	else if(renq)
	begin
	rd <= rd + 1;
	fillcount <= fillcount - 1;
	end
end
endmodule