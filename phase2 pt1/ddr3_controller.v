
module ddr3_controller(
   // Outputs
   dout, raddr, fillcount, notfull, ready, ck_pad, ckbar_pad,
   cke_pad, csbar_pad, rasbar_pad, casbar_pad, webar_pad, ba_pad,
   a_pad, dm_pad, odt_pad,resetbar_pad, validout, 
   // Inouts
   dq_pad, dqs_pad, dqsbar_pad,
   // Inputs
   clk, reset, read, cmd, din, sz,
   op,addr, initddr
   );
   
///////////////////////////////task1: determine the parameters ///////////////////////////////////////
   parameter BL = 8; // Burst Lenght = 8
   parameter BT = 0;   // Burst Type = Sequential
   parameter CL = 4;  // CAS Latency (CL) = 4
   parameter AL = 3;  // Posted CAS# Additive Latency (AL) = 3
/////////////////////////////////////////////////////////////////////////////////////////////////////
   input [1:0] sz;
   input [2:0] op;
   input clk;
   input reset;
   input read;
   input [2:0]   cmd;
   input [15:0]  din;
   input [25:0]  addr;
   output [15:0] dout;
   output [25:0] raddr;
   output [5:0]  fillcount;
   output notfull;
  // output	 notempty;
   input  initddr;
   output ready;
   output ck_pad;
   output ckbar_pad;
   output cke_pad;
   output csbar_pad;
   output rasbar_pad;
   output casbar_pad;
   output webar_pad;
   output resetbar_pad;
   output [2:0]  ba_pad;
   output [12:0] a_pad;
   inout  [15:0] dq_pad;
   inout  [1:0]  dqs_pad;
   inout  [1:0]  dqsbar_pad;
   output [1:0]  dm_pad;
   output 	 odt_pad;
   output validout;
   
   reg validout;
   
   /*autowire*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [15:0]	dataOut;				// From XDFIN of fifo.v
   wire [15:0]	dq_o;					// From XSSTL of SSTL18DDR2INTERFACE.v
   wire [1:0]	dqs_o;					// From XSSTL of SSTL18DDR2INTERFACE.v
   wire [1:0]	dqsbar_o;				// From XSSTL of SSTL18DDR2INTERFACE.v
   wire		notfull;				// From XDFIN of fifo.v
   wire [5:0]	CMD_fillcount, RETURN_fillcount, fillcount;		// From XDFIN of fifo.v
   wire		full;				// From XDFIN of fifo.v
   // End of automatics
   
   wire	 ri_i;
   wire	 ts_i;   
   reg 	 ck_i;
   wire	 cke_i;
   wire	 csbar_i;
   wire	 rasbar_i;
   wire	 casbar_i;
   wire	 webar_i;
   wire [2:0]  ba_i;
   wire [12:0] a_i;
   wire [15:0] dq_i;
   wire [1:0]  dqs_i;
   wire [1:0]  dqsbar_i;
   wire [1:0]  dm_i;
   wire	 odt_i;
   wire	 resetbar_i;
   reg ck;
   wire csbar, init_csbar;
   wire rasbar, init_rasbar;
   wire casbar, init_casbar;
   wire webar, init_webar;
   wire[2:0] ba, init_ba;
   wire[12:0] a,init_a;
   wire[1:0] dm, init_dm;
   wire init_cke;
   wire ri_con;
   wire init_odt;
   wire init_ts_con;
   wire reset_out;
   wire [33:0] CMD_data_in, CMD_data_out;
   wire [41:0] RETURN_data_in, RETURN_data_out;
   wire CMD_empty, CMD_full, RETURN_empty, RETURN_full;
   wire IN_put, IN_get, CMD_get, RETURN_put, RETURN_get;
   reg CMD_put;
   wire DATA_empty;
  
   // CK divider
   always @(posedge clk) 
     if(reset==1)
		begin
         ck_i <= 0;
		 CMD_put <= 0;
		end
     else
		begin
			ck_i <= ~ck_i; 
			if(ready == 1)
			CMD_put <= 1'b1;
		end
		// 312 MHz Clock (625/2 MHz)
assign resetbar_i = ~reset && reset_out;

///////////////////////////////task2: determine the FIFO connections ///////////////////////////////////
// Command FIFO						  
     
   FIFO_2clk #(16,32,6) FIFO_DATA (/*autoinst*/
				  .rclk		(clk),
				  .wclk         (clk),
				  .reset	(reset),
				  .data_in      (din),
				  .we    	(IN_put),
				  .re		(IN_get),
				  .data_out	(dataOut),
				  .empty_bar	(DATA_empty),
	  		          .full_bar     (notfull),
				  .fillcount	(fillcount)
				  ); 

// Command FIFO						  
  FIFO_2clk #(34,32,6) FIFO_CMD (/*autoinst*/
				  .rclk		(clk),
				  .wclk         (clk),
				  .reset	(reset),
				  .data_in      (CMD_data_in),
				  .we   	(CMD_put),
				  .re		(CMD_get),
				  .data_out	(CMD_data_out),
				  .empty_bar	(CMD_empty),
	  		   	  .full_bar     (CMD_full),
				  .fillcount	(CMD_fillcount)
				  ); 

// Return DATA and address FIFO	
  FIFO_2clk #(42,32,6) FIFO_RETURN (/*autoinst*/
				  .rclk		(clk),
				  .wclk         (clk),

				  .reset	(reset),
				  .data_in      (RETURN_data_in),
				  .we   	(RETURN_put),
				  .re		(RETURN_get),
				  .data_out	(RETURN_data_out),
				  .empty_bar	(RETURN_empty),
 	     		          .full_bar    	(RETURN_full),
				  .fillcount	(RETURN_fillcount)
				  ); 
/////////////////////////////////////////////////////////////////////////////////////////////////////
   
   // DDR2 Initialization engine
   ddr3_init_engine XINIT (
				  // Outputs
				  .ready		(ready),
				  .csbar		(init_csbar),
				  .rasbar		(init_rasbar),
				  .casbar		(init_casbar),
				  .webar		(init_webar),
				  .ba			(init_ba[2:0]),
				  .a			(init_a[12:0]),
				//  .dm		(init_dm[1:0]),
				  .odt			(init_odt),
				  .ts_con		(init_ts_con),
				  .cke                 (init_cke),
				  // Inputs
				  .clk			(clk),
				  .reset		(reset),
				  .init		(initddr),
				  .ck			(ck),	
				  .reset_out		(reset_out)	);


Processing_logic PLOGIC (
                                  //outputs
                                  .DATA_get       (IN_get),     //read from DATA FIFO
                                  .CMD_get        (CMD_get),    //read from CMD  FIFO
                                  .RETURN_put     (RETURN_put), //write to RETURN FIFO 
                                  .RETURN_address (RETURN_data_in[41:16]), //RETURN address 
				  .RETURN_data    (RETURN_data_in[15:0]),  //RETURN data 
                                  .cs_bar         (csbar),
                                  .ras_bar        (rasbar),
                                  .cas_bar        (casbar),
                                  .we_bar         (webar),
                                  .BA             (ba),
                                  .A              (a), 
                                  .DM             (dm_i),
                                  .DQS_out        (dqs_o),
                                  .DQ_out         (dq_o),
                                  .ts_con         (ts_i),
                                  // Inputs
                                  .clk            (clk),
                                  .ck             (ck_i),
                                  .reset          (reset),
                                  .ready          (ready),
                                  .CMD_empty      (CMD_empty),
                                  .CMD_data_out   (CMD_data_out), 
                                  .DATA_data_out  (dataOut),
                                  .RETURN_full    (RETURN_full),
                                  .DQS_in         (dqs_i),
                                  .DQ_in          (dq_i)
                             );
  // Output Mux for control signals
   assign a_i 	   = (ready) ? a      : init_a;
   assign ba_i 	   = (ready) ? ba     : init_ba;
   assign csbar_i  = (ready) ? csbar  : init_csbar;
   assign rasbar_i = (ready) ? rasbar : init_rasbar;
   assign casbar_i = (ready) ? casbar : init_casbar;
   assign webar_i  = (ready) ? webar  : init_webar;
   assign cke_i	   = init_cke;
   assign odt_i	   = init_odt;
   assign ri_con   = 1;
   assign CMD_data_in = {cmd, sz, op, addr};

   SSTL18DDR3INTERFACE XSSTL (/*autoinst*/
							  // Outputs
							  .ck_pad		(ck_pad),
							  .ckbar_pad		(ckbar_pad),
							  .cke_pad		(cke_pad),
							  .csbar_pad		(csbar_pad),
							  .rasbar_pad		(rasbar_pad),
							  .casbar_pad		(casbar_pad),
							  .webar_pad		(webar_pad),
							  .ba_pad		(ba_pad[2:0]),
							  .a_pad		(a_pad[12:0]),
							  .dm_pad		(dm_pad[1:0]),
							  .odt_pad		(odt_pad),
							  .dq_o			(dq_o[15:0]),
							  .dqs_o		(dqs_o[1:0]),
							  .dqsbar_o		(dqsbar_o[1:0]),
							  .resetbar_pad	        (resetbar_pad),
							  // Inouts
							  .dq_pad		(dq_pad[15:0]),
							  .dqs_pad		(dqs_pad[1:0]),
							  .dqsbar_pad		(dqsbar_pad[1:0]),
							  // Inputs
							  .ri_i			(ri_i),
							  .ts_i			(ts_i),
							  .ck_i			(ck_i),
							  .cke_i		(cke_i),
							  .csbar_i		(csbar_i),
							  .rasbar_i		(rasbar_i),
							  .casbar_i		(casbar_i),
							  .webar_i		(webar_i),
							  .ba_i			(ba_i[2:0]),
							  .a_i			(a_i[12:0]),
							  .dq_i			(dq_i[15:0]),
							  .dqs_i		(dqs_i[1:0]),
							  .dqsbar_i		(dqsbar_i[1:0]),
							  .dm_i			(dm_i[1:0]),
							  .odt_i		(odt_i),
							  .resetbar_i		(resetbar_i));

endmodule // ddr2_controller
