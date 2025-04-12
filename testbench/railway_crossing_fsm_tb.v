`timescale 1ns / 1ps

module railway_crossing_tb;
    reg clk, reset, train_sensor, train_clear;
    wire barrier_motor, red_led, green_led;

    // Instantiate the FSM module
    railway_crossing_fsm uut (
        .clk(clk),
        .reset(reset),
        .train_sensor(train_sensor),
        .train_clear(train_clear),
        .barrier_motor(barrier_motor),
        .red_led(red_led),
        .green_led(green_led)
    );

    // Generate clock (10ns period → 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        train_sensor = 0;
        train_clear = 0;

        // Apply reset
        #10 reset = 0;

        // Case 1: Train Approaching
        #20 train_sensor = 1; // Train detected
        #20 train_sensor = 0; // Train still moving
        #40 train_clear = 1;  // Train passed
        #10 train_clear = 0;

        // Case 2: Another train approaching after some time
        #50 train_sensor = 1;
        #20 train_sensor = 0;
        #40 train_clear = 1;
        #10 train_clear = 0;

        // Finish simulation
        #100 $finish;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time=%0t | State=%b | Barrier=%b | Red_LED=%b | Green_LED=%b",
                  $time, uut.state, barrier_motor, red_led, green_led);
    end
endmodule
