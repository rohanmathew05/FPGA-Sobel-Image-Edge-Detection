module sobel_image_tb;

    parameter IMAGE_WIDTH  = 201;
    parameter IMAGE_HEIGHT = 251;
    parameter TOTAL_PIXELS = IMAGE_WIDTH * IMAGE_HEIGHT;

    logic clk;
    logic reset;

    logic pixel_valid;
    logic [7:0] pixel_in;

    logic [11:0] magnitude;
    logic magnitude_out;

    // Delayed window for checking which window produced the output
    logic [7:0] window_d1 [0:2][0:2];
    logic [7:0] window_d2 [0:2][0:2];

    integer input_file;
    integer output_file;
    integer status;
    integer pixel;


    // DUT
    sobelTop #(
        .IMAGE_WIDTH(IMAGE_WIDTH)
    )
    dut (
        .clk(clk),
        .reset(reset),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .magnitude(magnitude),
        .magnitude_out(magnitude_out)
    );


    // Clock
    always #5 clk = ~clk;


    // Delay window so it lines up with magnitude output
    always_ff @(posedge clk) begin
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                window_d1[i][j] <= dut.window[i][j];
                window_d2[i][j] <= window_d1[i][j];
            end
        end
    end


    // Monitor Sobel output
    always @(posedge clk) begin
        #1;

        if (magnitude_out) begin

            // Write magnitude to output file
            $fwrite(output_file, "%0d\n", magnitude);

            // Display result in Vivado console
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


    // Main test
    initial begin

        clk = 0;
        reset = 1;
        pixel_valid = 0;
        pixel_in = 0;


        // Reset
        #20;
        reset = 0;


        // Open input file
        input_file = $fopen("fpga_io/pixels.txt", "r");

        if (input_file == 0) begin
            $fatal("ERROR: Could not open pixels.txt");
        end


        // Open output file
        output_file = $fopen("output.txt", "w");

        if (output_file == 0) begin
            $fatal("ERROR: Could not create output.txt");
        end


        $display("=================================");
        $display("Starting Sobel image processing");
        $display("Image size: %0d x %0d", IMAGE_WIDTH, IMAGE_HEIGHT);
        $display("Total pixels: %0d", TOTAL_PIXELS);
        $display("=================================");


        // Send image pixels into Sobel
        for (int i = 0; i < TOTAL_PIXELS; i++) begin

            status = $fscanf(input_file, "%d", pixel);

            if (status != 1) begin
                $fatal("ERROR: Could not read pixel %0d", i);
            end

            pixel_in = pixel;
            pixel_valid = 1;

            #10;
        end


        // Finished sending image
        pixel_valid = 0;
        pixel_in = 0;


        $fclose(input_file);

        $display("Finished sending image.");


        // Allow pipeline to finish
        #50;


        $fclose(output_file);

        $display("Output written to output.txt");

        $finish;

    end

endmodule