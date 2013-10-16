`timescale 1ns/10ps

module Speed_Stepper_FSM(step_clk,clk,direction,rst,sem0,sem1,sem2,sem3,tick_count);

	input step_clk;
	input clk;
	input direction;
	input rst;

	output sem0, sem1, sem2, sem3;
	output [7:0] tick_count;
	wire sem0, sem1, sem2, sem3;
	reg [1:0] state, next_state;
	reg [3:0] outs, next_outs;
	reg [7:0] tick_count;
	reg previous_clk;

	assign sem0 = outs[0];
	assign sem1 = outs[1];
	assign sem2 = outs[2];
	assign sem3 = outs[3];

	always @ (posedge clk) begin
		if (rst==1) begin
			state <= 2'b00;
			previous_clk <= 1'b0;
			tick_count <= 8'b0;
			outs <= 4'b0;
			end
		else begin
			if (step_clk != previous_clk) begin
				tick_count <= tick_count+1'b1;
				state <= next_state;
				outs <= next_outs;
				previous_clk <= step_clk;
			end
		end	
	end
			

	always @ (state or step_clk or direction) begin
		case (state)
			2'b00:begin
				next_state = direction ? 2'b11 : 2'b01;
				next_outs = direction ? 4'b1100 : 4'b0011;
			end	
			2'b01:begin
				next_state = direction ? 2'b00 : 2'b10;
				next_outs = direction ? 4'b1001 : 4'b0110;
			end
			2'b10:begin
				next_state = direction ? 2'b01 : 2'b11;
				next_outs = direction ? 4'b0011 : 4'b1100;
			end
			2'b11:begin
				next_state = direction ? 2'b10 : 2'b00;
				next_outs = direction ? 4'b0110 : 4'b1001;
			end
			//default:begin 
			//	 next_state = 2'b00;
			//	next_outs = 4'b1001;
			//end
		endcase
	end

endmodule
