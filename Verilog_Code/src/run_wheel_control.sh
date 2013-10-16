cd ~/Desktop/EC\ 772/
source add_nangate.sh
cd ~/Desktop/EC\ 772/project/build/cadence-sim-rtl/
verilog ../../src/Real_Speed_to_step_clk_Frequency.v ../../src/Speed_Stepper_FSM.v ../../src/bin_to_real.v ../../src/Wheel_Control.v ../../src/Wheel_Control_Test.v +gui &
