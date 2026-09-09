module lineBuffer (
    input logic clk,
    input logic reset,
    input logic [7:0] pixel_in,
    input logic [9:0] column,
    input logic pixel_valid,

    output logic [7:0] old_row1,
    output logic [7:0] old_row2
);

    parameter IMAGE_WIDTH = 600;

    logic [7:0] line_buffer_1 [0:IMAGE_WIDTH-1];
    logic [7:0] line_buffer_2 [0:IMAGE_WIDTH-1];

    assign old_row1 = line_buffer_1[column];
    assign old_row2 = line_buffer_2[column];

    always_ff @( posedge clk ) begin 
        if (reset) begin
            for (int i = 0; i < IMAGE_WIDTH; i++) begin
                line_buffer_1[i] <= 0;
                line_buffer_2[i] <= 0;
            end
        end
        else if (pixel_valid) begin
            line_buffer_1[column] <= line_buffer_2[column];
            line_buffer_2[column] <= pixel_in;
        end
        
    end

    
endmodule