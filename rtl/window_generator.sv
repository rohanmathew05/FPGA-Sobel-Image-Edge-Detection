module windowGenerator (
    input logic clk,
    input logic reset, 
    input logic pixel_valid,
    input logic [7:0] pixel_in,
    input logic [7:0] old_row1,
    input logic [7:0] old_row2,

    output logic [7:0] window [0:2][0:2]

);

    logic [7:0] top_row [0:2];
    logic [7:0] mid_row [0:2];
    logic [7:0] bottom_row [0:2];

    shiftRegister top_shift (
        .clk(clk),
        .reset(reset),
        .valid_in(pixel_valid),
        .pixel_in(old_row1),
        .pixel_0(top_row[0]),
        .pixel_1(top_row[1]),
        .pixel_2(top_row[2])
    );

    shiftRegister mid_shift (
        .clk(clk),
        .reset(reset),
        .valid_in(pixel_valid),
        .pixel_in(old_row2),
        .pixel_0(mid_row[0]),
        .pixel_1(mid_row[1]),
        .pixel_2(mid_row[2])
    );

    shiftRegister bottom_shift (
        .clk(clk),
        .reset(reset),
        .valid_in(pixel_valid),
        .pixel_in(pixel_in),
        .pixel_0(bottom_row[0]),
        .pixel_1(bottom_row[1]),
        .pixel_2(bottom_row[2])
    );


    assign  window[0][0] = top_row[0];
    assign window[0][1] = top_row[1];
    assign window[0][2] = top_row[2];

    assign window[1][0] = mid_row[0];
    assign window[1][1] = mid_row[1];
    assign window[1][2] = mid_row[2];

    assign window[2][0] = bottom_row[0];
    assign window[2][1] = bottom_row[1];
    assign window[2][2] = bottom_row[2];
    
endmodule