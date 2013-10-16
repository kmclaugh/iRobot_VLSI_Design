`timescale 1ns/10ps

module decision_mux(move_type_mux,rst,spiral_speed,turn_around_speed,motion_speed,rand_motion_command,spiral_motion_command,out_motion_command);

	input [1:0] move_type_mux;
	input [2:0] spiral_speed;
	input [2:0] turn_around_speed;
	input [9:0] spiral_motion_command;
	input [9:0] rand_motion_command;
	input rst; 
	
	output [9:0] out_motion_command;
	reg [9:0] out_motion_command;
	
	output [2:0] motion_speed;
	reg [2:0] motion_speed;

	parameter MUX_PAUSE = 2'b00;
	parameter MUX_SPIRAL = 2'b01;
	parameter MUX_RAND = 2'b10;

	always@(rst or move_type_mux or spiral_motion_command or rand_motion_command or spiral_speed or turn_around_speed) begin
		case (move_type_mux)
			MUX_PAUSE: begin
				out_motion_command <= 10'b00_0000_0000;
				motion_speed <= 3'b000;
			end
			MUX_SPIRAL : begin
				out_motion_command <= spiral_motion_command;
				motion_speed <= spiral_speed;
			end
			MUX_RAND : begin
				out_motion_command <= rand_motion_command;
				motion_speed <= turn_around_speed;
			end
		endcase
	end
endmodule
