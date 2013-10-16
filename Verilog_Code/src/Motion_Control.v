`timescale 1ns/10ps

module motion_control(clk,rst,command_type,input_speed,tick_count,angle,direction,bin_speed_wheel1,bin_speed_wheel2, done_spin);
	parameter STEPS_PER_ROUND = 360;
	input direction;
	input command_type;
	input [2:0]input_speed;
	input [7:0] angle;
	input [7:0] tick_count;
	input clk,rst;

	output [2:0]bin_speed_wheel1;
	output [2:0]bin_speed_wheel2;
	output done_spin; 

	reg [2:0]bin_speed_wheel1;
	reg [2:0]bin_speed_wheel2; 
	reg [7:0]total_count;
	reg done_spin;
	
	reg [2:0] nbin1,nbin2;
	
	
	always @ (posedge clk)begin
		if (rst) begin
			bin_speed_wheel1 <= 3'b00;
			bin_speed_wheel2 <= 3'b00;
			done_spin=0;
		end
		else begin
			bin_speed_wheel1 <= nbin1;//left wheel
			bin_speed_wheel2 <= nbin2;//right wheel
		end
	end
	
	always @ (posedge clk) begin
		case(command_type)
			1'b0:begin
				done_spin <= 1'b0;
				if (angle[7]==1)begin //turn on a curve
					if (
direction==1)begin //turn left
						nbin1[2] <= input_speed[2];
						nbin2[2] <=input_speed[2];
						nbin1[1:0] <= 2'b01;
						nbin2[1:0] <= 2'b10;
					end
					else begin //turn right
						nbin1[2] <= input_speed[2];
						nbin2[2] <= input_speed[2];
						nbin1[1:0] <= 2'b10;
						nbin2[1:0] <= 2'b01;
					end
				end
				else begin //go straight
					nbin1[2] <= input_speed[2];
					nbin2[2] <= input_speed[2];
					nbin1[1:0] <= input_speed[1:0];
					nbin2[1:0] <= input_speed[1:0];
				end
			end
			1'b1: begin // spin
				total_count <=  STEPS_PER_ROUND*(angle/360);
				if (total_count == tick_count) begin //stop spining
					nbin1 <= 3'b0;
					nbin2 <= 3'b0;
					done_spin = 1'b1;
				end
				else begin
					if (direction) begin //spin left
						nbin1[2]<=1'b1;
						nbin2[2]<=1'b0;
						nbin1[1:0]<=input_speed[1:0];
						nbin2[1:0]<=input_speed[1:0];
					end
					else begin //spin right
						nbin1[2]<=1'b0;
						nbin2[2]<=1'b1;
						nbin1[1:0]<=input_speed[1:0];
						nbin2[1:0]<=input_speed[1:0];
					end
				end
			end
		endcase
	end//always

endmodule
