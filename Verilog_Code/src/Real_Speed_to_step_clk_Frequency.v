`timescale 1ns/10ps

module Real_Speed_to_step_clk_Frequency(clk,rst,real_speed,step_clk);

	parameter STEPS_PER_ROUND = 360;
	parameter CLK_FREQUENCY = 20_000_000; //Chip's native frequency
	input [31:0] real_speed; //in rotations per second of the motor
	input clk,rst;

	output step_clk;

	reg step_clk;
	wire [31:0] total_count; 
	reg [31:0] counter;

	assign total_count = CLK_FREQUENCY/(2*real_speed*STEPS_PER_ROUND);

	always @ (posedge clk) begin
		if (rst==1) begin
			counter = 31'b0;
			step_clk = 1'b0;
		end
		else
			if (counter > total_count-1) begin
				step_clk = !step_clk;
				counter = 0;
			end
			else begin
				counter = counter +1;
			end
	end//always
endmodule
