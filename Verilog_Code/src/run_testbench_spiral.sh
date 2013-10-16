cd ~/Desktop/EC\ 772/
source add_nangate.sh
cd ~/Desktop/EC\ 772/project/build/cadence-sim-rtl/
verilog  ../../src/turn_around_move.v ../../src/turn_around_move_tb.v +gui &
