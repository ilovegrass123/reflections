module trajectory #(parameter cwidth) (clock, threshold, coordinate, active);
    /* moves the ball according to the speed */
    /* receives:                             */   
    /*  -wait cycle threshold                */
    /*  -clock                               */
    /*  -active (enable signal)              */
    /* outputs:                              */
    /*  -outputs coordinate                  */

    input int threshold;
    input logic active, clock;
    output logic [cwidth:0] coordinate;

    enum{CALCULATE, EXECUTE, IDLE} ss, n_ss;

    int timer;

    always_ff @(posedge clock) begin
        if (~active)
            ss = IDLE;
        else
            ss = n_ss;
    end

    always_comb begin
        case(ss)
            IDLE:
                if (~active)
                    n_ss = IDLE;
                else
                    ss = CALCULATE;
            CALCULATE:
                n_ss = EXECUTE;
            EXECUTE:
                if (timer >= threshold)
                    n_ss = CALCULATE;
                else
                    n_ss = EXECUTE;
        endcase
    end

    logic command;

    always_ff @(posedge clock) begin
        if (command)
    end

endmodule