`timescale 1ns/10ps

module Random_Num_Gen(random_number,clk,rst,seed,load);
	output [9:0] random_number;
	input clk;
	input [9:0] seed;
	input load;
	input rst;

	wire [9:0] random_number;
	wire [9:0] state_out;
	wire [9:0] state_in;
	wire nextbit;


	flipflop FF[9:0] (state_out,clk,rst,state_in);

	mux MUX1[9:0] (state_in, load, seed, {state_out[8],state_out[7],state_out[6],state_out[5],state_out[4],state_out[3],state_out[2],state_out[1],state_out[0],nextbit});


	xor G1 (nextbit,state_out[6],state_out[9]);
	assign random_number = state_out;

endmodule



module flipflop (q,clk,rst,d);
	input clk;
	input rst;
	input d;
	output q;

	reg q;

	always @(posedge clk or posedge rst)
	begin
		if (rst) #2 q = 0;
		else q = #3 d;
		end //if

	specify
		$setup(d,clk,2);
		$hold (clk,d,0);
	endspecify
endmodule



module mux(q,control,a,b);
	output q;
	reg q;
	input control, a ,b;

	wire notcontrol;

	always @(control or notcontrol or a or b)
		q = (control & a) | (notcontrol & b);

	not (notcontrol, control);

endmodule
