`timescale 1ns/10ps

module Motion_decision_fsm_tb;

	reg clk,rst;
	reg bump;
	reg [9:0] RandomTime;
	reg [9:0] RandomAngle;

	wire [9:0] RandomAngleOut;
	wire spiral_enable;
	wire random_enable;
	wire RandomLoad;
	wire [1:0] move_type_mux;

	Motion_decision_fsm MDFSM_tb(
	.clk(clk),
	.rst(rst),
	.bump(bump),
	.RandomTimeInput(RandomTime),
	.RandomAngleInput(RandomAngle),
	.move_type_mux(move_type_mux),
	.spiral_enable(spiral_enable),
	.random_enable(random_enable),
	.RandomLoad(RandomLoad),
	.RandomAngleOut(RandomAngleOut)
	);

	initial begin
		$stop;
		clk = 1'b0;
		rst = 1'b0;
		bump = 1'b0;
		RandomTime = 10'b0;
		RandomAngle = 10'b0;
		#20000 bump = 1'b1;
		#100 bump =1'b0;
		#20000 $stop;
	end

	initial begin
		$dumpfile("Robot_Top.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end	

	initial begin
		#30 rst = 1'b1;
		#50 rst = 1'b0;
		#50 RandomTime = 10'b00_0000_1000;
		#5 RandomAngle = 10'b00_1111_0000;
		#2000000 $stop;


	end
	
endmodule
