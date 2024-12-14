# Global Connections
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND} -ground

global_connect

# Voltage Domains
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# Define the standard cell power grid
define_pdn_grid -name {grid} -voltage_domains {CORE}

# Metal1 Stripes
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.00} -offset {0.5}

# Metal3 Stripes
add_pdn_stripe -grid {grid} -layer {met3} -width {1.20} -pitch {10.0} -offset {0.5}

# Metal4 Stripes
add_pdn_stripe -grid {grid} -layer {met4} -width {1.60} -pitch {15.0} -offset {0.5} -extend_to_core_ring

# Metal5 Stripes
add_pdn_stripe -grid {grid} -layer {met5} -width {1.60} -pitch {20.0} -offset {0.5} -extend_to_core_ring

# Add power rings around the core
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {1.60 1.60} -spacings {2.00 2.00} \
    -core_offsets {1.00 1.00 1.00 1.00} -connect_to_pads

# Add connections between layers
add_pdn_connect -grid {grid} -layers {met3 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}
