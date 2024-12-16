###############################################################################
# Created by write_sdc
###############################################################################
current_design SystolicArray
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_uncertainty 0.5000 clk
create_clock -name external_clk -period 20.0000 [get_ports {external_clk}]
set_clock_uncertainty 0.5000 external_clk
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[10]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[11]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[12]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[13]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[14]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[15]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[16]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[17]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[18]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[19]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[20]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[21]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[22]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[23]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[24]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[25]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[26]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[27]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[28]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[29]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[30]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[31]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[32]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[33]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[34]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[35]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[36]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[37]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[38]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[39]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[40]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[41]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[42]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[43]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[44]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[45]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[46]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[47]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[48]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[49]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[50]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[51]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[52]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[53]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[54]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[55]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[56]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[57]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[58]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[59]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[60]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[61]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[62]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[63]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[8]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_input[9]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[10]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[11]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[12]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[13]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[14]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[15]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[16]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[17]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[18]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[19]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[20]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[21]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[22]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[23]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[24]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[25]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[26]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[27]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[28]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[29]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[30]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[31]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[4]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[5]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[6]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[7]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[8]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {accelerator_output[9]}]
set_max_delay\
    -from [list [get_ports {accelerator_input[0]}]\
           [get_ports {accelerator_input[10]}]\
           [get_ports {accelerator_input[11]}]\
           [get_ports {accelerator_input[12]}]\
           [get_ports {accelerator_input[13]}]\
           [get_ports {accelerator_input[14]}]\
           [get_ports {accelerator_input[15]}]\
           [get_ports {accelerator_input[16]}]\
           [get_ports {accelerator_input[17]}]\
           [get_ports {accelerator_input[18]}]\
           [get_ports {accelerator_input[19]}]\
           [get_ports {accelerator_input[1]}]\
           [get_ports {accelerator_input[20]}]\
           [get_ports {accelerator_input[21]}]\
           [get_ports {accelerator_input[22]}]\
           [get_ports {accelerator_input[23]}]\
           [get_ports {accelerator_input[24]}]\
           [get_ports {accelerator_input[25]}]\
           [get_ports {accelerator_input[26]}]\
           [get_ports {accelerator_input[27]}]\
           [get_ports {accelerator_input[28]}]\
           [get_ports {accelerator_input[29]}]\
           [get_ports {accelerator_input[2]}]\
           [get_ports {accelerator_input[30]}]\
           [get_ports {accelerator_input[31]}]\
           [get_ports {accelerator_input[32]}]\
           [get_ports {accelerator_input[33]}]\
           [get_ports {accelerator_input[34]}]\
           [get_ports {accelerator_input[35]}]\
           [get_ports {accelerator_input[36]}]\
           [get_ports {accelerator_input[37]}]\
           [get_ports {accelerator_input[38]}]\
           [get_ports {accelerator_input[39]}]\
           [get_ports {accelerator_input[3]}]\
           [get_ports {accelerator_input[40]}]\
           [get_ports {accelerator_input[41]}]\
           [get_ports {accelerator_input[42]}]\
           [get_ports {accelerator_input[43]}]\
           [get_ports {accelerator_input[44]}]\
           [get_ports {accelerator_input[45]}]\
           [get_ports {accelerator_input[46]}]\
           [get_ports {accelerator_input[47]}]\
           [get_ports {accelerator_input[48]}]\
           [get_ports {accelerator_input[49]}]\
           [get_ports {accelerator_input[4]}]\
           [get_ports {accelerator_input[50]}]\
           [get_ports {accelerator_input[51]}]\
           [get_ports {accelerator_input[52]}]\
           [get_ports {accelerator_input[53]}]\
           [get_ports {accelerator_input[54]}]\
           [get_ports {accelerator_input[55]}]\
           [get_ports {accelerator_input[56]}]\
           [get_ports {accelerator_input[57]}]\
           [get_ports {accelerator_input[58]}]\
           [get_ports {accelerator_input[59]}]\
           [get_ports {accelerator_input[5]}]\
           [get_ports {accelerator_input[60]}]\
           [get_ports {accelerator_input[61]}]\
           [get_ports {accelerator_input[62]}]\
           [get_ports {accelerator_input[63]}]\
           [get_ports {accelerator_input[6]}]\
           [get_ports {accelerator_input[7]}]\
           [get_ports {accelerator_input[8]}]\
           [get_ports {accelerator_input[9]}]]\
    -to [list [get_ports {accelerator_output[0]}]\
           [get_ports {accelerator_output[10]}]\
           [get_ports {accelerator_output[11]}]\
           [get_ports {accelerator_output[12]}]\
           [get_ports {accelerator_output[13]}]\
           [get_ports {accelerator_output[14]}]\
           [get_ports {accelerator_output[15]}]\
           [get_ports {accelerator_output[16]}]\
           [get_ports {accelerator_output[17]}]\
           [get_ports {accelerator_output[18]}]\
           [get_ports {accelerator_output[19]}]\
           [get_ports {accelerator_output[1]}]\
           [get_ports {accelerator_output[20]}]\
           [get_ports {accelerator_output[21]}]\
           [get_ports {accelerator_output[22]}]\
           [get_ports {accelerator_output[23]}]\
           [get_ports {accelerator_output[24]}]\
           [get_ports {accelerator_output[25]}]\
           [get_ports {accelerator_output[26]}]\
           [get_ports {accelerator_output[27]}]\
           [get_ports {accelerator_output[28]}]\
           [get_ports {accelerator_output[29]}]\
           [get_ports {accelerator_output[2]}]\
           [get_ports {accelerator_output[30]}]\
           [get_ports {accelerator_output[31]}]\
           [get_ports {accelerator_output[3]}]\
           [get_ports {accelerator_output[4]}]\
           [get_ports {accelerator_output[5]}]\
           [get_ports {accelerator_output[6]}]\
           [get_ports {accelerator_output[7]}]\
           [get_ports {accelerator_output[8]}]\
           [get_ports {accelerator_output[9]}]] 10.0000
set_max_delay\
    -from [list [get_ports {accelerator_input[0]}]\
           [get_ports {accelerator_input[10]}]\
           [get_ports {accelerator_input[11]}]\
           [get_ports {accelerator_input[12]}]\
           [get_ports {accelerator_input[13]}]\
           [get_ports {accelerator_input[14]}]\
           [get_ports {accelerator_input[15]}]\
           [get_ports {accelerator_input[16]}]\
           [get_ports {accelerator_input[17]}]\
           [get_ports {accelerator_input[18]}]\
           [get_ports {accelerator_input[19]}]\
           [get_ports {accelerator_input[1]}]\
           [get_ports {accelerator_input[20]}]\
           [get_ports {accelerator_input[21]}]\
           [get_ports {accelerator_input[22]}]\
           [get_ports {accelerator_input[23]}]\
           [get_ports {accelerator_input[24]}]\
           [get_ports {accelerator_input[25]}]\
           [get_ports {accelerator_input[26]}]\
           [get_ports {accelerator_input[27]}]\
           [get_ports {accelerator_input[28]}]\
           [get_ports {accelerator_input[29]}]\
           [get_ports {accelerator_input[2]}]\
           [get_ports {accelerator_input[30]}]\
           [get_ports {accelerator_input[31]}]\
           [get_ports {accelerator_input[32]}]\
           [get_ports {accelerator_input[33]}]\
           [get_ports {accelerator_input[34]}]\
           [get_ports {accelerator_input[35]}]\
           [get_ports {accelerator_input[36]}]\
           [get_ports {accelerator_input[37]}]\
           [get_ports {accelerator_input[38]}]\
           [get_ports {accelerator_input[39]}]\
           [get_ports {accelerator_input[3]}]\
           [get_ports {accelerator_input[40]}]\
           [get_ports {accelerator_input[41]}]\
           [get_ports {accelerator_input[42]}]\
           [get_ports {accelerator_input[43]}]\
           [get_ports {accelerator_input[44]}]\
           [get_ports {accelerator_input[45]}]\
           [get_ports {accelerator_input[46]}]\
           [get_ports {accelerator_input[47]}]\
           [get_ports {accelerator_input[48]}]\
           [get_ports {accelerator_input[49]}]\
           [get_ports {accelerator_input[4]}]\
           [get_ports {accelerator_input[50]}]\
           [get_ports {accelerator_input[51]}]\
           [get_ports {accelerator_input[52]}]\
           [get_ports {accelerator_input[53]}]\
           [get_ports {accelerator_input[54]}]\
           [get_ports {accelerator_input[55]}]\
           [get_ports {accelerator_input[56]}]\
           [get_ports {accelerator_input[57]}]\
           [get_ports {accelerator_input[58]}]\
           [get_ports {accelerator_input[59]}]\
           [get_ports {accelerator_input[5]}]\
           [get_ports {accelerator_input[60]}]\
           [get_ports {accelerator_input[61]}]\
           [get_ports {accelerator_input[62]}]\
           [get_ports {accelerator_input[63]}]\
           [get_ports {accelerator_input[6]}]\
           [get_ports {accelerator_input[7]}]\
           [get_ports {accelerator_input[8]}]\
           [get_ports {accelerator_input[9]}]\
           [get_ports {clk}]\
           [get_ports {external_clk}]\
           [get_ports {rst}]]\
    -to [get_ports {buffer_full}] 5.0000
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
