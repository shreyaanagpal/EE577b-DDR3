//------------------------------
// Title : 2 Clock Async FIFO
// Author: Najib Hourani
// USC ID: 7152521623
// E-mail: nhourani@usc.edu
//------------------------------

module FIFO_2clk (clk, reset, we, re, data_in, empty_bar, full_bar, data_out);

<<<<<<< HEAD
parameter DATA_WIDTH = 32,
          FIFO_DEPTH = 16,
          PTR_WIDTH  = 4;
=======
parameter DATA_WIDTH = 4,
          FIFO_DEPTH = 4,
          PTR_WIDTH  = 3;
>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
//inputs
input clk, reset, we, re;
input [DATA_WIDTH-1:0] data_in;

//outputs
output empty_bar, full_bar, data_out;

//output types
wire empty_bar;
wire full_bar;
reg [PTR_WIDTH-1:0] full_check;
reg [DATA_WIDTH-1:0] data_out;
reg [PTR_WIDTH-1:0] wr_ptr;
reg [PTR_WIDTH-1:0] rd_ptr;
//internal signals
<<<<<<< HEAD
//reg [PTR_WIDTH-1:0] rd_ptr_bin;
//reg [PTR_WIDTH-1:0] rd_ptr_gray;
//reg [PTR_WIDTH-1:0] rd_ptr_gray_s;
//reg [PTR_WIDTH-1:0] rd_ptr_gray_ss;
//reg [PTR_WIDTH-1:0] rd_ptr_bin_ss; 

//reg [PTR_WIDTH-1:0] wr_ptr_bin;
//reg [PTR_WIDTH-1:0] wr_ptr_gray;
//reg [PTR_WIDTH-1:0] wr_ptr_gray_s;
//reg [PTR_WIDTH-1:0] wr_ptr_gray_ss;
//reg [PTR_WIDTH-1:0] wr_ptr_bin_ss; 

reg [DATA_WIDTH-1:0] fifo[0:FIFO_DEPTH-1];
integer i;
reg[PTR_WIDTH:0] fillcount;

//synchronize producer ptr to consumer 
//always @(posedge rclk or posedge reset)
//begin
//if (reset == 1)
//  begin
//  wr_ptr_gray_s  <= 0;
//  wr_ptr_gray_ss <= 0;
//  end
//else
//  begin
//  wr_ptr_gray_s  <= wr_ptr_gray;
//  wr_ptr_gray_ss <= wr_ptr_gray_s;
//  end
//end
//
////synchronize consumer ptr to producer 
//always @(posedge wclk or posedge reset)
//begin
//if (reset == 1)
//  begin
//    rd_ptr_gray_s  <= 0;
//    rd_ptr_gray_ss <= 0;
//  end
//else
//  begin
//    rd_ptr_gray_s  <= rd_ptr_gray;
//    rd_ptr_gray_ss <= rd_ptr_gray_s;
//  end
//end
//
//convert sync'd wr pointer to bin
//always @(wr_ptr_gray_ss)
//begin
//  for(a=0; a<PTR_WIDTH; a=a+1) begin
//     wr_ptr_bin_ss[a] = ^(wr_ptr_gray_ss >> a);
//  end
//end
//
////convert sync'd rd pointer to bin
//always @(rd_ptr_gray_ss)
//begin
//  for(b=0; b<PTR_WIDTH; b=b+1) begin
//     rd_ptr_bin_ss[b] = ^(rd_ptr_gray_ss >> b);
//  end
//end

//convert rd pointer to gray
//always @(posedge rclk or posedge reset)
//begin
//  if (reset==1)
//    rd_ptr_gray <= 0;
//  else
//  begin
//    for(c=0; c<PTR_WIDTH-1; c=c+1) begin
//      rd_ptr_gray[c] <= rd_ptr_bin[c] ^ rd_ptr_bin[c+1]; 
//    end
//  end
//end
//
//convert wr pointer to gray
//always @(posedge wclk or posedge reset)
//begin
//  if (reset==1)
//    wr_ptr_gray <= 0;
//  else
//  begin
//    for(d=0; d<PTR_WIDTH-1; d=d+1) begin
//      wr_ptr_gray[d] <= wr_ptr_bin[d] ^ wr_ptr_bin[d+1]; 
//    end
//  end
//end
//
=======
reg [PTR_WIDTH-1:0] rd_ptr_bin;
reg [PTR_WIDTH-1:0] rd_ptr_gray;
reg [PTR_WIDTH-1:0] rd_ptr_gray_s;
reg [PTR_WIDTH-1:0] rd_ptr_gray_ss;
reg [PTR_WIDTH-1:0] rd_ptr_bin_ss; 
reg [PTR_WIDTH-1:0] wr_ptr_bin;
reg [PTR_WIDTH-1:0] wr_ptr_gray;
reg [PTR_WIDTH-1:0] wr_ptr_gray_s;
reg [PTR_WIDTH-1:0] wr_ptr_gray_ss;
reg [PTR_WIDTH-1:0] wr_ptr_bin_ss; 
reg [DATA_WIDTH-1:0] fifo[0:FIFO_DEPTH-1];
reg full;
reg empty;
reg wenq;
reg renq;
integer a,b,c,d,e;

//synchronize producer ptr to consumer 
always @(posedge rclk or posedge reset)
begin
if (reset == 1)
  begin
    wr_ptr_gray_s  <= 0;
    wr_ptr_gray_ss <= 0;
  end
else
  begin
    wr_ptr_gray_s  <= wr_ptr_gray;
    wr_ptr_gray_ss <= wr_ptr_gray_s;
  end
end

//synchronize consumer ptr to producer 
always @(posedge wclk or posedge reset)
begin
if (reset == 1)
  begin
    rd_ptr_gray_s  <= 0;
    rd_ptr_gray_ss <= 0;
  end
else
  begin
    rd_ptr_gray_s  <= rd_ptr_gray;
    rd_ptr_gray_ss <= rd_ptr_gray_s;
  end
end

//convert sync'd wr pointer to bin
always @(wr_ptr_gray_ss)
begin
  for(a=0; a<PTR_WIDTH; a=a+1) begin
    wr_ptr_bin_ss[a] = ^(wr_ptr_gray_ss >> a);
  end
end

//convert sync'd rd pointer to bin
always @(rd_ptr_gray_ss)
begin
  for(b=0; b<PTR_WIDTH; b=b+1) begin
    rd_ptr_bin_ss[b] = ^(rd_ptr_gray_ss >> b);
  end
end

//convert rd pointer to gray
always @(posedge rclk or posedge reset)
begin
  if (reset==1)
    rd_ptr_gray <= 0;
  else
  begin
    rd_ptr_gray <= (rd_ptr_bin >> 1) ^ rd_ptr_bin;
  end
end

//convert wr pointer to gray
always @(posedge wclk or posedge reset)
begin
  if (reset==1)
    wr_ptr_gray <= 0;
  else
  begin
   wr_ptr_gray <= (wr_ptr_bin >> 1) ^ wr_ptr_bin;
  end
end

>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
//consumer empty calculation
always @(rd_ptr_bin,wr_ptr_bin_ss)
begin
<<<<<<< HEAD
    if (fillcount == 6'b000000)
      empty_bar = 0; 
    else
      empty_bar = 1;
=======
  if (wr_ptr_bin_ss - rd_ptr_bin == 0)
    empty = 1; 
  else
    empty = 0;
>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
end

//producer full calculation
always @(wr_ptr_bin,rd_ptr_bin_ss)
begin
<<<<<<< HEAD
  //full_check = wr_ptr_bin - rd_ptr_bin_ss;
  if (fillcount == 6'b100000)
    full_bar = 0;
=======
  full_check = wr_ptr_bin - rd_ptr_bin_ss;
  if (full_check[PTR_WIDTH-1]==1 && |full_check[PTR_WIDTH-2:0]==0)
    full = 1;
>>>>>>> 7e87010823ca2b64ac7405466f5008d2734c2363
  else
    full = 0;
end

//qualified read enable
always @(*)
begin
  if (empty==0 && re==1) //not empty and you want to read
    renq = 1;
  else
    renq = 0;
end

//qualified write enable
always @(*)
begin
  if (full==0 && we==1) //not full & you want to write
    wenq = 1;
  else
    wenq = 0;
end 

//the producer
always @(posedge clk or posedge reset)
begin
  if (reset==1) begin
    wr_ptr <= 0; //wp = rp on reset
    for(i=0; i<FIFO_DEPTH; i=i+1) begin
      fifo[i] <= 0;
    end

  end
  else
  begin
    if (wenq==1)
      begin
        fifo[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
		fillcount <= fillcount + 1;
      end
  end
end

//the consumer
always @(posedge clk or posedge reset)
begin
  if (reset==1)
  begin 
    data_out <= 0;
    rd_ptr <= 0; //wp = rp on reset
		empty_bar <= 1;
	  full_bar <= 1;
	  fillcount <= 0;
  end
  else
  begin
    if (renq==1)
      begin
        data_out <= fifo[rd_ptr];
        rd_ptr <= rd_ptr + 1;
		fillcount <= fillcount -1;
      end
  end
end

assign empty_bar = ~empty;
assign full_bar  = ~full;

endmodule


