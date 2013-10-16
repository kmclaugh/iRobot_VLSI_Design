`timescale 1ns/10ps

module Real_Speed_to_step_clk_Frequency_Test;
	reg [31:0] real_speed; //in rotations per second of the motor	
	reg rst;
	reg clk;
	wire step_clk;
	wire [31:0] total_count;

	 Real_Speed_to_step_clk_Frequency I1(
	.step_clk(step_clk),
	.rst(rst),
	.clk(clk),
	.real_speed(real_speed)
	);

	initial begin
		$stop;
		clk = 1'b0;
		rst = 1'b0;
		real_speed = 32'd0;		
		#1000 $stop;
	end

	initial begin
		$dumpfile("Real_Speed_to_step_clk.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end	

	initial begin
		#30 rst = 1'b1;
		#50 rst = 1'b0;
		#1000 real_speed = 32'd1000;
		#100000 real_speed = 32'd2000;
		#200000 $stop;
	end
	
endmodule
