`timescale 1ns / 1ps

module railway_crossing_fsm (
    input clk,              // System clock
    input reset,            // Reset signal
    input train_sensor,     // High when train is approaching
    input train_clear,      // High when train has passed
    output reg barrier_motor,  // 1 = Closing, 0 = Opening
    output reg red_led,     // RED LED (1 = Barrier Closed)
    output reg green_led    // GREEN LED (1 = Barrier Open)
);

    // FSM State Encoding
    parameter IDLE = 3'b000,
              TRAIN_APPROACH = 3'b001,
              BARRIER_CLOSING = 3'b010,
              TRAIN_PASSING = 3'b011,
              BARRIER_OPENING = 3'b100;

    reg [2:0] state, next_state;  // 3-bit state register

    // State Transition Logic (Sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next State Logic (Combinational)
    always @(*) begin
        case (state)
            IDLE: 
                if (train_sensor)
                    next_state = TRAIN_APPROACH;
                else
                    next_state = IDLE;

            TRAIN_APPROACH: 
                next_state = BARRIER_CLOSING;

            BARRIER_CLOSING: 
                next_state = TRAIN_PASSING;

            TRAIN_PASSING: 
                if (train_clear)
                    next_state = BARRIER_OPENING;
                else
                    next_state = TRAIN_PASSING;

            BARRIER_OPENING: 
                next_state = IDLE;

            default: 
                next_state = IDLE;
        endcase
    end

    // Output Logic for Motor & LED Control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            barrier_motor <= 0;  // Barrier open initially
            red_led <= 0;        // Red LED OFF
            green_led <= 1;      // Green LED ON
        end else begin
            case (state)
                IDLE: begin
                    barrier_motor <= 0;  // Keep barrier open
                    red_led <= 0;
                    green_led <= 1;
                end
                
                BARRIER_CLOSING: begin
                    barrier_motor <= 1;  // Activate motor to close barrier
                    red_led <= 1;        // Red LED ON
                    green_led <= 0;
                end
                
                TRAIN_PASSING: begin
                    barrier_motor <= 0;  // Barrier remains closed
                    red_led <= 1;
                    green_led <= 0;
                end

                BARRIER_OPENING: begin
                    barrier_motor <= 1;  // Activate motor to open barrier
                    red_led <= 0;
                    green_led <= 1;
                end

                default: begin
                    barrier_motor <= 0;
                    red_led <= 0;
                    green_led <= 1;
                end
            endcase
        end
    end

endmodule
