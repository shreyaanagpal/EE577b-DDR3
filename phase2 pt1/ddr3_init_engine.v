// Define Counter Values by setting the counter value for each stage in the INIT process
// There is a NOP command issued 1 DDR clock cycle after most commands
// More information about each stage is in the Verilog code below

`define S_RESET	19'd125000 // Send NOP with CKE low
`define S_NOP1	19'd437500// Send NOP with CKE low
`define S_CKE	19'd438002 // Set CKE High
`define S_NOP1a	19'd438004
`define S_PRE1	19'd438120 // txpr and MR2
`define S_NOP2	19'd438122 // NOP after MR2
`define S_EMRS2	19'd438134 // tMRD Set MR3
`define S_NOP3 	19'd438136// NOP after MR3
`define S_EMRS3	19'd438146 // Set MR1
`define S_NOP4	19'd438148 // NOP after MR1
`define S_DLL	19'd438162 // Set MR0
`define S_NOP5	19'd438164 // NOP after MR0
`define S_DLLR	19'd438304 // tMOD for ZQ Cali
`define S_NOP6	19'd438306 // NOP after Calibration
`define S_DONE	19'd439330 // Memory is ready
`define MR0		19'd439502
`define NOP		19'd439504
`define MR1		19'd439518
`define NOP1	19'd439520
/////////////////////////////////////////////////////////


module ddr3_init_engine(
   // Outputs
   ready, csbar, rasbar, casbar, webar, ba, a, odt, ts_con, cke,
   // Inputs
   clk, reset, init, ck, reset_out
   );


input clk, reset, init, ck;
output ready, csbar, rasbar, casbar, webar, odt, ts_con, cke, reset_out;
output [2:0] ba;
output [12:0] a;

reg ready;
reg reset_out;
reg cke;
reg csbar;
reg rasbar;
reg casbar;
reg webar;
reg [2:0] ba;
reg [12:0] a;
reg odt;
reg [15:0] dq_out;
reg [1:0] dqs_out;
reg [1:0] dqsbar_out;   
reg ts_con;
reg INIT, RESET;
   
reg [18:0]  counter;
integer counter1;
reg flag;

always @(posedge clk)
begin
	INIT <= init;
	RESET <= reset;

	if (RESET==1)
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
		reset_out <= 0;
	end
	else if (flag == 0 && INIT == 1)
	begin
		// On INIT signal, set a flag to start the initialization routine and clear the counter
		flag <= 1;
		counter <= 0;
		counter1 <= 0;
	end
	else if (flag == 1)
	begin
		

			counter <= counter + 1;
		
			
			
		case (counter)
		// Use a case statement to match counter values to specific commands issued to the DDR2 chip
		// TASK: Fill in the correct counter values in the definitions at the beginning of the file
		// and fill in any missing signal values to set up the DDR2 chip correctly in the following code
	
	
			`S_RESET:	reset_out <= 1'b1;
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
					a[12:7] <= 7'd0;
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
				   a[12]<= 0;
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
				//ready <= 1; // done
     	        end
		`MR0:
			begin
				{csbar, rasbar,casbar,webar} <= 4'b0000; 
				ba <= 3'b000;
				a[2:0] <= 3'b000;
				a[6:4] <= 3'b001;
				a[7] <= 0;
				a[1:0] <= 2'b01;
			end
		`NOP: 
				{csbar, rasbar,casbar,webar} <= 4'b0111;
		`MR1:
			begin
				{csbar, rasbar,casbar,webar} <= 4'b0000;
				ba <= 3'b001;
				a[4:3] <= 2'b01;
			end
		`NOP1: 
			begin
				{csbar, rasbar,casbar,webar} <= 4'b0111;	
				ready <= 1;
			end
	default: begin
		flag <= 1;
             end
	endcase
	end
end

endmodule
