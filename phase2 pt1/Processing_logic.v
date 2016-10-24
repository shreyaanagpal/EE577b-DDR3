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
   parameter CK   = 1.87,    // Clock Period (min) (ns) 
             CL   = 8,      // CAS Latency  (in Tck)
             AL   = 6,      // Posted CAS# Additive Latency (in Tck), can be 0, CL-1, CL-2
             CWL  = 8,      // CAS Write Latency (assume same as CL?)
             RL   = 14,     // Min. delay between READ cmd and data being available on DQ (Read Latency = CL + AL)
             WL   = 14,     // Min. delay between WRITE cmd and data being latched in on DQ (Write Latency = CWL + AL)
             tRCD = 8,      // Min. delay between row strobe and column strobe (Row-to-Column) (in Tck)
             tRRD = 4, 	    // Min. delay between successive row activation (Row-to-Row Delay) (in Tck)
             tCCD = 4,      // Min. delay between successive read or write commands (Command-to-Command Delay) (in Tck)
             tFAW = 20,     // Maximum of 4 banks may be activated during this time (note: depends on page size, see Table 54) (in Tck)
             tRTP = 4,      // Min. delay between completion of read and begin of a precharge (Read-To-Precharge) (in Tck)
             tRP  = 8,      // Min. delay between completion of precharge and issue of a new command to same bank (in Tck)
             tRAS = 20;     // Min. delay between ACT cmd and PRECHARGE

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
   parameter CMD_NOP  = 3'd0,   // 000: No Operation (NOP)  
             CMD_SCR  = 3'd1,   // 001: Scalar Read  (SCR)
             CMD_SCW  = 3'd2,   // 010: Scalar Write  (SCW)
             CMD_BLR  = 3'd3,   // 011: Block Read (BLR)
             CMD_BLW  = 3'd4,   // 100: Block Write ((BLW)
             CMD_ATR  = 3'd5,   // 101: Atomic Read (ATR)
             CMD_ATW  = 3'd6,   // 110: Atomic Write (ATW)
             CMD_NOP2 = 3'd7;   // 111: No Operation (NOP)
   
   input 	 clk, ck, reset, ready;
   input 	 CMD_empty, RETURN_full;
   input [32:0]	 CMD_data_out;
   input [15:0]  DATA_data_out;
   input [15:0]  DQ_in;
   input [1:0]   DQS_in;
 
   output reg CMD_get;
   output reg DATA_get;
   output reg RETURN_put;
   output reg  [24:0] RETURN_address;
   output wire [15:0] RETURN_data;
   output reg cs_bar;
   output reg ras_bar;
   output reg cas_bar;
   output reg we_bar;
   output reg [1:0] BA;
   output reg [12:0] A;
   output reg [1:0] DM;
   output reg [15:0] DQ_out;
   output reg [1:0]  DQS_out;
   output reg ts_con;
   
   //internal signals
   reg [3:0] state;
   reg listen;
   reg DM_flag;
   integer i;
   reg [2:0] Pointer;
   reg read;
   reg write;
  
  //component instantiation
  ddr2_ring_buffer8 ring_buffer(RETURN_data, listen, DQS_in[0], Pointer[2:0], DQ_in, reset);

//----------------------Real Code Begins-----------------//

//FSM State Memory, NSL, OFL
always @(posedge clk) begin
  if(reset) begin 
    state          <= IDLE;
    CMD_get        <= 0;
    DATA_get       <= 0;
    RETURN_put     <= 0; 
    RETURN_address <= 0;
    cs_bar         <= 1;
    ras_bar        <= 1;
    cas_bar        <= 1;
    we_bar         <= 1;
    BA             <= 0;
    A              <= 0;
    DM             <= 0;
    DM_flag        <= 0;
    DQ_out         <= 0;
    DQS_out        <= 0;
    ts_con         <= 0;
    listen         <= 0;
    read           <= 0;
    write          <= 0;
  end
  else
    //default output values
    CMD_get    <= 1'b0;
    DATA_get   <= 1'b0;
    RETURN_put <= 1'b0;

    case (state)
      IDLE        : begin
                      listen <= 0;
                      {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b1111; //is this idle???
                      if (ready==1)  //initialization complete 
                      begin 
                        if (CMD_empty==0) //active-low!
                          state <= IDLE;
                        else //CMD FIFO not empty
                          begin
                          CMD_get <= 1'b1; 
                          state   <= DECODE;
                          end
                      end
                    end
                      
      DECODE      : begin
                    //Phase 2 pt.1 only supports NOP, ACT, SCR, SCW
                    case(CMD_data_out) //What bits dictate the command???

                      CMD_NOP  : begin
                                   state <= IDLE;
                                   {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                                 end      

                      CMD_SCR  : begin
                                   state <= ACTIVATE;
                                   read  <= 1;                   
                                 end

                      CMD_SCW  : begin
                                   state <= ACTIVATE;
                                   write <= 1;            
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
                  // {cs_bar, ras_bar, cas_bar, we_bar} <= ;
                    end 
      BANK_ACTIVE : begin end 
      ACTIVE_PD   : begin end 
      READ        : begin
                  // {cs_bar, ras_bar, cas_bar, we_bar} <= ;
                    end 
      WRITE       : begin 
                  // {cs_bar, ras_bar, cas_bar, we_bar} <= ;
                    end 
      READ_AP     : begin end 
      WRITE_AP    : begin end 
      PRECHARGE   : begin end 
      default: state <= IDLE;
 
    endcase 
end

//FSM OFL
//always @(current_state) 
//begin
//  if(reset) 
//    begin
//    end
//  else
//    begin
//    end
//end


always @(negedge clk)
  begin
    DQ_out <= DATA_data_out;
    if(DM_flag)
        DM <= 2'b00;
    else
        DM <= 2'b11;	
  end
 
endmodule // ddr_controller
