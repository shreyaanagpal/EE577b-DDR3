module Processing_logic(
   // Outputs
   DATA_get, 
   CMD_get,
   RETURN_put, 
   RETURN_address, 
   RETURN_data,  
   cs_bar,
   ras_bar, 
   cas_bar, 
   we_bar,  
   BA,
   A, 
   DM,
   DQS_out,
   DQ_out,
   ts_con,
   // Inputs
   clk,
   ck,
   reset,
   ready, 
   CMD_empty, 
   CMD_data_out, 
   DATA_data_out,
   RETURN_full,
   DQS_in, 
   DQ_in
   );

   parameter BL = 4'd8; // Burst Length
   parameter BT = 1'd0; // Burst Type 0 (sequential)

   //Timing Parameters (in clock cycles) 
   //Assumption is DDR3-1000 (MT41J64M16, speed grade -187)
   //See spec p1 Table 1, p2 Figure 1, p72 Table 51, p77 Table 54 
   parameter CK   = 3.2,    // Clock Period (min) (ns) 
             CL   = 10,      // CAS Latency  (in Tck)
             AL   = 6,      // Posted CAS# Additive Latency (in Tck), can be 0, CL-1, CL-2
             CWL  = 10,      // CAS Write Latency (assume same as CL?)
             RL   = AL + CL,     // Min. delay between READ cmd and data being available on DQ (Read Latency = CL + AL)
             WL   = AL + CWL,     // Min. delay between WRITE cmd and data being latched in on DQ (Write Latency = CWL + AL)
             tRCD = 16,      // Min. delay between row strobe and column strobe (Row-to-Column) (in Tck)
             tRRD = 8, 	    // Min. delay between successive row activation (Row-to-Row Delay) (in Tck)
             tCCD = 8,      // Min. delay between successive read or write commands (Command-to-Command Delay) (in Tck)
             tFAW = 40,     // Maximum of 4 banks may be activated during this time (note: depends on page size, see Table 54) (in Tck)
             tRTP = 8,      // Min. delay between completion of read and begin of a precharge (Read-To-Precharge) (in Tck)
             tRP  = 16,      // Min. delay between completion of precharge and issue of a new command to same bank (in Tck)
             tRAS = 40,     // Min. delay between ACT cmd and PRECHARGE
			 tWR  = 10;		// pg 77 15ns
   //DDR3 state machine encoding -- see spec p.11 for FSM architecture
   parameter IDLE         = 4'd0,
             DECODE       = 4'd1, //Read from COMMAND FIFO and decode
             PUSH         = 4'd2, //Write to the RESULT FIFO 
             REFRESH      = 4'd3, 
             SELF_REFRESH = 4'd4, 
             PRECHARGE_PD = 4'd5,
             MRS_MPR      = 4'd6, 
             ZQ_CAL       = 4'd7, 
             ACTIVATE     = 4'd8, 
             BANK_ACTIVE  = 4'd9,
             ACTIVE_PD    = 4'd10,
             READ         = 4'd11, //READ state
             WRITE        = 4'd12, //WRITE stated
             READ_AP      = 4'd13, 
             WRITE_AP     = 4'd14,
             PRECHARGE    = 4'd15;
   
   //OPCODES taken from tb.v
   parameter CMD_NOP  = 'd0,   // 000: No Operation (NOP)  
             CMD_SCR  = 'd1,   // 001: Scalar Read  (SCR)
             CMD_SCW  = 'd2,   // 010: Scalar Write  (SCW)
             CMD_BLR  = 'd3,   // 011: Block Read (BLR)
             CMD_BLW  = 'd4,   // 100: Block Write ((BLW)
             CMD_ATR  = 'd5,   // 101: Atomic Read (ATR)
             CMD_ATW  = 'd6,   // 110: Atomic Write (ATW)
             CMD_NOP2 = 'd7;   // 111: No Operation (NOP)
   
   input 	 clk, ck, reset, ready;
   input 	 CMD_empty, RETURN_full;
   input [33:0]	 CMD_data_out;
   input [15:0]  DATA_data_out;
   input [15:0]  DQ_in;
   input [1:0]   DQS_in;
 
   output reg CMD_get;
   output reg DATA_get;
   output reg RETURN_put;
   output reg [25:0] RETURN_address;
   output reg [15:0] RETURN_data;
   output reg cs_bar;
   output reg ras_bar;
   output reg cas_bar;
   output reg we_bar;
   output reg [2:0] BA;
   output reg [12:0] A;
   output reg [1:0] DM;
   output reg [15:0] DQ_out;
   output reg [1:0]  DQS_out;
   output reg ts_con;
   
   //internal signals
   reg [3:0] state;
   reg listen;
   reg DM_flag;
   integer i,j;
   reg [2:0] Pointer;
   wire [1:0]  sz;
   wire [2:0]  op;
   wire [2:0]  cmd;
   wire [25:0] addr;
   wire [15:0] read_data;
   wire [12:0] row_addr;
   wire [9:0]  col_addr;
   wire [2:0]  bank_addr;
   integer counter;
  //component instantiation
  ddr3_ring_buffer8 ring_buffer(read_data, listen, DQS_in[0], Pointer[2:0], DQ_in, reset);

//----------------------Real Code Begins-----------------//
assign cmd       = CMD_data_out[33:31];
assign sz        = CMD_data_out[30:29]; 
assign op        = CMD_data_out[28:26];
assign addr      = CMD_data_out[25:0];
assign bank_addr = addr[25:23];
assign row_addr  = addr[22:10]; 
assign col_addr  = addr[9:0];

////OFL (operates at negedge)
//always @(negedge clk)
//begin
//  if (reset==1) begin
//    cs_bar  <= 0;
//    ras_bar <= 1;
//    cas_bar <= 1; 
//    we_bar  <= 1;
//    BA[2:0] <= 3'd0;
//    A[12:0] <= 13'd0;
//    DM[1:0] <= 2'd0;
//    DQ_out[15:0] <= 16'd0;
//    DQS_out[1:0] <= 2'd0;
//  end
//  else
//  case(state)
//    IDLE: begin
//            {cs_bar,ras_bar,cas_bar,we_bar} <= 4'b0111; //NOP
//            BA      <= 'bz;
//            A       <= 'bz;
//            DM      <= 'bz;
//            DQ_out  <= 'bz;
//            DQS_out <= 'bz; 
//          end
     
      

//FSM State Memory, NSL, 
always @(negedge clk) 
begin
  if(reset == 1) begin 
    state          <= IDLE;
    CMD_get        <= 0;
    DATA_get       <= 0;
    RETURN_put     <= 0; 
    RETURN_address <= 0;
    listen         <= 0;
    counter        <= 0;
    cs_bar         <= 0;
    ras_bar        <= 1;
    cas_bar        <= 1; 
    we_bar         <= 1;
    BA[2:0]        <= 3'd0;
    A[12:0]        <= 13'd0;
    DM[1:0]        <= 2'd0;
    DQ_out[15:0]   <= 16'd0;
  end
  else
  begin
    //default output values
    CMD_get    <= 1'b0;
    DATA_get   <= 1'b0;
    RETURN_put <= 1'b0;
	
    case (state)
      IDLE        : begin
                      listen <= 0;
                      {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //NOP
                      if (ready==1)  //initialization complete 
                      begin
                        if (CMD_empty==0) //Connected to empty_bar: 0 means empty!
                          state <= IDLE;
                        else if(RETURN_full == 1) // Returnfull is fullbar ; 1 mean not full
		         begin
                           CMD_get <= 1'b1;
		 	   counter <= counter + 1;
			   if(counter >= 1)
			     CMD_get <= 0;
		           if(counter == 2)
			   begin
			     state   <= DECODE;
			     counter <= 0;
			   end
                         end
                      end
                    end
                      
      DECODE 	  : begin
                    //Phase 2 pt.1 only supports NOP, ACT, SCR, SCW
		    counter <= counter + 1;
                    case(CMD_data_out[33:31]) 
                      CMD_NOP  :begin
				{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
				if(counter == 1)
                                  begin
				  state <= IDLE;
                                  counter <=0;
		       	          end
                                end      

                      CMD_SCR  : begin
				 BA      <= bank_addr;
				 A[12:0] <= row_addr; 
				 if(counter == 1)
                                 begin
				   state   <= ACTIVATE;
                                   counter <=0;
				 end
                                 end

                      CMD_SCW  : begin
				 BA       <= bank_addr;
				 A[12:10] <= row_addr;
				 if(counter == 1)
                                   begin
				    state <= ACTIVATE;
                                    counter <=0;
				   end
                                 end
		    
                      CMD_BLR  : begin end  
                      CMD_BLW  : begin end
                      CMD_ATR  : begin end      
                      CMD_ATW  : begin end 
                      CMD_NOP2 : begin end
                    endcase
                    end
 
      REFRESH     : begin end 
      SELF_REFRESH: begin end 
      PRECHARGE_PD: begin 
					
					end 
      MRS_MPR     : begin end 
      ZQ_CAL      : begin end 

      ACTIVATE    : begin 
		      counter <= counter + 1;
		      i <= i+1;
                      j <= j+1; //timing counter starts now.
						
					if(counter == 1)
					begin
						state    <= BANK_ACTIVE;
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
					        
						counter <= 0;
						i<=0;
					end
                   
                    end 

      BANK_ACTIVE : begin
		    counter <= counter + 1;
		    i <= i + 1;
                    BA <= bank_addr;
                    A  <= row_addr;
		    if(i>0)
		      {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
		    else 
		      {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
		    if(cmd == CMD_SCR && i == tRCD-1)
                      begin
                        BA     <= bank_addr;
                        A[12:0] <= {3'b000,col_addr}; //send column address
                        state  <= READ;
		        {cs_bar, ras_bar, cas_bar, we_bar} <=4'b0101 ;
                        i <= 0;
			counter <=0;
                      end
                    if(cmd == CMD_SCW && i == tRCD-1) //counter goes from 0 to tRCD-1 (total of tRCD cycles)
                      begin
		        BA      <= bank_addr;
                        A[12:0] <= {3'b000,col_addr}; //send column address
                        i       <= 0;
		        state   <= WRITE;
		        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
		        counter <= 0;
		      end
                    end
 
      ACTIVE_PD   : begin end 

      READ        : begin
	   	      counter <= counter +1;
	   	      i       <= i+1;
	              BA      <= bank_addr;
	              A[12:0]  <= {3'b000,col_addr}; //clear top 3 bits!
                      if(i == (RL+8+tRTP))
	                begin
                          state <= PRECHARGE;
						   listen <= 1;
		          {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0010;
	                  i <= 0;
		          counter <=0;
	                end
                      else if (i>0) 
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //NOP
		    end
				
                    
      WRITE       : begin
		      counter <= counter +1;
       		      BA <= addr[25:23];
       		      A  <= addr[9:0];
       		      i  <= i+1;
		      
                      if(i==WL-3)
			DATA_get <= 1'b1;
		      else
			DATA_get <= 1'b0;
		      
                      if(i>=WL-1 && i < BL+WL)
			begin
	                 DQS_out[1] <= ~ DQS_out[1] ;
			 DQS_out[0] <= ~ DQS_out[0] ;
			end
		      
                      if(i >0)
		        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
		      else 
		        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
       		      
                      if (i == WL + 8 + tWR)
       		      begin
       			state <= PRECHARGE;
       			{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0010;
       			i <= 0;
       			counter <=0;
       			DQS_out <= 2'b00;
       		      end
                    end 

      READ_AP     : begin end 
      WRITE_AP    : begin end 
      PRECHARGE   : begin 
                     
	  	      i <= i+1;
		      if( i > 0) 
		        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
	      	      else
		        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0010;
    		      if(i==1)
			begin
		  	  state <= IDLE;
		
		  	  {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
			i <= 0;
			end
		end
      default: state <= IDLE;
 
	endcase 
  end
end

always @(negedge clk)
  begin
    if((state == WRITE) && (i==WL ) && (ready == 1)) begin
	DQ_out <= DATA_data_out;
        DM <= 2'b00;
    end
    else
        DM <= 2'b11;	
  end
 
endmodule // ddr_controller
