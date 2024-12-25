module tb_trajectory();

    logic clock=0, active, direction=1;
    logic [63:0] threshold;
    logic [8:0] coordinate;

    trajectory #(8) dut (.*);

    always #5 clock = !clock;


    initial begin
        threshold = 64'd50;
        active = 1'b0; #1000;
        active = 1'b1;
        direction = 1'b1; #3000;
        direction = 1'b0; #3000;
        $stop();
    end

    initial begin
        $monitor("threshold: %d, active: %b, coordinate: %d", threshold, active, coordinate);
    end

endmodule