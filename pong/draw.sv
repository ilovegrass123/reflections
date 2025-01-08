module draw #(parameter radius) (input logic [7:0] x, input logic [6:0] y, input logic clock, input logic reset,
output logic vga_plot, output logic vga_x[7:0], output logic [6:0] vga_y);

    /* make sure ball speed does not exceed number of clock cycles it takes to draw the ball */

    logic [6:0] off_y, c_y;
    logic [7:0] off_x, c_x;
    logic [5:0] crit;

    enum {INIT, 1,2,3,4,5,6,7,8, DONE} octant, next_octant;

    always_ff @(posedge clock) begin
        if (reset)
            octant = INIT;
        else
            octant = next_octant;
    end

    always_comb begin
        case (octant)
            INIT: next_octant = 1;
            1: next_octant = 2;
            2: next_octant = 3;
            3: next_octant = 4;
            4: next_octant = 5;
            5: next_octant = 6;
            6: next_octant = 7;
            7: next_octant = 8;
            8:
                if (off_y <= off_x)
                    next_octant = 1;
                else 
                    next_octant = DONE;
            DONE:
                if (c_x != x | c_y != y)
                    next_octant = 1;
                else
                    next_octant = DONE;
        endcase
    end

    always_ff @(posedge clock) begin
        if (octant == 8) begin
            off_y = off_y + 1;
            if (crit <=0) begin
                crit <= crit + 2*off_y + 1;
            end
            else begin
                off_x <= off_x - 1;
                crit <= crit + 2 * (off_y-off_x) + 1;
            end
        end
        if (octant == DONE | octant == INIT) begin
            c_x <= x;
            c_y <= y;
        end
    end

    always_comb begin
        case (octant)
            vga_x = 8'd80;
            vga_y = 7'd60;
            vga_plot = 1;
            INIT: begin
                vga_plot = 0;
            end
            1: begin
                vga_x = c_x + off_x;
                vga_y = c_y + off_y;
            end
            2: begin
                vga_x = c_x + off_y;
                vga_y = c_y + off_x;
            end
            3: begin
                vga_x = c_x - off_y;
                vga_y = c_y + off_x;
            end
            4: begin
                vga_x = c_x - off_x;
                vga_y = c_y + off_y;
            end
            5: begin
                vga_x = c_x - off_x;
                vga_y = c_y - off_y;
            end
            6: begin
                vga_x = c_x - off_y;
                vga_y = c_y - off_x;
            end
            7: begin
                vga_x = c_x + off_y;
                vga_y = c_y - off_x;
            end
            8: begin
                vga_x = c_x + off_x;
                vga_y = c_y - off_y;
            end
        endcase
    end

    assign off_x = radius;

endmodule