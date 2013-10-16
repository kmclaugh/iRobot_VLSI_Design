`timescale 1ns/10ps
module turn_around_move(clk,rst,output_speed,random_angle,motion_command,enable,done_spin);
	//
	//Inputs
	//
	input clk;
	input rst;
	input enable;
	input done_spin;
	input [9:0] random_angle;
	//
	//...
	//Outputs
	//
	output [2:0] output_speed;
	output [9:0] motion_command;
	reg [2:0] output_speed;
	reg [9:0] motion_command;
	reg [31:0] timer;
	//

	parameter STATE_Initial = 3'd0;
	parameter STATE_Rotate = 3'd1;
	parameter STATE_Reverse = 3'd2;
	parameter STATE_Straight = 3'd3;
	parameter STATE_counters = 3'd4;
	parameter ZERO_t =  16'b0000000000000000;
	parameter rev_t =      16'b0000000100000000;
	parameter straight_command = 10'b0000000000;
	parameter Reverse_speed = 3'b101;
	parameter Forward_speed = 3'b011;
	parameter Zero_speed = 3'b000;

	reg[2:0] CurrentState;
	reg[2:0] NextState;
	reg[2:0] NextSpeed;
	reg [9:0] NextCommand;

	always @ (posedge clk) begin
		if (rst) begin //global reset
			CurrentState <= STATE_Initial;
			motion_command <= straight_command;
			output_speed <= Zero_speed;
			timer <= 32'b0;
		end//if
		else begin
			CurrentState <= NextState;
			motion_command <= NextCommand;
			output_speed <= NextSpeed;
			if (CurrentState == STATE_Reverse) begin
				timer <= timer + 1'b1;
			end //if
			else begin //if not reversing reset timer
				timer <= 32'b0;
			end//else
		end//else
	end//always
			
	always @ (timer or rst or done_spin or enable) begin
		case (CurrentState)
				
			STATE_Initial: begin
				if (enable) begin
					NextState <= STATE_Reverse;
					NextCommand <= 	straight_command;
					NextSpeed <= Reverse_speed;
				end//if
				else begin
					NextState <= STATE_Initial;
					NextCommand <= 	straight_command;
					NextSpeed <= 3'b000;
				end//else
			end//state_inital
			
			STATE_Reverse: begin
				if (enable) begin
					if (timer < rev_t) begin //if not done backing up keep backing up
						NextState <= STATE_Reverse;
						NextCommand <= straight_command;
						NextSpeed <= 3'b111;
					end //if
					else begin //if done backing up start turning
						NextState <= STATE_Rotate;
						NextCommand <= random_angle;
						NextSpeed <= 3'b000;
					end//else
				end//if
				else begin //if not enable go back to STATE_Intial
					NextState <= STATE_Initial;
					NextCommand <= 	straight_command;
					NextSpeed <= 3'b000;
				end//else
			end//state_reverse
			
			STATE_Rotate: begin
				if (enable) begin
					if (done_spin) begin //if done spining, go straight
						NextState <= STATE_Straight;
						NextCommand <= straight_command;
						NextSpeed <= 3'b011;
					end //if
					else begin//keep rotating
						NextState <= STATE_Rotate;
						NextCommand <= random_angle;
						NextSpeed <= 3'b011;
					end//else
				end//if
				else begin //if not enable go back to STATE_Intial
					NextState <= STATE_Initial;
					NextCommand <= 	straight_command;
					NextSpeed <= 3'b000;
				end//else
			end //state_rotate	
	
			STATE_Straight: begin
				if (enable) begin //keep going straight. motion_decision_fsm controls when to switch to spiral
					NextState <= STATE_Straight;
					NextCommand <= straight_command;
					NextSpeed <= 3'b011;
				end//if
				else begin //if not enable go back to STATE_Intial
					NextState <= STATE_Initial;
					NextCommand <= 	straight_command;
					NextSpeed <= 3'b000;
				end//else
			end //state_striaght
		endcase
	end//always	
						
						
//
//
endmodule
//
		
		
		
		
		
			
	
		
