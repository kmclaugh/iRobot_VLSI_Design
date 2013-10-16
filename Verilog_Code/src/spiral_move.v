`timescale 1ns/10ps

module spiral_move(clk,rst,done_spin,enable,output_speed,motion_command);
	parameter done_time = 32'd200; //Original=20000
	parameter STOP = 2'b00;
	parameter STRAIGHT = 2'b01;
	parameter TURN = 2'b10;
	parameter COUNT_UP = 2'b11; //used for counting straight states
	parameter TURN_45 = 10'b01_0010_1101;
	parameter GO_STRAIGHT = 10'b00_0000_0000;

	input clk,rst;
	input enable;
	input done_spin;

	output [2:0]output_speed;
	output [9:0] motion_command;

	reg [2:0] output_speed;
	reg [2:0] next_speed;
	
	reg [9:0] motion_command;
	reg [9:0] next_command;
	reg [1:0] state; 
	reg [1:0] next_state;

	reg [7:0] straight_count; //how many times it's gone straight per spiral. Resets at the end of every spiral
	reg [31:0] k;  //the constant we will multiply done_times by.
	reg [31:0] straight_length; //done_time*k
	reg [31:0] straight_time; //how long it's been going straight
	


	always @ (posedge clk) begin
		if (rst) begin //gloabl reset
			state <= STOP;
			motion_command <= GO_STRAIGHT;
			output_speed <= 3'b000;
			straight_time <= 32'b0;
			k <= 32'b1;
			straight_count <= 8'b0;
		end
		else begin
			state <= next_state;
			output_speed <= next_speed;
			motion_command <= next_command;
			if (state == STRAIGHT) begin //if going straight increment straight time
				straight_time <= straight_time + 1;
			end
			else begin //if turning or stopped reset straight time to 0
				straight_time <= 32'b0;
				if (state == COUNT_UP) begin //COUNT_UP only lasts one clk tick
					if (straight_count == 6) begin //if between the 7th and 8th leg increment k, reset straight_count
						straight_count <= 8'b0;
						k <= k + 1'b1;
					end//if
					else begin //increment straight_count
						straight_count <= straight_count + 8'b1;
					end//else
				end
				else if (state == STOP) begin //reset k and straight_count on STOP
					straight_count <= 8'b0;
					k <= 32'b1;
				end //else if
			end//else
		end//else
	end //always

	always @ (state or straight_time or rst or enable or k or done_spin) begin
		straight_length <= done_time*k;  //recalculate straight_length
		case (state)

			STOP: begin
				if (enable) begin //start going straight on enable
					next_state <= STRAIGHT;
					next_speed <= 3'b011;
					next_command <= GO_STRAIGHT;
				end//if
				else begin //stay stopped without enable
					next_state <= STOP;
					next_speed <= 3'b000;
					next_command <= GO_STRAIGHT;
				end//else
			end//end STOP state
			
			STRAIGHT: begin
				if (enable) begin
					if (straight_time < straight_length) begin //keep going straight
						next_state <= STRAIGHT;
						next_speed <= 3'b011;
						next_command <= GO_STRAIGHT;
					end
					else begin // if it's done going straight count up straight_count or k
						next_state <= COUNT_UP;
						next_speed <= 3'b000;
						next_command <= GO_STRAIGHT;
					end
				end //if
				else begin //if enable is low go back to STOP state
					next_state <= STOP;
					next_speed <= 3'b000;
					next_command <= GO_STRAIGHT;
				end//else
			end// STRAIGHT state

			COUNT_UP: begin //lasts only 1 clk tick. Used for incrementing k and straight_count appropriately
				if (enable) begin
					next_state <= TURN;
					next_speed <= 3'b011;
					next_command <= TURN_45;
				end//if
				else begin //go back to stop if not enabled
					next_state <= STOP;
					next_speed <= 3'b000;
					next_command <= GO_STRAIGHT;
				end//else
			end//COUNT_UP state

			TURN: begin
				if (enable) begin
					if (done_spin) begin //if done spinning go straight
						next_state <= STRAIGHT;
						next_speed <= 3'b011;
						next_command <= GO_STRAIGHT;
					end//if
					else //keep spinning
						next_state <= TURN;
						next_speed <= 3'b011;
						next_command <= TURN_45;
					end//else
				else begin //if enable is low go back to STOP state
					next_state <= STOP;
					next_speed <= 3'b000;
					next_command <= GO_STRAIGHT;
				end//else
			end// TURN state
	
		endcase
	end//always						





			
endmodule
