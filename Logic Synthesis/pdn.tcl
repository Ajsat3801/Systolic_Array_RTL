# Global Connections
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDD} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VSS} -ground

global_connect

# Define voltage domains
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# Standard cell power grid
define_pdn_grid -name {grid} -voltage_domains {CORE}

# Add power stripes for Metal1
add_pdn_stripe -grid {grid} -layer {met1} -width {0.49} -pitch {5.44}

# Add power stripes for Metal3
add_pdn_stripe -grid {grid} -layer {met3} -width {1.60} -pitch {56.0} -offset {2}

# Add power stripes for Metal4
add_pdn_stripe -grid {grid} -layer {met4} -width {0.96} -pitch {56.0} -offset {2} -extend_to_core_ring

# Add power stripes for Metal5
add_pdn_stripe -grid {grid} -layer {met5} -width {1.60} -pitch {56.0} -offset {2} -extend_to_core_ring

# Add connections between layers
add_pdn_connect -grid {grid} -layers {met4 met5}
add_pdn_connect -grid {grid} -layers {met3 met4}

# Add power rings
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {3 3} -spacings {1.6 1.6} \
    -pad_offsets {10 10} -connect_to_pads

# Macro grids
define_pdn_grid -name {CORE_macro_grid} -voltage_domains {CORE} -macro \
    -orient {R0 R180 MX MY} -halo {0.0 0.0 0.0 0.0} -default -grid_over_boundary

add_pdn_stripe -grid {CORE_macro_grid} -layer {met4} -width {0.93} -pitch {20.0}
add_pdn_connect -grid {CORE_macro_grid} -layers {met3 met4}
add_pdn_connect -grid {CORE_macro_grid} -layers {met4 met5}
