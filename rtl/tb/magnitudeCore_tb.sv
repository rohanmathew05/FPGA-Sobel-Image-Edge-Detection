module magnitudeCore_tb;

    logic clk;
    logic reset;
    logic valid_in;

    logic signed [11:0] gx;
    logic signed [11:0] gy;

    logic [11:0] magnitude;
    logic magnitude_out;

    logic [11:0] expected_magnitude;

    magnitudeCore dut (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .gx(gx),
        .gy(gy),
        .magnitude(magnitude),
        .magnitude_out(magnitude_out)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        valid_in = 0;
    
        // Input params set to 0
        gx = 0;
        gy = 0;

        // Expected magnitude
        expected_magnitude = 120;

        // Reset
        #10;
        reset = 0;

        // send gx and gy value
        gx = 88;
        gy = 32;
        valid_in = 1;

        #10;

        // Turn off valid_in
        valid_in = 0;
        #10;
        $finish;

    end


    // Check result
    always @(posedge clk) begin

        if (magnitude_out) begin
            if (magnitude == expected_magnitude) begin
                $display(
                    "PASS:Magnitude=%0d",
                    magnitude
                );
            end
            else begin
                $display(
                    "FAIL: Expected Magnitude = %0d, Got = %0d",
                    expected_magnitude,
                    magnitude
                );
            end
        end

    end

    
endmodule