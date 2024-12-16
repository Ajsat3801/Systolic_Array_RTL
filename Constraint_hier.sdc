# Design Constraints File (SDC) for SystolicArray

# 1. Define clocks
create_clock -name clk -period 20.0 [get_ports clk]
create_clock -name external_clk -period 10.0 [get_ports external_clk]

# 2. Define input delays
set_input_delay -clock clk 2.0 [get_ports accelerator_input]
set_input_delay -clock external_clk 3.0 [get_ports external_clk]

# 3. Define output delays
set_output_delay -clock clk 2.0 [get_ports accelerator_output]
set_output_delay -clock clk 1.0 [get_ports buffer_full]

# 4. Define clock uncertainty
set_clock_uncertainty 0.005 [get_clocks clk]
set_clock_uncertainty 0.005 [get_clocks external_clk]

# 5. Specify reset signal as asynchronous
set_false_path -from [get_ports rst] -to [all_registers]

# 6. Add constraints for specific endpoints
set_max_delay 10.0 -from [get_ports accelerator_input] -to [get_ports accelerator_output]
set_max_delay 5.0 -from [all_inputs] -to [get_ports buffer_full]

# 7. Constrain hierarchical modules
set_hierarchy_separator /
set_input_delay -clock clk 2.0 [get_ports clk]
set_input_delay -clock clk 2.0 [get_ports rst]

# 8. Apply specific constraints to registers and wires
set_false_path -to [all_registers] -from [get_ports rst]
set_multicycle_path -setup 2 -from [get_ports clk] -to [all_registers]
set_multicycle_path -hold 1 -from [get_ports clk] -to [all_registers]

# 9. Set load and fanout
set_load 0.5 [get_ports accelerator_output]
set_max_fanout 10 [all_registers]

# End of SDC file