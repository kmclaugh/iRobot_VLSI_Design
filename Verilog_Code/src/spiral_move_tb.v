`timescale 1ns/10ps

module spiral_move_tb;


	reg clk,rst;
	reg enable;
	reg done_spin;
	

	wire [2:0]output_speed;
	wire [9:0] motion_command;
	
	spiral_move SP(
	.clk(clk),
	.rst(rst),
	.enable(enable),
	.done_spin(done_spin),
	.output_speed(output_speed),
	.motion_command(motion_command)
	);

	initial begin
		$stop;
		clk = 1'b0;
		rst = 1'b0;
		enable = 1'b0;
		done_spin = 1'b0;
		#500 $stop;
	end

	initial begin
		$dumpfile("Spiral Move.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end

	initial begin
		#50 rst = 1'b1;
		#50 rst = 1'b0;
		#500 enable = 1'b0;
		#2000 enable = 1'b1;
		#2000 done_spin = 1'b1;
		#2000 done_spin = 1'b0;
		#2000 $stop;


	end
	

endmodule
