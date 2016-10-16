module tb;
reg put, get,clk, reset;

reg [7:0] data_in;
wire[7:0] data_out;
wire full, empty;
wire [5:0] fillcount;
FIFO fifo(clk, reset, data_in, put, get, data_out, empty, full, fillcount);

initial begin
clk =1;
reset = 1;
put = 0;
get = 0;
forever begin
#5;
clk = ~clk;
end 
end

initial begin
#5;
reset = 0;
data_in =1;
#25;
 put =1;
#10;     
data_in =2; put=1;
#10;     
data_in =3; put=1;
#10;     
data_in =4; put=1;
#10;     
data_in =5; put=1;
#10;     
data_in =6; put=1;
#10;     
data_in =7; put=1;
#10;     
data_in =8; put=1;
#10;     
data_in =9; put=1;
#10;     
data_in =10; put=1;
#10;     
data_in =11; put=1;
#10;     
data_in =12; put=1;
#10;     
data_in =13; put=1;
#10;     
data_in =14; put=1;
#10;     
data_in =15; put=1;
#10;
put =0;
get =1;

end

endmodule
