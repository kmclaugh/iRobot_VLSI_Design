`timescale 1ns/10ps

module Wheel_Control_Test;
	reg [2:0] bin_speed;
	reg clk;
	reg rst;
	wire sem0, sem1, sem2, sem3;
	wire [7:0] tick_count;

	Wheel_Control I1(
	.clk(clk),
	.bin_speed(bin_speed),
	.rst(rst),
	.tick_count(tick_count),
	.sem0(sem0),
	.sem1(sem1),
	.sem2(sem2),
	.sem3(sem3)
	);

	initial begin
		$stop;
		clk = 1'b0;
		rst = 1'b0;
		bin_speed = 3'b000;
		#1000 $stop;
	end

	initial begin
		$dumpfile("Wheel_Control.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end	


	initial begin
		#30 rst = 1'b1;
		#50 rst = 1'b0;
		#100 bin_speed = 3'b011;
		#20000
		#100 bin_speed = 3'b111;
		#20000
		$stop;

	end
	
endmodule
