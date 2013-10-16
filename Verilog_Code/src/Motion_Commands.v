`timescale 1ns/10ps

module Motion_Commands(clk,rst,motion_command,input_speed,tick_count,bin_speed_wheel1,bin_speed_wheel2,done_spin);

	input [9:0] motion_command;
	input clk,rst;
	input [2:0]input_speed;
	input [7:0]tick_count;

	output [2:0]bin_speed_wheel1;
	output [2:0]bin_speed_wheel2;
	output done_spin; 


	wire [2:0]bin_speed_wheel1;
	wire [2:0]bin_speed_wheel2; 

	wire direction;
	wire command_type;
	wire [7:0] angle;
	wire done_spin;

	motion_command_demuxer motion_control_demux1(
	.motion_command(motion_command),
	.angle(angle),
	.direction(direction),
	.command_type(command_type)
	);

	motion_control motion_control1(
	.clk(clk),
	.rst(rst),
	.command_type(command_type),
	.input_speed(input_speed),
	.tick_count(tick_count),
	.angle(angle),
	.direction(direction),
	.bin_speed_wheel1(bin_speed_wheel1),
	.bin_speed_wheel2(bin_speed_wheel2),
	.done_spin(done_spin)
	);
	

endmodule
