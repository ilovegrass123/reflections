module physics(clock, reset, go, set, x, y);

    input logic clock, reset, go;
    output logic [8:0] x;
    output logic [7:0] y;
    output logic set;

    enum{STOP, MOVE, OFF} occurrence, result; // chat CALC is short for calculator
    enum{CALC, DISPLACE} ss_x, ss_y;

    int CLOCK_SPEED;

    // dummy variables representing certain events //
    logic wall; 
    logic paddle;
    logic out;

    int x_bound, y_bound;

    assign wall = !(y >=0 & y <= y_bound);
    assign paddle = !(x >= 20 & x <= x_bound - 20);
    assign out = !(x >=0 & x <= x_bound);
    // ------------------------------------------- //

    logic signed [31:0] velocity_x, velocity_y; // seconds per pixel //
    logic action; // activates the movement modules //

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

    int threshold_x, threshold_y;
    always_comb begin
        case(occurrence)
            STOP: begin
                set = 1;
                velocity_x = 1/3;
                velocity_y = 0;
                action = 0;
            end
            MOVE: begin
                set = 0;
                action = 1;
                threshold_x = CLOCK_SPEED*velocity_x;
                threshold_y = CLOCK_SPEED*velocity_y;
            end
        endcase
    end

    // ------------- //

    trajectory tx #(8) (.threshold(threshold_x), .active(action), .coordinate(x), .clock(clock));
    trajectory ty #(7) (.threshold(threshold_y), .active(action), .coordinate(y), .clock(clock));



endmodule