# Define a 10ns clock (100MHz)
create_clock -name clk -period 10 [get_ports clk]

# Input delay (time taken by sensor signals to arrive)
set_input_delay -clock clk 2 [get_ports train_sensor]
set_input_delay -clock clk 2 [get_ports train_clear]

# Output delay (time taken for motor/LED response)
set_output_delay -clock clk 2 [get_ports barrier_motor]
set_output_delay -clock clk 2 [get_ports red_led]
set_output_delay -clock clk 2 [get_ports green_led]
