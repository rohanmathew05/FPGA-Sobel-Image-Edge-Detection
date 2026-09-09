module sobelCore_tb;

    logic clk;
    logic reset;

    logic [7:0] window [0:2][0:2];
    logic window_in;

    logic signed [11:0] gx;
    logic signed [11:0] gy;
    logic valid_out;

    logic signed [11:0] expected_gx;
    logic signed [11:0] expected_gy;

    sobelCore dut (
        .clk(clk),
        .reset(reset),
        .window(window),
        .window_in(window_in),
        .gx(gx),
        .gy(gy),
        .valid_out(valid_out)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        window_in = 0;

        // Expected Results
        expected_gx = 88;
        expected_gy = 32;

        // Test window
        window[0][0] = 10;
        window[0][1] = 21;
        window[0][2] = 32;
        window[1][0] = 15;
        window[1][1] = 26;
        window[1][2] = 37;
        window[2][0] = 18;
        window[2][1] = 29;
        window[2][2] = 40;

        // Release Reset
        #10;
        reset = 0;

        // window is valid trigger
        window_in = 1;

        #10;

        // stop sending data 
        window_in = 0;

        #10;

        $finish;
    end

    //Monitor & check result
    always @(posedge clk) begin
        #1;

        if (valid_out) begin
            if (gx == expected_gx && gy == expected_gy) begin
                $display("PASS: Gx = %0d Gy = %0d", gx, gy);
            end
            else begin
                $display("FAIL: Expected Gx=%0d Gy=%0d, Got Gx=%0d Gy=%0d",
                        expected_gx, expected_gy, gx, gy);
            end
        end
    end
    


endmodule