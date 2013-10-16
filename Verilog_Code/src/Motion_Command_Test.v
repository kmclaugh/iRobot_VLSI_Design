`timescale 1ns/10ps

module Motion_Command_Test;
	reg [9:0] motion_command;
	reg [2:0] input_speed;
	reg [7:0] tick_count;
	reg clk;
	reg rst;

	reg [2:0] i;
	reg [9:0] j;

	wire [2:0] bin_speed_wheel1;
	wire [2:0] bin_speed_wheel2;

	Motion_Commands MC(
	.clk(clk),
	.rst(rst),
	.motion_command(motion_command),
	.input_speed(input_speed),
	.tick_count (tick_count),
	.bin_speed_wheel1(bin_speed_wheel1),
	.bin_speed_wheel2(bin_speed_wheel2)
	);

	initial begin
		$stop;
		motion_command = 10'b0;
		clk = 1'b0;
		input_speed = 3'b00;
		rst = 1'b0;
		#20000 $stop;
	end

	initial begin
		$dumpfile("Motion_Command.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end	

	initial begin
		#30 rst = 1'b1;
		#10 rst = 1'b0;
		#500 input_speed = 3'b0;
		#500 tick_count = 8'b0000_0000;
		#500 motion_command = 10'b00_0000_0000;

		#500 input_speed = 3'b011;
		#500 tick_count = 8'b0000_0001;
		#500 motion_command = 10'b11_0101_1010;



		//for (i = 0; i < 4; i = i + 1) begin 
		//	#50 input_speed = i;
		//	for (j = 0; j < 513; j = j +1) begin
 	  	//  		#50 turn_command = j;
	   	//	end
		//end
		#50 tick_count = 8'b0000_0010;
		//#500 $stop;
		//for (i = 0; i < 4; i = i + 1) begin 
		//	#50 input_speed = i;
		//	for (j = 0; j < 513; j = j +1) begin
 	  	//		#50 turn_command = j;
	   	//	end
		//end
		//#50 tick_count = 8'b1000_0000;
		//for (i = 0; i < 4; i = i + 1) begin 
		//	#50 input_speed = i;
		//	for (j = 0; j < 513; j = j +1) begin
 	  	//  		#50 turn_command = j;
	   	//	end
		//end
	end
	
endmodule
