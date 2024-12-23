module physics(clock, reset, go, set, x, y);

    input logic clock, reset, go;
    output logic [8:0] x;
    output logic [7:0] y;
    output logic set;

    enum{STOP, MOVE, OFF} occurrence, result;

    // dummy variables representing certain events //
    logic wall; 
    logic paddle;
    logic out;

    int x_bound, y_bound;

    assign wall = !(y >=0 & y <= y_bound);
    assign paddle = !(x >= 20 & x <= x_bound - 20);
    assign out = !(x >=0 & x <= x_bound);
    // ------------------------------------------- //
    int velocity_x, velocity_y;

    // STATE  CONTROL //
    always_ff @(posedge clk) begin
        if (~reset)
            occurrence <= STOP;
        else
            occurrence <= result;
    end


    always_comb begin
        case(occurrence)
            STOP:
                if(go)
                    result = MOVE;
            MOVE:
                if (out)
                    result = OFF; 
            OFF:
                result = OFF;
        endcase
    end

    always_comb begin
        case(occurrence)

        endcase
    end
    // ------------- //

    always_ff @(posedge clock) begin

    end



endmodule