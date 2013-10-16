`timescale 1ns/10ps

module Wheel_Control(clk,bin_speed,tick_count,rst,sem0,sem1,sem2,sem3);

	input clk;
	input [2:0]bin_speed;
	input rst;

	output sem0, sem1, sem2, sem3;
	output [7:0]tick_count;
	wire sem0, sem1, sem2, sem3;
	wire [31:0] real_speed;
	wire step_clk;
	wire direction;

	bin_to_real bin_to_real1 (
	.bin_speed(bin_speed),
	.real_speed(real_speed),
	.direction(direction),
	.clk(clk)
	);

	Real_Speed_to_step_clk_Frequency CLK_DIVIDER1(
	.step_clk(step_clk),
	.rst(rst),
	.clk(clk),
	.real_speed(real_speed)
	);

	Speed_Stepper_FSM FSM1(
	.step_clk(step_clk),
	.clk(clk),
	.direction(direction),
	.tick_count(tick_count),
	.rst(rst),
	.sem0(sem0),
	.sem1(sem1),
	.sem2(sem2),
	.sem3(sem3)
	);



	
	

endmodule
