module Processing_logic(
  //Clock & Reset
  input             clk,
  input             ck,
  input             reset,
  input             ready, 

  //Data FIFO
  input      [15:0] DATA_data_out,
  output reg        DATA_get, 

  //Command FIFO
  input             CMD_empty,
  input      [33:0] CMD_data_out,
  output reg        CMD_get,

  //Return FIFO
  input             RETURN_full,
  output reg        RETURN_put, 
  output reg [25:0] RETURN_address, 
  output reg [15:0] RETURN_data,  

  //SSTL interface
  input      [15:0] DQ_in,
  input      [1:0]  DQS_in,
  input      [1:0]  DQS_bar_in,
  output reg        cs_bar,
  output reg        ras_bar, 
  output reg        cas_bar, 
  output reg        we_bar,  
  output reg [15:0] DQ_out,
  output reg [1:0]  DQS_out,
  output wire [1:0]  DQS_bar_out,
  output reg [2:0]  BA,
  output reg [12:0] A,
  output reg [1:0]  DM, 
  output reg        ts_con,
  output reg        ri_o
  );

  parameter BL = 4'd8; // Burst Length
  parameter BT = 1'd0; // Burst Type 0 (sequential)

  //Timing parameters for MT41J64M16, speed grade -187
  //See spec p1 Table 1, p2 Figure 1, p72 Table 51, p77 Table 54 
  parameter CK   = 3.2,      // Clock Period (min) (ns) 
            CL   = 10,       // CAS Latency  (in Tck)
            AL   = 6,        // Additive Latency (in Tck)
            CWL  = 10,       // CAS Write Latency --FIXME  
            RL   = AL + CL,  // delay betw. READ and data on DQ
            WL   = AL + CWL, // delay betw. WRITE and data latched on DQ
            tRCD = 16,       // delay betw. RAS# and CAS#
            tRRD = 8, 	     // delay between successive row activation 
            tCCD = 8,        // delay between successive read or write commands 
            tFAW = 40,       // Maximum of 4 banks may be activated during this time 
            tRTP = 8,        // delay betw. read complete and precharge begin
            tRP  = 16,       // delay betw. finish precharge and new cmd
            tRAS = 40,       // delay betw. ACT cmd and PRECHARGE
            tWR  = 10,       // Write Recovery 
            tDQSS = 0.25,    // delay betw. Tclk rise and DQS toggle
            tDQSH = 0.55,    // pulse width requirement for DQS high
	    tDQSL = 0.55,    // pulse width requirement for DQS low 
            tWPRE = 0.9,     //duration of write preamble
            tWPST = 0.3;     //duration of write postamble

  //DDR3 state machine encoding 
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
            READ         = 4'd11, 
            WRITE        = 4'd12, 
            READ_AP      = 4'd13, 
            WRITE_AP     = 4'd14,
            PRECHARGE    = 4'd15;
   
  //OPCODES taken from tb.v
  parameter CMD_NOP  = 'd0,   // 000: No Operation (NOP)  
            CMD_SCR  = 'd1,   // 001: Scalar Read  (SCR)
            CMD_SCW  = 'd2,   // 010: Scalar Write (SCW)
            CMD_BLR  = 'd3,   // 011: Block Read   (BLR)
            CMD_BLW  = 'd4,   // 100: Block Write  (BLW)
            CMD_ATR  = 'd5,   // 101: Atomic Read  (ATR)
            CMD_ATW  = 'd6,   // 110: Atomic Write (ATW)
            CMD_NOP2 = 'd7;   // 111: No Operation (NOP)

  //CS#,RAS#,CAS#,WE# (p98)	 
  parameter MRS = 4'b0000,
            REF = 4'b0001,
	    PRE = 4'b0010,
	    ACT = 4'b0011,
	    WR  = 4'b0100,
	    RD  = 4'b0101,
            NOP = 4'b0111,
            ZQ  = 4'b0110;
             
  //internal signals
  reg [3:0] state;  //state vector
  reg DM_flag;     

  //Ring Buffer
  reg         listen;       
  reg  [2:0]  ring_pointer;  
  wire [15:0] read_data;
 
  wire [1:0]  sz;
  wire [2:0]  op;
  wire [2:0]  cmd;
  wire [25:0] addr;
  wire [12:0] row_addr;
  wire [9:0]  col_addr;
  wire [2:0]  bank_addr;
  integer i;
 
  //Ring Buffer
  ddr3_ring_buffer8 ring_buffer(.dout(read_data), 
                                .listen(listen),
                                .strobe(DQS_in[0]),
                                .readPtr(ring_pointer[2:0]),
                                .din(DQ_in),
                                .reset(reset));

//----------------------Real Code Begins-----------------//
assign cmd         = CMD_data_out[33:31];
assign sz          = CMD_data_out[30:29]; 
assign op          = CMD_data_out[28:26];
assign addr        = CMD_data_out[25:0];
assign bank_addr   = addr[25:23];
assign row_addr    = addr[22:10]; 
assign col_addr    = addr[9:0];
assign DQS_bar_out = ~DQS_out;

//FSM State Memory, NSL, OFL 
always @(negedge clk, posedge reset) 
begin
  if(reset == 1) begin 
    state          <= IDLE;
    CMD_get        <= 0;
    DATA_get       <= 0;
    RETURN_put     <= 0; 
    RETURN_address <= 0;
    listen         <= 0;
    ts_con         <= 0; //tri-state active
    ri_o           <= 0; //receive inhibit active
    cs_bar         <= 0;
    ras_bar        <= 1;
    cas_bar        <= 1; 
    we_bar         <= 1;
    BA[2:0]        <= 3'd0;
    A[12:0]        <= 13'd0;
    DM[1:0]        <= 2'd0;
    DQ_out[15:0]   <= 16'd0;
    DQS_out        <= 2'd0;
    ring_pointer   <= 3'b0;
    i              <= 0;
  end
  else
  begin

    //default output values
    CMD_get    <= 1'b0;
    DATA_get   <= 1'b0;
    RETURN_put <= 1'b0;
    listen     <= 1'b0;
    ts_con     <= 1'b0; //tri-state by default
    ri_o       <= 1'b0; //inhibit receiver by default
	
    case (state)
      IDLE        : begin
                      ts_con <= 1'b0; //tri-state the interface
                      {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
                      if (ready==1)  //initialization complete 
                      begin
                        if (CMD_empty==0) //Connected to empty_bar: 0 means empty!
                          state <= IDLE;
                        else if(RETURN_full == 1) // Returnfull is fullbar ; 1 mean not full
		         begin
                           CMD_get  <= 1'b1;
		 	   i <= i + 1; 
			   if(i >= 1)
			     CMD_get  <= 1'b0;
		           if(i == 2)
			   begin
			     state <= DECODE;
			     i <= 0;
			   end
                         end
                      end
                    end
                      
      DECODE 	  : begin
                    //Phase 2 pt.1 only supports NOP, ACT, SCR, SCW
		    i <= i + 1;
                    case(CMD_data_out[33:31]) 
                      CMD_NOP  :begin
				{cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
				if(i == 1)
                                  begin
				  state <= IDLE;
                                  i <=0;
		       	          end
                                end      

                      CMD_SCR  : begin
				 BA      <= bank_addr;
				 A[12:0] <= row_addr; 
				 if(i == 1)
                                 begin
				   state <= ACTIVATE;
                                   i <=0;
				 end
                                 end

                      CMD_SCW  : begin
				 BA       <= bank_addr;
				 A[12:10] <= row_addr;
				 if(i == 1)
                                   begin
				    state <= ACTIVATE;
                                    i <=0;
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
      PRECHARGE_PD: begin end 
      MRS_MPR     : begin end 
      ZQ_CAL      : begin end 

      ACTIVATE    : begin 
		    i <= i+1;
	            if(i == 1)
	              begin
	                state    <= BANK_ACTIVE;
	                {cs_bar, ras_bar, cas_bar, we_bar} <= ACT; 
	                i<=0;
	              end
                    end 

      BANK_ACTIVE : begin
		    i <= i + 1;
                    BA <= bank_addr;
                    A  <= row_addr;
		    if(i>0)
		      {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		    else 
		      {cs_bar, ras_bar, cas_bar, we_bar} <= ACT; 
		    if(cmd == CMD_SCR && i == tRCD-1)
                      begin
                        BA     <= bank_addr;
                        A[12:0] <= {3'b000,col_addr}; //send column address
                        state  <= READ;
		        {cs_bar, ras_bar, cas_bar, we_bar} <= RD;
                        listen <= 1; //pulse ring buffer to listen to DQ & DQS
                        ri_o   <= 1; //disable receiver inhibit
                        i <= 0;
                      end
                    if(cmd == CMD_SCW && i == tRCD-1) //counter goes from 0 to tRCD-1 (total of tRCD cycles)
                      begin
		        BA      <= bank_addr;
                        A[12:0] <= {3'b000,col_addr}; //send column address
                        i       <= 0;
		        state   <= WRITE;
		        {cs_bar, ras_bar, cas_bar, we_bar} <= WR; 
		      end
                    end
 
      ACTIVE_PD   : begin end 

      READ        : begin
	   	      i       <= i+1;
	              BA      <= bank_addr;
	              A[12:0] <= {3'b000,col_addr}; //clear top 3 bits!
                      ri_o    <= 1;
                      if(i == (RL+8+tRTP))
	                begin
                          state <= PRECHARGE; 
                          ri_o  <= 0; //receiver inhibit
		          {cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
	                  i <= 0;
	                end
                      else if (i>0) 
                        {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		    end
				
      WRITE       : begin
       		      BA      <= addr[25:23];
       		      A[12:0] <= addr[9:0];
       		      i       <= i+1;
                      
                      //send WRITE command
                      if(i > 0)
		        {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		      else 
		        {cs_bar, ras_bar, cas_bar, we_bar} <= WR; 
                       
                      if (i == WL-3)
                        DATA_get <= 1'b1;
                      else
                        DATA_get <= 1'b0;
 
                      //drive DQS (before DQ) 
                      if(i>=WL-1 && i <= BL+WL)
			begin
                         ts_con <= 1; //enable the bus
	                 DQS_out[1:0] <= ~ DQS_out[1:0];
                        end

                      //drive DQ
                      if (i>=WL && i < BL+WL-1) 
                        begin
		          ts_con <= 1; //enable bus
                          DQ_out <= DATA_data_out;
                          DM <= 2'b00;
                        end

		//	else if (CMD_empty == 1)
                //        //need to check if we want to write again! (testbench loop)
		//	//also dont go to precharge if you still need to write...
                //          begin
                //            ts_con <= 0;
		//          end

       		      //issue precharge 
                      if (i == WL + 8 + tWR)
       		      begin
       			state <= PRECHARGE;
       			{cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
       			i <= 0;
       			DQS_out <= 2'b00;
       		      end

                    end 

      READ_AP     : begin end 
      WRITE_AP    : begin end 
      PRECHARGE   : begin 
                     
	  	      i <= i+1;
		      if( i > 0) 
		        {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
	      	      else
		        {cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
    		      if(i==1)
			begin
		  	  state <= IDLE;
		  	  {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
			  i <= 0;
			end
		end
      default: state <= IDLE;
 
	endcase 
  end
end

endmodule // ddr_controller
