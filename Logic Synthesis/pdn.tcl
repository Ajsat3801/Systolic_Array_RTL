# Global Connections
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDD} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VSS} -ground

global_connect

# Define voltage domains
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# Standard cell power grid
define_pdn_grid -name {grid} -voltage_domains {CORE} -followpins

# Metal1 Stripes
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.44} -followpins

# Metal2 Stripes
add_pdn_stripe -grid {grid} -layer {met2} -width {0.96} -pitch {10.88} -connect_to_pads -starts_with POWER

# Metal3 and Metal4 Connections
add_pdn_stripe -grid {grid} -layer {met3} -width {1.60} -pitch {20.0} -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {met3 met4}

# Add power rings around the core
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {3 3} -spacings {1.6 1.6} -connect_to_pads

# I/O and Macro Grids
define_pdn_grid -name {pads} -voltage_domains {CORE} -macro \
    -halo {0.0 0.0 0.0 0.0} \
    -cells {sky130_fd_io__gpiov2_pad_wrapped \
            sky130_fd_io__vccd_hvc_pad \
            sky130_fd_io__vssd_lvc_pad} \
    -grid_over_boundary

# Check connectivity
pdngen check_connectivity -vdd_net {VDD} -gnd_net {VSS}

# Write the updated DEF file
write_def ./design_with_pdn.def