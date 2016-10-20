//------------------------------
// Title : 2 Clock Async FIFO
// Author: Najib Hourani
// USC ID: 7152521623
// E-mail: nhourani@usc.edu
//------------------------------

module FIFO_2clk (rclk, wclk, reset, we, re, data_in, empty_bar, full_bar, data_out);

parameter DATA_WIDTH = 32,
          FIFO_DEPTH = 16,
          PTR_WIDTH  = $clog2(FIFO_DEPTH)+1;
//inputs
input rclk, wclk, reset, we, re;
input [DATA_WIDTH-1:0] data_in;

//outputs
output empty_bar, full_bar, data_out;

//output types
reg empty_bar, full_bar;
reg [PTR_WIDTH-1:0] full_check;
reg [DATA_WIDTH-1:0] data_out;

//internal signals
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
    for(c=0; c<PTR_WIDTH-1; c=c+1) begin
      rd_ptr_gray[c] <= rd_ptr_bin[c] ^ rd_ptr_bin[c+1]; 
    end
  end
end

//convert wr pointer to gray
always @(posedge wclk or posedge reset)
begin
  if (reset==1)
    wr_ptr_gray <= 0;
  else
  begin
    for(d=0; d<PTR_WIDTH-1; d=d+1) begin
      wr_ptr_gray[d] <= wr_ptr_bin[d] ^ wr_ptr_bin[d+1]; 
    end
  end
end

//consumer empty calculation
always @(*)
begin
    if (wr_ptr_bin_ss - rd_ptr_bin == 0)
      empty_bar = 0; 
    else
      empty_bar = 1;
end

//producer full calculation
always @(*)
begin
  full_check = wr_ptr_bin - rd_ptr_bin_ss;
  if (full_check[PTR_WIDTH-1]==1 && |full_check[PTR_WIDTH-2:0]==0)
    full_bar = 0;
  else
    full_bar = 1;
end

//the producer
always @(posedge wclk or posedge reset)
begin
  if (reset==1) begin
    wr_ptr_bin <= 0; //wp = rp on reset
    for(e=0; e<FIFO_DEPTH; e=e+1) begin
      fifo[e] <= 0;
    end
  end
  else
  begin
    if (full_bar==1) //FIFO is not full -- safe to produce
    begin
      if (we==1)
      begin
        fifo[wr_ptr_bin[PTR_WIDTH-2:0]] <= data_in;
        wr_ptr_bin <= wr_ptr_bin + 1;
      end
    end
  end
end

//the consumer
always @(posedge rclk or posedge reset)
begin
  if (reset==1)
  begin 
    data_out <= 0;
    rd_ptr_bin <= 0; //wp = rp on reset
  end
  else
  begin
    if (empty_bar==1) //FIFO is not empty--safe to consume
    begin
      if (re==1)
      begin
        data_out <= fifo[rd_ptr_bin[PTR_WIDTH-2:0]];
        rd_ptr_bin <= rd_ptr_bin + 1;
      end
    end
  end
end

endmodule


