module sobelTop (
    input logic clk,
    input logic reset,

    input logic pixel_valid,
    input logic [7:0] pixel_in,

    output logic [11:0] magnitude,
    output logic magnitude_out
);
    parameter IMAGE_WIDTH = 600;

    logic [9:0] row;
    logic [9:0] column;
    
    logic [7:0] old_row1;
    logic [7:0] old_row2;

    logic [7:0] window [0:2][0:2];
    logic window_valid;

    logic sobel_valid;

    logic signed [11:0] gx;
    logic signed [11:0] gy;


    lineBuffer #(
        .IMAGE_WIDTH(IMAGE_WIDTH)
    )
    line_bufer (
        .clk(clk),
        .reset(reset),
        .pixel_in(pixel_in),
        .column(column),
        .pixel_valid(pixel_valid),
        .old_row1(old_row1),
        .old_row2(old_row2)
    );

    windowGenerator window_generator (
        .clk(clk),
        .reset(reset),
        .pixel_valid(pixel_valid),
        .pixel_in(pixel_in),
        .old_row1(old_row1),
        .old_row2(old_row2),
        .window(window)
    );

    sobelCore sobel_core (
        .clk(clk),
        .reset(reset),
        .window(window),
        .window_in(window_valid),
        .gx(gx),
        .gy(gy),
        .valid_out(sobel_valid)
    );

    control # (
        .IMAGE_WIDTH(IMAGE_WIDTH)
    ) control (
        .clk(clk),
        .reset(reset),
        .pixel_valid(pixel_valid),
        .row(row),
        .column(column),
        .window_valid(window_valid)
    );

    magnitudeCore magnitude_core (
        .clk(clk),
        .reset(reset),
        .gx(gx),
        .gy(gy),
        .valid_in(sobel_valid),
        .magnitude(magnitude),
        .magnitude_out(magnitude_out)
    );


endmodule