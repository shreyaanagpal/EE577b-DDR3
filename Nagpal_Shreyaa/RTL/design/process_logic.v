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
  output wire [25:0] RETURN_address, 
  output wire [15:0] RETURN_data,  

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
            tWPST = 0.3,     //duration of write postamble
			tRFC  = 188;
  //DDR3 state machine encoding 
  parameter IDLE         = 5'd0,
            DECODE       = 5'd1, 
            PUSH         = 5'd2, //unused 
            REFRESH      = 5'd3, 
            SELF_REFRESH = 5'd4, 
            PRECHARGE_PD = 5'd5,
            MRS_MPR      = 5'd6, 
            ZQ_CAL       = 5'd7, 
            ACTIVATE     = 5'd8, 
            BANK_ACTIVE  = 5'd9,
            ACTIVE_PD    = 5'd10,
            READ         = 5'd11, 
            WRITE        = 5'd12, 
            READ_AP      = 5'd13, 
            WRITE_AP     = 5'd14,
            PRECHARGE    = 5'd15,
            BL_READ      = 5'd16,
            BL_READ_RING = 5'd20,
            BL_WRITE     = 5'd17,
            BL_WRITE_GATHER = 5'd21,
            AT_READ      = 5'd18,
            AT_WRITE     = 5'd19, 
            AT_PROCESS   = 5'd22;
   
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
  reg [6:0] state;  //state vector
  reg DM_flag;     

  //Ring Buffer
  reg         listen;       
  reg  [2:0]  ring_ptr;  
  wire [15:0] read_data;
 
  wire [1:0]  sz;
  wire [2:0]  op;
  wire [2:0]  cmd;
  wire [25:0] addr;
  wire [12:0] row_addr;
  wire [9:0]  col_addr;
  wire [2:0]  bank_addr;
  integer i,j, clkcount, blk_cnt;

  reg [1:0]  buff_sz;
  reg [2:0]  buff_op;
  reg [2:0]  buff_cmd;
  reg [25:0] buff_addr;
  reg [12:0] buff_row_addr;
  reg [9:0]  buff_col_addr;
  reg [2:0]  buff_bank_addr; 
  reg [15:0] buff_data[0:31];
  reg [15:0] atomic_data;
  reg flag_bl_read;
  reg flag_bl_write;
  reg flag_at_read;
  reg flag_at_write;
  //Ring Buffer
  ddr3_ring_buffer8 ring_buffer(.dout(read_data), 
                                .listen(listen),
                                .strobe(DQS_in[0]),
                                .readPtr(ring_ptr[2:0]),
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
assign RETURN_data = (cmd==CMD_ATW)?atomic_data:read_data;
assign RETURN_address = CMD_data_out[25:0];

//FSM State Memory, NSL, OFL 
always @(negedge clk, posedge reset) 
begin
  if(reset == 1) begin 
    state          <= IDLE;
    CMD_get        <= 0;
    DATA_get       <= 0;
    RETURN_put     <= 0; 
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
    ring_ptr       <= 3'b0;
    i              <= 0;
    j              <= 0;
    clkcount 	   <= 0;
    blk_cnt        <= 0;
    flag_bl_read   <= 0;
    flag_bl_write  <= 0;
	atomic_data    <= 0;
	flag_at_read   <= 0;
    flag_at_write  <= 0;
  end
  else
  begin
	
	if(ready == 1)
	clkcount <= clkcount +1;
	
    //default output values
    CMD_get    <= 1'b0;
    DATA_get   <= 1'b0;
    RETURN_put <= 1'b0;
    listen     <= 1'b0;
    //ts_con     <= 1'b0; //tri-state by default
    ri_o       <= 1'b0; //inhibit receiver by default
	
    case (state)
      IDLE        :  begin
                      ts_con <= 1'b0; //tri-state the interface
                      {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
                      if (ready==1)  //initialization complete 
                      begin
                        if (CMD_empty==0) //Connected to empty_bar: 0 means empty!
                          state <= IDLE;
                        else if(RETURN_full == 1) // Returnfull is fullbar ; 1 mean not full
		         begin
                           CMD_get  <= 1'b1;
			   DATA_get <= 1'b1;
		 	   i <= i + 1; 
			   if(i >= 1)
			   begin
			     CMD_get  <= 1'b0;
				 DATA_get <= 1'b0;
				end
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
				 BA      <= bank_addr;
				 A[12:0] <= row_addr;
				 if(i == 1)
                                   begin
				    state <= ACTIVATE;
                                    i <=0;
				   end
                                 end
		    
                      CMD_BLR  : begin 
				 BA      <= bank_addr;
				 A[12:0] <= row_addr;
				 if(i == 1)
                                   begin
				    state <= ACTIVATE;
                                    i <=0;
				   end
                                 end

                      CMD_BLW  : begin	
 			         BA      <= bank_addr;
				 A[12:0] <= row_addr;
				 if(i == 1)
                                   begin
				    state <= ACTIVATE;
                                    i <=0;
				   end
                                 end 

            CMD_ATR  : begin 
 			         BA      <= bank_addr;
				 A[12:0] <= row_addr;
                                 flag_at_read <= 1;
				 if(i == 1)
                                   begin
				    state <= ACTIVATE;
                                    i <=0;
				   end
                                 end 

                      CMD_ATW  : begin 
 			         BA      <= bank_addr;
				 A[12:0] <= row_addr;
                                 flag_at_write <= 1;
				 if(i == 1)
                                   begin
				    state <= ACTIVATE;
                                    i <=0;
				   end
                                 end 

                      CMD_NOP2 : begin 
				{cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
				if(i == 1)
                                  begin
				  state <= IDLE;
                                  i <=0;
		       	          end
                                end 
                    endcase
                    end
 
      REFRESH     : begin 
		      i <= i +1;
		      if(i > 0)
		        {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
	              else 
		        {cs_bar, ras_bar, cas_bar, we_bar} <= REF; 
	              if(i == tRFC -1)
		      begin
		        state <= IDLE;
			i <= 0;
			clkcount <= 0;
		      end
		    end
  
      SELF_REFRESH: begin end 
      PRECHARGE_PD: begin end 
      MRS_MPR     : begin end 
      ZQ_CAL      : begin end 

      ACTIVATE    : begin 
		    i <= i+1;
	            if(i == 1)
	              begin
	                state <= BANK_ACTIVE;
	                {cs_bar, ras_bar, cas_bar, we_bar} <= ACT; 
	                i<=0;
	              end
                    end 

      BANK_ACTIVE : begin
		    i <= i + 1;
                    BA <= bank_addr;
                    A[12:0]  <= row_addr;

		    if(i>0)
		      {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		    else 
		      {cs_bar, ras_bar, cas_bar, we_bar} <= ACT; 

                    //Scalar Read
		    if(cmd == CMD_SCR && i == tRCD-1)
                      begin
                        BA      <= bank_addr;
                        A[12:0] <= {col_addr,3'b000}; //send column address
                        state   <= READ;
			{cs_bar, ras_bar, cas_bar, we_bar} <= RD;
                        listen  <= 1; //pulse ring buffer to listen to DQ & DQS
                        ri_o    <= 1; //disable receiver inhibit
                        i       <= 0;
                      end
 
                    //Scalar Write
                    if(cmd == CMD_SCW && i == tRCD-1) //total of tRCD cycles
                      begin
			BA      <= bank_addr;
                        A[12:0] <= {col_addr, 3'b000}; //send column address
                        i       <= 0;
			state   <= WRITE;
			{cs_bar, ras_bar, cas_bar, we_bar} <= WR; 
		      end
               
                    //Block Read
                    if(cmd == CMD_BLR && i == tRCD-1)
                    begin
                      flag_bl_read   <= 0;
                      state          <= BL_READ;
                      BA             <= bank_addr;
                      A[12:0]        <= {col_addr, 3'b000}; 
                      listen         <= 1; 
                      ri_o           <= 1; 
                      i              <= 0;
                      if (sz==2'b00)        begin blk_cnt <= 8;  end
                      else if (sz == 2'b01) begin blk_cnt <= 16; end
                      else if (sz == 2'b10) begin blk_cnt <= 24; end
                      else if (sz == 2'b11) begin blk_cnt <= 32; end
                      {cs_bar, ras_bar, cas_bar, we_bar}  <= RD; 
                    end

                    //Block Write
                    if(cmd == CMD_BLW && i == tRCD-1)
                    begin
                      if (flag_bl_write == 0) //only do this the first time
                        begin
                          //buffer CMD FIFO output for later use
                          buff_sz        <= sz;
                          buff_op        <= op;
                          buff_cmd       <= cmd;
                          buff_addr      <= addr;
                          buff_row_addr  <= row_addr;
                          buff_col_addr  <= col_addr;
                          buff_bank_addr <= bank_addr;
                          flag_bl_write  <= 1;
                          i              <= 0;
                          if (sz==2'b00)        begin blk_cnt <= 8;  end
                          else if (sz == 2'b01) begin blk_cnt <= 16; end
                          else if (sz == 2'b10) begin blk_cnt <= 24; end
                          else if (sz == 2'b11) begin blk_cnt <= 32; end                       
                        end
                    end
                    else if (flag_bl_write == 1)
                    begin
                      state <= BL_WRITE_GATHER;
					  {cs_bar, ras_bar, cas_bar, we_bar} <= NOP;
                      i <= 0;
                    end
      
                  //Atomic Read
                    if((cmd == CMD_ATR || cmd == CMD_ATW) && i == tRCD-1)
                    begin
                      BA      <= bank_addr;
                      A[12:0] <= {col_addr,3'b000}; //send column address
                      state   <= AT_READ;
		      {cs_bar, ras_bar, cas_bar, we_bar} <= RD;
                      listen  <= 1; //pulse ring buffer to listen to DQ & DQS
                      ri_o    <= 1; //disable receiver inhibit
                      i       <= 0;
                      if (cmd == CMD_ATR)
                        flag_at_read <= 1;
                      else if (cmd == CMD_ATW)
                        flag_at_write <= 1;
                    end

                    end
 
      ACTIVE_PD   : begin end 

      READ        : begin
	   	      i       <= i+1;
	              BA      <= bank_addr;
	              A[12:0] <= {col_addr, 3'b000}; //clear top 3 bits!
                      ri_o    <= 1;
                      if(i == (RL+8+tRTP))
	                begin
                          state <= PRECHARGE; 
                          ri_o  <= 0; //receiver inhibit
		          {cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
			  i <= 0;
		          RETURN_put <= 1;
	                end
                      else if (i>0) 
                        {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		    end
				
      WRITE       : begin
       		      BA      <= bank_addr;
       		      A[12:0] <= {col_addr, 3'b000};
       		      i       <= i+1;
                  RETURN_put <=0;
                      //send WRITE command
                      if(i > 0)
		        {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		      else 
		        {cs_bar, ras_bar, cas_bar, we_bar} <= WR; 
 
                      //drive DQS (before DQ) 
                    
						
                      //drive DQ
                      if (i>=WL && i <= BL+WL-1) 
                        begin
			ts_con <= 1; //enable bus
                        DQ_out <= DATA_data_out;
                        end
				if(cmd == CMD_ATW && i == 1)
				begin
					RETURN_put <= 1;
					//RETURN_data <= atomic_data;
				end
				
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
                    RETURN_put <= 0;  
		    i <= i+1;
		    if( i > 0) 
		    {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		    else
		    {cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
	
		    if(clkcount >= 4800 && clkcount <= 4875)
		    begin
		  	if(i==11)
		   	begin
			state <= REFRESH;
		    	i <= 0;
		    	{cs_bar, ras_bar, cas_bar, we_bar} <= REF;
		    	end
		    end
		    else if(i==11)
		    begin
		    	state <= IDLE;
		    	{cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		    	i <= 0;
		    end
	           end

      BL_READ: begin
                 //first block of 8 are being received 
                 i <= i+1;
                 if (flag_bl_read == 0) //only do this on entering the first time 
                 begin 
	           BA      <= bank_addr;
	           A[12:0] <= {col_addr, 3'b000}; //clear top 3 bits!
                   ri_o    <= 1;
                 end 
                 
                 if(i == RL+BL)  //safe to empty ring buffer
	         begin
                  blk_cnt      <= blk_cnt - 8; //successfull received 8 blocks (words)
                  state        <= BL_READ_RING;  //empty the ring buffer;
                  RETURN_put   <= 1;   //place result in RETURN
                  ring_ptr <= 0;
                  i            <= 0;
                  flag_bl_read <= 1;
                 end
                 else if (i>0)
                   {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
                 else 
                   {cs_bar, ras_bar, cas_bar, we_bar} <= RD;
               end
 
      BL_READ_RING: begin 
                    i <= i+1;
                    if (ring_ptr == 3'd7) //ring buffer empty
                      if (blk_cnt == 0) //block read is complete
                        if (i==tRTP)
                        begin
                          state <= PRECHARGE;
                          {cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
                          flag_bl_read <= 0; //clear
                          i <= 0;
                        end
                      else //block read is not complete
                        begin
                          state   <= BL_READ;
                          BA      <= bank_addr;
                          A[12:0] <= {col_addr, 3'b000} + 4'd8; //add 8 to column since you read 8 words 
                          ri_o    <= 1; //disable receiver inhibit
                          listen  <= 1; //pulse ring buffer 
                          i       <= 0;
                          {cs_bar, ras_bar, cas_bar, we_bar} <= RD;
                        end
                    else //ring buffer is not yet empty
                      begin 
                        ring_ptr <= ring_ptr+1; //increment
                        RETURN_put   <= 1;
                        i            <= 0;
                      end

                    end

      BL_WRITE: begin
       		  BA      <= buff_bank_addr;
       		  A[12:0] <= {buff_col_addr, 3'b000};
       		  i       <= i+1;
			if(i > 0)
		    {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
		  else 
		    {cs_bar, ras_bar, cas_bar, we_bar} <= WR;    
                  if (blk_cnt == 0) //no more blocks to write
                  begin
                    //issue precharge  
                    if (i == WL + 8 + tWR)
       		    begin
       		      state <= PRECHARGE;
       		      {cs_bar, ras_bar, cas_bar, we_bar} <= PRE; 
       		      DQS_out <= 2'b00;
                    i <= 0; 
                    j <= 0;
                    flag_bl_write <= 0;
       		    end 
                  end
                 // else //block count > 0
                //  begin
                    //drive DQS (before DQ) 
					if(blk_cnt == 0)
					begin
                    
					  if(i>WL-2 && i <= BL+WL-2)
					  begin
					   DQ_out  <= buff_data[j];
						j <= j +1;
					  end
					end
					else 
					begin
						if(i>WL-2 && i <= BL+WL-2)
						begin
							DQ_out  <= buff_data[j];
							j <= j +1;
						end
					if (i==BL+WL+1) //drive DQ
                      begin
		         
                        blk_cnt <= blk_cnt - 8;
                        i       <= 0;
                       
                        //safe to drive next write
                        BA      <= buff_bank_addr;
                        A[12:0] <= {buff_col_addr, 3'b000} + 8;
                        {cs_bar, ras_bar, cas_bar, we_bar} <= WR;
                      end
					  end
                //  end  
                    
                              
 
                end
                //need to add new data on each two clock edgtes
      
      BL_WRITE_GATHER: begin
						 //capture all the data you want to send
                       if (j <= blk_cnt)
                       begin
                         buff_data[j] <= DATA_data_out;
                         //CMD_get  <= 1; //advance CMD FIFO
                         DATA_get <= 1; //advance DATA FIFO 
                         j <= j+1;
                       end
                       else
                       begin 
                         //captured everything, start writing
                         BA      <= buff_bank_addr;
                         A[12:0] <= {buff_col_addr, 3'b000};
                         j       <= 0;
                         state   <= BL_WRITE; 
                         {cs_bar, ras_bar, cas_bar, we_bar} <= WR;
                         blk_cnt <= blk_cnt - 8;
                         
                       end
                       end
              
    AT_READ: begin 
                 i       <= i+1;
                 BA      <= bank_addr;
                 A[12:0] <= {col_addr, 3'b000}; //clear top 3 bits!
                 ri_o    <= 1;
                 ring_ptr <= 3'b0; 
                 if(i == (RL+8)+tRTP) //wait tRTP to let ring bufer capture everything just in case
                   //note that you also need to wait before writing back data after reading!
                   //is above enough time to meet the write after read timing???
                   begin
                     state    <= AT_PROCESS; 
                     ri_o     <= 0; //receiver inhibit
                     i        <= 0;
                     atomic_data <= read_data; //take from ring buffer 
                     if (flag_at_read == 1 && cmd == CMD_ATR)
                     begin
                       RETURN_put   <= 1; //also place original in RETURN FIFO
                       flag_at_read <= 0; //clear flag
                     end
                   end
                 else if (i>0) 
                   {cs_bar, ras_bar, cas_bar, we_bar} <= NOP; 
               end

      AT_PROCESS: begin 
                  i <= i + 1;

                  if (i == 0) 
                  begin
                    if (op == 3'd0) //NOT
                        atomic_data <= ~atomic_data;
                    else if (op == 3'd1) //ADD
                        atomic_data <= atomic_data + DATA_data_out;
                    else if (op == 3'd2) //OR
                        atomic_data <= atomic_data | DATA_data_out;
                    else if (op == 3'd3) //AND
                        atomic_data <= atomic_data & DATA_data_out;
                    else if (op == 3'd4) //XOR
                        atomic_data <= atomic_data ^ DATA_data_out;
                    else if (op == 3'd5) //RTTH
                        atomic_data <= {atomic_data[7:0],atomic_data[15:8]};
                    else if (op == 3'd6) //SRA
                        atomic_data <= {1'b0, atomic_data[15:1]};
                    else if (op == 3'd7) //SLA
                        atomic_data <= {atomic_data[14:0], 1'b0};
                  end 
                  else if(clkcount % 2 == 1)
                  begin
                    BA      <= bank_addr;
                    A[12:0] <= {col_addr, 3'b000}; //send column address
                    i       <= 0;
		    state   <= WRITE;
		    {cs_bar, ras_bar, cas_bar, we_bar} <= WR;  
                  end
                     
                 end
      AT_WRITE: begin end
      default: state <= IDLE;
 
	endcase 
  end
end




always @(posedge clk)
begin
	if(reset == 1)
	begin
		ts_con <= 0;
		DQS_out <= 2'b0;
		DM <= 0;
	end
	else if(state == BL_WRITE && i>=WL-1 && i <= BL+WL)
	begin
        ts_con <= 1; //enable the bus
		DQS_out[1:0] <= ~ DQS_out[1:0];
        DM <= 2'b00;
    end
	else if(state == WRITE && i>= WL-1 && i <= BL+WL)
			begin
             ts_con <= 1; //enable the bus
			 DQS_out[1:0] <= ~ DQS_out[1:0];
			DM <= 2'b00;
			end
end

endmodule // ddr_controller