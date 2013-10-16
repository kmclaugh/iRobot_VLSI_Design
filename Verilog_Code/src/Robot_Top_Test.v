`timescale 1ns/10ps

module Robot_Top_Test;

	reg clk,rst;
	reg bump;

	wire [3:0] wheel_wires_left; 
	wire [3:0] wheel_wires_right; 

	Robot_Top Robot_Top_tb(
	.clk(clk),
	.rst(rst),
	.bump(bump),
	.wheel_wires_left(wheel_wires_left),
	.wheel_wires_right(wheel_wires_right)
	);

	initial begin
	//	$stop;
		clk = 1'b0;
		rst = 1'b0;
		bump = 1'b0;
//		#20000 $stop;
#30 rst = 1'b1;
#50 rst = 1'b0;

#100 bump = 1'b1;
#50 bump = 1'b0;

	end

//	initial begin
//		$dumpfile("Robot_Top.vcd");
//		$dumpvars;
///	end	

	always begin
		#25 clk = !clk;
	end	

	
endmodule
