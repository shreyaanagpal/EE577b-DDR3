// Define Counter Values by setting the counter value for each stage in the INIT process
// There is a NOP command issued 1 DDR clock cycle after most commands
// More information about each stage is in the Verilog code below

`define S_NOP1	19'd312000 // Send NOP with CKE low
`define S_CKE	19'd312500 // Set CKE High
`define S_NOP1a	19'd312502
`define S_PRE1	19'd312618 // txpr and MR2
`define S_NOP2	19'd312620 // NOP after MR2
`define S_EMRS2	19'd312632 // tMRD Set MR3
`define S_NOP3 	19'd312634// NOP after MR3
`define S_EMRS3	19'd312646 // Set MR1
`define S_NOP4	19'd312648 // NOP after MR1
`define S_DLL	19'd312660 // Set MR0
`define S_NOP5	19'd312662 // NOP after MR0
`define S_DLLR	19'd312802 // tMOD for ZQ Cali
`define S_NOP6	19'd312804 // NOP after Calibration
`define S_DONE	19'd313828 // Memory is ready

/////////////////////////////////////////////////////////


module ddr3_init_engine(
   // Outputs
   ready, csbar, rasbar, casbar, webar, ba, a, odt, ts_con, cke,
   // Inputs
   clk, resetbar, init, ck, 
   );


input clk, resetbar, init, ck;
output ready, csbar, rasbar, casbar, webar, odt, ts_con, cke;
output [2:0] ba;
output [13:0] a;

reg ready;
reg cke;
reg csbar;
reg rasbar;
reg casbar;
reg webar;
reg [2:0] ba;
reg [13:0] a;
reg odt;
reg [15:0] dq_out;
reg [1:0] dqs_out;
reg [1:0] dqsbar_out;   
reg ts_con;
reg INIT, RESET;
   
reg [18:0]  counter;
reg flag;

always @(posedge clk)
begin
	INIT <= init;
	RESET <= resetbar;

	if (RESET==0)
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

		// INIT Waits for 500 microseconds
        	`S_NOP1:  begin
			{csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command
			end
	        `S_CKE:  begin // Enable CKE high
			cke <= 1'b1;
			
			end
			`S_NOP1a: {csbar, rasbar, casbar, webar} <= 4'b0111;
	// ----------------------------------------------------------
        //Set MR2
        // ----------------------------------------------------------
        // Wait for minimum of txpr then issue precharge all command.
		
		`S_PRE1: begin 
			{csbar, rasbar, casbar, webar} <= 4'b0000; 
			ba <= 3'b010;
			a <=0;
			a[5:3] <= 3'b000;
			a[10:9]<= 2'b00;
			a[7:6] <= 2'b00;
			
			end
		`S_NOP2: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // Set MR3
        // ----------------------------------------------------------
        // EMRS(2) is reserved for future use and all bits except
        // BA0 and BA1 must be programmed to 0 when setting
        // the mode register during initialization.

        	`S_EMRS2: begin
                	{csbar, rasbar, casbar, webar} <=  4'b0000; // EMRS command
                	ba <= 3'b011;
					
	                end
                `S_NOP3: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // Set MR1
        // ----------------------------------------------------------
        // EMRS(3) is reserved for future use and all bits except
        // BA0 and BA1 must be programmed to 1 when setting
        // the mode register during initialization.

	        `S_EMRS3: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0000; // EMRS command 
        	        ba <= 3'b001;
					a[0] <= 0;
					a[1] <= 0;
					a[2] <= 0;
					a[6] <= 0;
					a[5:3] <=3'b010;
					a[13:7] <= 7'b0000000;
					a[4:3] <= 2'b10;
					
	                end
                `S_NOP4: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

        // ----------------------------------------------------------
        // MR0
        // ----------------------------------------------------------
        // Issue EMRS to enable DLL. (To issue "DLL Enable" command,
        //  provide "Low" to A0, "High" to BA0 and "Low" to BA1 and A12.)
        // Rest of the values are set to desired values too (else it throws errors)

	        `S_DLL: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0000; // EMRS command
        	       ba <= 3'b000; // Address of EMRS1
				   a[2:0] <= 3'b000;
				   a[6:4] <= 3'b001;
				   a[7] <= 0;
				   a[8] <= 1;
				   a[11:9] <= 3'b010;
				   a[13:12]<= 2'b00;
	                end
                `S_NOP5: {csbar, rasbar, casbar, webar} <= 4'b0111 ; // NOP command

        // ----------------------------------------------------------
        // ZQ Calibration
        // ----------------------------------------------------------
        // Issue a Mode Register Set command for DLL reset
        // (To issue DLL reset command, provide "High" to A8 and "Low" to BA0-1).

	        `S_DLLR: begin
        	        {csbar, rasbar, casbar, webar} <= 4'b0110 ; // EMRS command 
					a[10] <= 1; // Fast Exit
					$display("state:ZQCL\n");
	                end
                `S_NOP6: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

      //  // ----------------------------------------------------------
     // DDR3 Setup Done!
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
