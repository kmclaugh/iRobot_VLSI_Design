`timescale 1ns/10ps

module Robot_Top(clk,rst,bump,wheel_wires_left,wheel_wires_right);

	input clk,rst;
	
	input bump;

	output [3:0] wheel_wires_left; 
	output [3:0] wheel_wires_right;

	wire [2:0]bin_speed_wheell;
	wire [2:0]bin_speed_wheelr;

	wire [1:0] decision_control;
	wire [3:0] wheel_wires_left; 
	wire [3:0] wheel_wires_right;
	wire [9:0] motion_command;
	wire [9:0] random_angle;
	wire [9:0] spiral_motion_command;
	wire [9:0] turn_around_move_command;
	wire [9:0] command_random_num;
	wire [9:0] timer_random_num; 
	wire [2:0] turn_around_speed;
	wire [2:0] spiral_speed;
	wire [2:0] motion_speed;
	wire load;
	wire done_spin;
	wire spiral_enable;
	wire random_enable;
	wire [9:0]seed1;
	wire [9:0]seed2;

	wire [7:0]tick_countl, tick_countr;

	assign seed1 = 10'b01_0101_0101;
	assign seed2 = 10'b11_0111_1101;

	Random_Num_Gen Random_Num_Gen_timer(
	.random_number(timer_random_num),
	.clk(clk),
	.rst(rst),
	.seed(seed1),
	.load(load)
	);

	Random_Num_Gen Random_Num_Gen_command(
	.random_number(command_random_num),
	.clk(clk),
	.rst(rst),
	.seed(seed2),
	.load(load)
	);


	Motion_decision_fsm Motion_decision_fsm1(
	.clk(clk),
	.rst(rst),
	.bump(bump),
	.RandomTimeInput(timer_random_num),
	.RandomAngleInput(command_random_num),
	.RandomLoad(load),
	.move_type_mux(decision_control),
	.spiral_enable(spiral_enable),
	.random_enable(random_enable),
	.RandomAngleOut(random_angle)
	);


	spiral_move spiral_move1(
	.clk(clk),
	.rst(rst),
	.done_spin(done_spin),
	.enable(spiral_enable),
	.output_speed(spiral_speed),
	.motion_command(spiral_motion_command)
	);

	turn_around_move turn_around_move1(
	.clk(clk),
	.rst(rst),
	.output_speed(turn_around_speed),
	.motion_command(turn_around_move_command),
	.enable(random_enable),
	.done_spin(done_spin),
	.random_angle(random_angle)
	);

	decision_mux decision_mux1(
	.move_type_mux(decision_control),
	.rst(rst),
	.spiral_speed(spiral_speed),
	.turn_around_speed(turn_around_speed),
	.motion_speed(motion_speed),
	.rand_motion_command(turn_around_move_command),
	.spiral_motion_command(spiral_motion_command),
	.out_motion_command(motion_command)
	);

	Motion_Commands Motion_Commands_Top(
	.clk(clk),
	.rst(rst),
	.motion_command(motion_command),
	.input_speed(motion_speed),
	.tick_count (tick_countl),
	.bin_speed_wheel1(bin_speed_wheell),
	.bin_speed_wheel2(bin_speed_wheelr),
	.done_spin(done_spin)
	);

	Wheel_Control Wheel_Control_Left(
	.clk(clk),
	.bin_speed(bin_speed_wheell),
	.tick_count(tick_countl),
	.rst(rst),
	.sem0(wheel_wires_left[0]),
	.sem1(wheel_wires_left[1]),
	.sem2(wheel_wires_left[2]),
	.sem3(wheel_wires_left[3])
	);

	Wheel_Control Wheel_Control_Right(
	.clk(clk),
	.bin_speed(bin_speed_wheelr),
	.rst(rst),
	.tick_count(tick_countr),
	.sem0(wheel_wires_right[0]),
	.sem1(wheel_wires_right[1]),
	.sem2(wheel_wires_right[2]),
	.sem3(wheel_wires_right[3])
	);

endmodule
