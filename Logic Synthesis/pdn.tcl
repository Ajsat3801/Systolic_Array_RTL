# Global Connections
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND} -ground

# Connect filler cells explicitly
add_global_connection -net {VDD} -inst_pattern {FILLER*} -pin_pattern {VPWR} -power
add_global_connection -net {VSS} -inst_pattern {FILLER*} -pin_pattern {VGND} -ground

global_connect

# Define voltage domains
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# Define the standard cell power grid
define_pdn_grid -name {grid} -voltage_domains {CORE}

# Metal1 Stripes
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.00}

# Metal3 Stripes
add_pdn_stripe -grid {grid} -layer {met3} -width {1.20} -pitch {10.0} -offset {0.5}

# Metal4 Stripes
add_pdn_stripe -grid {grid} -layer {met4} -width {1.60} -pitch {15.0} -offset {0.5} -extend_to_core_ring

# Metal5 Stripes
add_pdn_stripe -grid {grid} -layer {met5} -width {1.60} -pitch {20.0} -offset {0.5} -extend_to_core_ring

# Add connections between layers
add_pdn_connect -grid {grid} -layers {met1 met3}
add_pdn_connect -grid {grid} -layers {met3 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}

# Add power rings around the core
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {1.60 1.60} -spacings {2.00 2.00} \
    -core_offsets {1.00 1.00 1.00 1.00} -connect_to_pads

# Define macro grids (if macros are used)
define_pdn_grid -name {CORE_macro_grid} -voltage_domains {CORE} -macro \
    -orient {R0 R180 MX MY} -halo {0.0 0.0 0.0 0.0} -default -grid_over_boundary

add_pdn_stripe -grid {CORE_macro_grid} -layer {met4} -width {1.20} -pitch {20.0}
add_pdn_connect -grid {CORE_macro_grid} -layers {met3 met4}
add_pdn_connect -grid {CORE_macro_grid} -layers {met4 met5}

# Validate connectivity and write the final power grid
pdngen validate_connectivity -net VDD -grid {grid}
pdngen validate_connectivity -net VSS -grid {grid}
write_def ./design_with_pdn.def
