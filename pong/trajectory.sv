module trajectory #(parameter cwidth) (clock, threshold, coordinate, active, direction);
    /* moves the ball according to the speed */
    /* receives:                             */   
    /*  -wait cycle threshold                */
    /*  -clock                               */
    /*  -active (enable signal)              */
    /* outputs:                              */
    /*  -outputs coordinate                  */

    /* waits until the threshold timer is    */
    /* reached, then moves the ball a pixel  */
    /* two modules for x and y coordinate    */

    input logic [63:0] threshold;
    input logic active, clock, direction;
    output logic [cwidth:0] coordinate;

    enum{WAIT, EXECUTE, IDLE} ss, n_ss;

    int timer;

    always_ff @(posedge clock) begin
        if (~active)
            ss <= IDLE;
        else
            ss <= n_ss;
    end

    always_comb begin
        case(ss)
            IDLE:
                if (~active)
                    n_ss = IDLE;
                else
                    n_ss = WAIT;
            WAIT:
                if (timer > threshold)
                    n_ss = EXECUTE;
                else
                    n_ss = WAIT;
            EXECUTE:
                n_ss = WAIT;
        endcase
    end

    logic command;

    always_comb begin
        case(ss)
            IDLE:
                command = 0;
            WAIT:
                command = 0;
            EXECUTE:
                command = 1;
        endcase
    end

    // moves the ball when command signal is sent to it //
    always_ff @(posedge clock) begin
        if (command) begin
            coordinate <= coordinate + ((direction) ? 1 : -1);
        end
        case(ss)
            WAIT:
                timer <= timer + 1;
            IDLE:
                coordinate <= 8'd0; // change this to the center on reset //
            EXECUTE:
                timer <= 0;
        endcase
    end
endmodule