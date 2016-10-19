// Define Counter Values by setting the counter value for each stage in the INIT process
// There is a NOP command issued 1 DDR clock cycle after most commands
// More information about each stage is in the Verilog code below

`define S_NOP1	17'd100000 // Send NOP with CKE low
`define S_CKE	17'd100002 // Set CKE High
`define S_PRE1	17'd100202 // First Precharge
`define S_NOP2	17'd100204 // NOP after Precharge
`define S_EMRS2	17'd100214 // Set EMRS 2
`define S_NOP3 	17'd100216 // NOP after EMRS 2
`define S_EMRS3	17'd100218 // Set EMRS 3
`define S_NOP4	17'd100220 // NOP after EMRS 3
`define S_DLL	17'd100222 // DLL Set
`define S_NOP5	17'd100224 // NOP after DLL Set
`define S_DLLR	17'd100226 // DLL Reset
`define S_NOP6	17'd100228 // NOP after DLL Reset
`define S_PRE2	17'd100230 // 2nd Precharge
`define S_NOP7	17'd100232 // NOP after 2nd Precharge
`define S_AUTO1	17'd100252 // Part 1 of Auto Refresh
`define S_NOP8	17'd100254 // NOP after Auto Refresh 1
`define S_AUTO2 17'd100308 // Send Auto Refresh
`define S_NOP9	17'd100310 // NOP after Auto Refresh 2
`define S_MRS	17'd100368 // Set MRS register
`define S_NOP10	17'd100370 // NOP afer MRS
`define S_EMRS1	17'd100372 // Set EMRS1 register
`define S_NOP11	17'd100374 // NOP after EMRS1
`define S_OCD	17'd100376 // OCD Calibration
`define S_NOP12 17'd100378 // NOP after OCD calibration
`define S_PRE3	17'd100680 // Third Precharge
`define S_NOP13	17'd100682 // NOP after Precharge
`define S_ODT	17'd100688 // Raise ODT When memory is ready
`define S_DONE	17'd100690 // Memory is ready

/////////////////////////////////////////////////////////


module ddr2_init_engine(
   // Outputs
   ready, csbar, rasbar, casbar, webar, ba, a, odt, ts_con, cke,
   // Inputs
   clk, reset, init, ck
   );


input clk, reset, init, ck;
output ready, csbar, rasbar, casbar, webar, odt, ts_con, cke;
output [1:0] ba;
output [12:0] a;

reg ready;
reg cke;
reg csbar;
reg rasbar;
reg casbar;
reg webar;
reg [1:0] ba;
reg [12:0] a;
reg odt;
reg [15:0] dq_out;
reg [1:0] dqs_out;
reg [1:0] dqsbar_out;   
reg ts_con;
reg INIT, RESET;
   
reg [16:0]  counter;
reg flag;

always @(posedge clk)
begin
	INIT <= init;
	RESET <= reset;

	if (RESET)
	begin
		flag <= 0;
		cke <= 0;
		odt <= 0;
		a <= 0;
		ba <= 0;
		ts_con <= 0;
		csbar <= 0;
		rasbar <= 0;
		webar <= 0;
		ready <= 0;
	end
	else if (flag == 0 && INIT == 1)
	begin
		// On INIT signal, set a flag to start the initialization routine and clear the counter
		flag <= 1;
		counter <= 0;
	end
	else if (flag == 1)
	begin
		counter <= counter + 1;
		case (counter)
		// Use a case statement to match counter values to specific commands issued to the DDR2 chip
		// TASK: Fill in the correct counter values in the definitions at the beginning of the file
		// and fill in any missing signal values to set up the DDR2 chip correctly in the following code

		// INIT Waits for 200 microseconds
        	`S_NOP1:  begin
			{csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command
			end
	        `S_CKE:  begin // Enable CKE high
			cke <= 1;
			end
	// ----------------------------------------------------------
        // Precharge All
        // ----------------------------------------------------------
        // Wait for minimum of 400ns then issue precharge all command.
		
		`S_PRE1: begin // Precharge all banks
			{csbar, rasbar, casbar, webar} <= 4'b0010; // Precharge all banks command
			a[10] <= 1;
			end
		`S_NOP2: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // Set EMRS(2)
        // ----------------------------------------------------------
        // EMRS(2) is reserved for future use and all bits except
        // BA0 and BA1 must be programmed to 0 when setting
        // the mode register during initialization.

        	`S_EMRS2: begin
                	{csbar, rasbar, casbar, webar} <=  4'b0000; // EMRS command
                	a <= 'b0;
			ba <= 2'b10;
	                end
                `S_NOP3: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // Set EMRS(3)
        // ----------------------------------------------------------
        // EMRS(3) is reserved for future use and all bits except
        // BA0 and BA1 must be programmed to 1 when setting
        // the mode register during initialization.

	        `S_EMRS3: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0000; // EMRS command 
        	        a <= 'b0;
        	        ba <= 2'b11;
	                end
                `S_NOP4: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // DLL Enable
        // ----------------------------------------------------------
        // Issue EMRS to enable DLL. (To issue "DLL Enable" command,
        //  provide "Low" to A0, "High" to BA0 and "Low" to BA1 and A12.)
        // Rest of the values are set to desired values too (else it throws errors)

	        `S_DLL: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0000; // EMRS command
        	        a[0] <= 0; // DLL Enable
               		a[1] <= 0; // Output Driver
                	a[2] <= 0; // Rtt ODT
                	a[6] <= 0; // Rtt ODT

			// FILL IN VALUES
                	a[5:3] <= 3'b011; // Additive CAS
                	a[9:7] <= 3'b111; // OCD Calibration Program
			//

                	a[10] <= 1; //DQS_bar disabled
                	a[11] <= 0; // RDQS
                	a[12] <= 0; // Qoff
                	ba <= 2'b01; // Address of EMRS1
	                end
                `S_NOP5: {csbar, rasbar, casbar, webar} <= 4'b0111 ; // NOP command

        // ----------------------------------------------------------
        // DLL Reset
        // ----------------------------------------------------------
        // Issue a Mode Register Set command for DLL reset
        // (To issue DLL reset command, provide "High" to A8 and "Low" to BA0-1).

	        `S_DLLR: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0000 ; // EMRS command 
        	        // FILL IN VALUES
			a[2:0] <= 3'b011 ; // Burst Length
        	        a[3] <= 0; // Burst Type
               		a[6:4] <= 3'b100 ; // CAS_BAR Latency
                	//
			a[7] <= 0; // TM = Normal
                	a[8] <= 1; // DLL Reset
			a[11:9] <= 3'b011; // Write recovery
			a[12] <= 0; // Fast Exit
                	ba <= 2'b00; // MRS
	                end
                `S_NOP6: {csbar, rasbar, casbar, webar} <= 0111; // NOP command

        // ----------------------------------------------------------
        // Precharge All
        // ----------------------------------------------------------
        // Issue precharge all command.

        	`S_PRE2: begin
                	{csbar, rasbar, casbar, webar} <= 4'b0010; // Precharge all banks command
                	a[10] <= 1; // Precharge value
	                end
                `S_NOP7: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // Two Autorefresh AKA Refresh
        // ----------------------------------------------------------
        // Issue 2 or more auto-refresh commands.
        // the self refresh command is defined by having
        // csbar, rasbar, casbar and cke held low
        // with webar high at the rising edge of the clock.
        // Note: ODT must be turned off before issuing Self Refresh command,
        //       by either driving ODT pin low or using EMRS command.

        // **** First Auto Refresh Cycle *****
        // bring the clock enable (cke) down

        	`S_AUTO1: begin
                	{csbar, rasbar, casbar, webar} <= 4'b0001; // Auto Refresh Command 
	                end
                `S_NOP8: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // After exit wait for the delay equal or longer than the tXSNR or tXSRD
        // Refresh to active/Refresh command time (tRFC) = 105 ns
        // Exit self refresh to a non-read command (tXSNR) = tRFC + 10 = 115 ns
        // Exit self refresh to a read command (tXSRD) =  200 cycles = 800 ns

	        `S_AUTO2: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0001; // Auto Refresh Command
	                end
                `S_NOP9: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

	// Need to wait same time as last refresh before issuing the next command

        // ----------------------------------------------------------
        // MRS programing
        // ----------------------------------------------------------
        // Issue a mode register set command with low to A8 to initialize device operation.
        // (i.e. to program operating parameters without resetting the DLL.

	        `S_MRS:  begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0000; // EMRS command 
			// FILL IN VALUES
        	        a[2:0] <= 3'b011; // Burst Length
        	        a[3] <= 0; // Burst Type
        	        a[6:4] <= 3'b100; // CAS_BAR Latency
        	        //
			a[7] <= 0; // TM = Normal
        	        a[8] <= 0; // DLL Reset
        	        a[11:9] <= 3'b011; // Write recovery
        	        a[12] <= 0; // Fast Exit
        	        ba <= 2'b00; // MRS
	                end
                `S_NOP10: {csbar, rasbar, casbar, webar} <= 4'b0111 ; // NOP command

        // ----------------------------------------------------------
        // Programing EMRS(1)
        // ----------------------------------------------------------

        	`S_EMRS1: begin
                	{csbar, rasbar, casbar, webar} <=  4'b0000; // EMRS command 
                	a[0] <= 0; // DLL Enable
			a[1] <= 0; // Output Driver Impedence
        	        a[2] <= 1; // Rtt ODT
        	        a[6] <= 0; // Rtt ODT
        	        a[5:3] <= 3'b010 ; // Additive CAS Latency
			a[9:7] <= 3'b111; // OCD Calibration
	                a[10] <= 1; // DLL Reset
        	        a[11] <= 0; // Write recovery
                	a[12] <= 0; // Fast Exit
                	ba <= 2'b01; // EMRS1
	                end
                `S_NOP11: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // OCD Calibration 
        // ----------------------------------------------------------
	// OCD Must be at least 800 ns away from issuing the DLL Reset command

        	`S_OCD:  begin
			a[9:7] <= 3'b000; // OCD
			{csbar, rasbar, casbar, webar} <= 4'b0000; // EMRS Command
			end
                `S_NOP12: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

	// ----------------------------------------------------------
        // Precharge All
        // ----------------------------------------------------------

	        `S_PRE3: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0010; // Precharge all banks command
        	        a[10] <= 1; // Precharge value
	                end
                `S_NOP13: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

	// ----------------------------------------------------------
        // Enable On Die Termination
        // ----------------------------------------------------------

        	`S_ODT:  begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command
        	        odt <= 1;
        	        end 
        // ----------------------------------------------------------
        // DDR2 Setup Done!
        // ----------------------------------------------------------
        	`S_DONE: begin
	                {csbar, rasbar, casbar, webar} <= 4'b0111; // Finally done - Just send NOPs
			ready <= 1; // done
        	        end
		default: begin
			flag <= 1;
                end
	endcase
	end
end

endmodule
