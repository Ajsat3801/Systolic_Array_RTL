# Global Connections
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND} -ground

global_connect

# Define voltage domains
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# Standard cell power grid
define_pdn_grid -name {grid} -voltage_domains {CORE}

# Metal1 Stripes
add_pdn_stripe -grid {grid} -layer {met1} -width {0.49} -pitch {4.32}

# Metal3 Stripes
add_pdn_stripe -grid {grid} -layer {met3} -width {1.20} -pitch {20.0} -offset {0.5}

# Metal4 Stripes
add_pdn_stripe -grid {grid} -layer {met4} -width {0.96} -pitch {20.0} -offset {0.5} -extend_to_core_ring

# Metal5 Stripes (Increased spacing to 2.0 µm)
add_pdn_stripe -grid {grid} -layer {met5} -width {1.60} -pitch {30.0} -offset {0.5} -extend_to_core_ring

# Adding Power Rings (Increased spacing for met5)
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {1.6 1.6} -spacings {2.0 2.0} \
    -core_offsets {1.0 1.0 1.0 1.0} -connect_to_pads

# Layer Connections
add_pdn_connect -grid {grid} -layers {met3 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}

# Macro grids
define_pdn_grid -name {CORE_macro_grid} -voltage_domains {CORE} -macro \
    -orient {R0 R180 MX MY} -halo {0.0 0.0 0.0 0.0} -default -grid_over_boundary

add_pdn_stripe -grid {CORE_macro_grid} -layer {met4} -width {0.93} -pitch {20.0}
add_pdn_connect -grid {CORE_macro_grid} -layers {met3 met4}
add_pdn_connect -grid {CORE_macro_grid} -layers {met4 met5}
