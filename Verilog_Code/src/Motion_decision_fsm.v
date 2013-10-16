`timescale 1ns/10ps

module Motion_decision_fsm(clk,rst,bump,RandomTimeInput,RandomAngleInput,RandomLoad,move_type_mux,spiral_enable,random_enable,RandomAngleOut);
	//
	//Inputs
	//
	input clk;
	input rst;
	input bump;
	input [9:0] RandomTimeInput;
	input [9:0] RandomAngleInput;
	//
	//...
	//Outputsnext_move_type_mux;
	//
	output [1:0] move_type_mux; 
	reg [1:0] move_type_mux; //control for 2-bit move mux
	output spiral_enable;
	output random_enable;
	output RandomLoad;

	output [9:0] RandomAngleOut;
	reg [9:0] RandomAngleOut;

	reg spiral_enable;
	reg random_enable;
	reg RandomLoad;
	//

	parameter STATE_Initial = 3'd0;
	parameter STATE_RandomMoveBump = 3'd1;
	parameter STATE_Spiral = 3'd2;
	parameter STATE_RandomMove = 3'd3;

	parameter MUX_PAUSE = 2'b00;
	parameter MUX_SPIRAL = 2'b01;
	parameter MUX_RAND = 2'b10;
//
//
	reg[2:0] CurrentState;
	reg[2:0] NextState;
	reg [1:0] next_move_type_mux;
	reg [31:0] timer;
	reg [31:0] RandomTime;
//
//
// Outputs
//

always@(posedge clk) begin
	if (rst) begin
		CurrentState <= STATE_Initial;
		move_type_mux <= 2'b00;
	end
	else begin
		CurrentState <= NextState;
		move_type_mux <= next_move_type_mux;
		if (CurrentState == STATE_RandomMove) begin 
			timer <= timer + 1'b1; 
		end //if
		else begin //reset the timer
			timer <= 32'b0;
		end//else
	end//else
end//always
//
//
//
always@(CurrentState or bump or timer) begin
	case (CurrentState)

		STATE_Initial: begin
			NextState <= STATE_Spiral; //move from init to spiral
			next_move_type_mux <= MUX_SPIRAL;
			RandomLoad <= 1'b0;//stop generating random numbers
		end//State Initial

		STATE_Spiral: begin
			spiral_enable <= 1'b1;
			RandomLoad <= 1'b0;//stop generating random numbers
			random_enable <= 1'b0; 
			if(bump==1) begin //if bump, stop spiral
				NextState <= STATE_RandomMoveBump;
				next_move_type_mux <= MUX_RAND;
				RandomLoad <= 1'b1; //generate new random numbers
			end//if
			else begin //keep spiraling
				NextState <= STATE_Spiral;
				next_move_type_mux <= MUX_SPIRAL;
			end//else
		end//State spiral

		STATE_RandomMoveBump: begin
			RandomLoad <= 1'b0;// stop generating random numbers
			random_enable <= 1'b1; 
			spiral_enable <= 1'b0;
			if (bump == 1) begin //stay here
				//make random turn command
				RandomAngleOut[9:8] <= 2'b01; //[1'b:turn clockwise, 1'b:spin]
				RandomAngleOut[7:0] <= RandomAngleInput[7:0]; //random angle
				//make a 32'b ranom timer from 10'b RandomTimeInput
				RandomTime[9:0] <= RandomTimeInput; 
				RandomTime[19:10] <= RandomTimeInput;
				RandomTime[29:20] <= RandomTimeInput;
				RandomTime[31:30] <= RandomTimeInput[1:0];
				NextState <= STATE_RandomMoveBump;
				next_move_type_mux <= MUX_RAND;
			end//else
			else //move to RandomMove
				NextState <= STATE_RandomMove;
				next_move_type_mux <= MUX_RAND;
			end//else

		STATE_RandomMove: begin
			spiral_enable <= 1'b0;
			if (timer == RandomTime) begin//timer reaches end
				NextState <= STATE_Spiral;
				next_move_type_mux <= MUX_SPIRAL;
			end//if
			else if (bump) begin//if ir bumps into something new go back to RandomMoveBump to reset timer values
				RandomLoad <= 1'b1; //generate a new set of random numbers
				NextState <= STATE_RandomMoveBump;
				next_move_type_mux <= MUX_RAND;
				random_enable <= 1'b0;
				timer <= 32'b0;
			end//else if
			else begin//stay here
				NextState <= STATE_RandomMove;
				next_move_type_mux <= MUX_RAND;
			end//else
		end//Random move state

	endcase
end//always
//
//
endmodule
//
		
		
		
		
		
			
	
		
