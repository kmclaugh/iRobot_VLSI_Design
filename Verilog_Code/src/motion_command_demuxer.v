`timescale 1ns/10ps

module motion_command_demuxer(motion_command,command_type,angle, direction);

	input [9:0] motion_command;

	output direction;
	output command_type;
	output [7:0] angle;

	wire direction;
	wire command_type;
	wire [7:0] angle;
	
	assign command_type = motion_command[8];
	assign direction = motion_command[9];
	assign angle = motion_command[7:0]; //bit 7 is straight or curved if turning on a curve
endmodule
