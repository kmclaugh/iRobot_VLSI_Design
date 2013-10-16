`timescale 1ns/10ps

module Speed_Stepper_FSM_Test;
	reg direction;
	reg clk;
	reg step_clk;
	reg rst;
	wire sem0, sem1, sem2, sem3;

	Speed_Stepper_FSM I1(
	.clk(clk),
	.step_clk(step_clk),
	.direction(direction),
	.rst(rst),
	.sem0(sem0),
	.sem1(sem1),
	.sem2(sem2),
	.sem3(sem3)
	);

	initial begin
		$stop;
		direction = 1'b0;
		clk = 1'b0;
		rst = 1'b0;
		step_clk = 1'b0;
		#1000 $stop;
	end

	initial begin
		$dumpfile("Speed-Stepper_FSM.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end	

	initial begin
		#30 rst = 1'b1;
		#50 rst = 1'b0;
		#100 step_clk = 1'b0;
		#150 step_clk = 1'b1;
		#1000 direction = 1'b1;
	end
	
endmodule
