cd ~/Desktop/EC\ 772/
source add_nangate.sh
cd ~/Desktop/EC\ 772/project/build/cadence-sim-rtl/
verilog  ../../src/Motion_decision_fsm.v ../../src/Motion_decision_fsm_tb.v +gui &
