`timescale 1ns/10ps

module bin_to_real_tb;

	parameter width = 32;

	reg [2:0] bin_speed; 
	reg clk;


	wire [width-1:0] real_speed;
	wire direction;  // direction=bin_speed[2]
	
	bin_to_real I1(
	.bin_speed(bin_speed),
	.real_speed(real_speed),
	.direction(direction),
	.clk(clk)
	);

	initial begin
		$stop;
		bin_speed = 3'b000;
		clk = 1'b0;
	end

	initial begin
		$dumpfile("fir_filter.vcd");
		$dumpvars;
	end	

	always begin
		#25 clk = !clk;
	end

	initial begin
		#50 bin_speed = 3'b001;
		#50 bin_speed = 3'b010;
		#50 bin_speed = 3'b011;
		#50 bin_speed = 3'b100;
		#50 bin_speed = 3'b101;
		#50 bin_speed = 3'b110;
		#50 bin_speed = 3'b111;
	end
	

endmodule
