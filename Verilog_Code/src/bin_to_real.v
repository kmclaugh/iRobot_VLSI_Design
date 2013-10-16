`timescale 1ns/10ps

module bin_to_real(bin_speed, real_speed, direction, clk);

	parameter width = 32;
	parameter MAX_SPEED = 1000; //rotation per second
	parameter SPEED_ONE = MAX_SPEED/3;
	parameter SPEED_TWO = MAX_SPEED/2;
	parameter SPEED_THREE = MAX_SPEED;
	input [2:0] bin_speed;  //3 bits:  [direction speed1 speed0]
	input clk;


	output [width-1:0] real_speed;
	output direction;  // direction=bin_speed[2]
	

	reg [width-1:0] real_speed;
	reg direction;


	always @ (posedge clk) begin 
		direction = bin_speed[2];
		case(bin_speed[1:0])
			2'b00: real_speed = 0;
			2'b01: real_speed = SPEED_ONE;
			2'b10: real_speed = SPEED_TWO;
			2'b11: real_speed = SPEED_THREE;
		endcase
	end//always
	

endmodule
