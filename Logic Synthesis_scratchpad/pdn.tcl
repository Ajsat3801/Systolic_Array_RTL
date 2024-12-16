####################################
# global connections
####################################
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {.*} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {.*} -ground

global_connect

####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

####################################
# standard cell grid
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE}

# Add power stripes and rings for power delivery
add_pdn_stripe -grid {grid} -layer {met1} -width {0.49} -pitch {4.40} -offset {0} -followpins
add_pdn_stripe -grid {grid} -layer {met2} -width {0.49} -pitch {5.44} -offset {2}
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {3 3} -spacings {1.6 1.6} -pad_offsets {10 10} -connect_to_pads -starts_with POWER
add_pdn_stripe -grid {grid} -layer {met4} -width {0.96} -pitch {56.0} -offset {2} -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {met5} -width {1.60} -pitch {56.0} -offset {2} -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {met1 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}

####################################
# macro grids
####################################
# Define macro grid for pad cells

define_pdn_grid -name {pads} -voltage_domains {CORE} -macro \
    -halo {0.0 0.0 0.0 0.0} \
    -cells {instruction_buffer controller MAC Output_buffer Accumulator BankedBuffer} \
    -grid_over_boundary

####################################
# grid for: CORE_macro_grid_1
####################################
define_pdn_grid -name {CORE_macro_grid_1} -voltage_domains {CORE} -macro -orient {R0 R180 MX MY} -halo {0.0 0.0 0.0 0.0} -default -grid_over_boundary
add_pdn_stripe -grid {CORE_macro_grid_1} -layer {met4} -width {0.93} -pitch {20.0} -offset {2}
add_pdn_connect -grid {CORE_macro_grid_1} -layers {met3 met4}
add_pdn_connect -grid {CORE_macro_grid_1} -layers {met4 met5}

