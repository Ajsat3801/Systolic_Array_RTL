# Design Constraints File (SDC) for accelerator

# Define clock constraints
create_clock -name clk -period 10.0 [get_ports clk]
create_clock -name external_clk -period 20.0 [get_ports external_clk]

# Define input delays
set_input_delay -clock clk 2.0 [get_ports accelerator_input]

# Define output delays
set_output_delay -clock clk 2.0 [get_ports accelerator_output]

# Define clock uncertainty
set_clock_uncertainty 0.5 [get_clocks clk]
set_clock_uncertainty 0.5 [get_clocks external_clk]

# Specify reset signal as asynchronous
set_false_path -from [get_ports rst] -to [all_registers]

# Constrain buffer_full as a critical path output
set_max_delay 5.0 -from [all_inputs] -to [get_ports buffer_full]

# Specify input and output port relationships
set_max_delay 10.0 -from [get_ports accelerator_input] -to [get_ports accelerator_output]

# End of SDC file
