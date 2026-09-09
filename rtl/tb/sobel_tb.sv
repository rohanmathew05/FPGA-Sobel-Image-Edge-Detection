module sobel_tb;

    logic clk;
    logic reset;

    logic pixel_valid;
    logic [7:0] pixel_in;

    logic [11:0] magnitude;
    logic magnitude_out;

    logic [7:0] image [0:24];

    // Delayed copies of the window so it lines up with magnitude_out
    logic [7:0] window_d1 [0:2][0:2];
    logic [7:0] window_d2 [0:2][0:2];


    sobelTop #(
        .IMAGE_WIDTH(5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .magnitude(magnitude),
        .magnitude_out(magnitude_out)
    );


    // Clock
    always #5 clk = ~clk;


    // Delay the window by 2 clock cycles
    // This allows the window to line up with magnitude_out.
    always_ff @(posedge clk) begin
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                window_d1[i][j] <= dut.window[i][j];
                window_d2[i][j] <= window_d1[i][j];
            end
        end
    end


    // Debug / output monitor
    always @(posedge clk) begin
        #1;

        // $display(
        //     "TIME=%0t pixel=%0d row=%0d col=%0d window_valid=%0d sobel_valid=%0d magnitude_out=%0d",
        //     $time,
        //     pixel_in,
        //     dut.row,
        //     dut.column,
        //     dut.window_valid,
        //     dut.sobel_valid,
        //     dut.magnitude_out
        // );

        // $display(
        //     "gx=%0d gy=%0d magnitude=%0d",
        //     dut.gx,
        //     dut.gy,
        //     magnitude
        // );

        if (magnitude_out) begin

            $display("Magnitude: %0d", magnitude);

            $display("%0d %0d %0d",
                window_d2[0][0],
                window_d2[0][1],
                window_d2[0][2]
            );

            $display("%0d %0d %0d",
                window_d2[1][0],
                window_d2[1][1],
                window_d2[1][2]
            );

            $display("%0d %0d %0d",
                window_d2[2][0],
                window_d2[2][1],
                window_d2[2][2]
            );

            $display("");
        end
    end


    // Test image
    initial begin

        // 5x5 image
        image[0]  = 10;
        image[1]  = 21;
        image[2]  = 32;
        image[3]  = 43;
        image[4]  = 54;

        image[5]  = 15;
        image[6]  = 26;
        image[7]  = 37;
        image[8]  = 48;
        image[9]  = 59;

        image[10] = 18;
        image[11] = 29;
        image[12] = 40;
        image[13] = 51;
        image[14] = 62;

        image[15] = 23;
        image[16] = 34;
        image[17] = 45;
        image[18] = 56;
        image[19] = 67;

        image[20] = 27;
        image[21] = 38;
        image[22] = 49;
        image[23] = 60;
        image[24] = 71;


        // Initial values
        clk = 0;
        reset = 1;
        pixel_valid = 0;
        pixel_in = 0;


        // Reset
        #20;

        reset = 0;
        pixel_valid = 1;


        // Send image pixels
        for (int i = 0; i < 25; i++) begin
            pixel_in = image[i];
            #10;
        end


        // Stop sending pixels
        pixel_valid = 0;
        pixel_in = 0;


        // Allow pipeline to finish
        #30;

        $finish;

    end

endmodule