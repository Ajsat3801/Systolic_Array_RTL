create_clock -name clk -period 10 -waveform {0 5} [get_ports clk1]
set_input_delay -clock clk 1 [get_ports {in1 in2}]
set_output_delay -clock clk 2 [get_ports out]
