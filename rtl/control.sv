module control (
    input logic clk, 
    input logic reset,
    input logic pixel_valid,

    output logic [9:0] row,
    output logic [9:0] column,
    output logic window_valid
);

    parameter IMAGE_WIDTH = 600;

    always_ff @( posedge clk ) begin 
        if (reset) begin
            row <= 0;
            column <= 0;
            window_valid <= 0;
        end
        else if (pixel_valid) begin
            window_valid <= (row >= 2) && (column >= 2);
            if (column == IMAGE_WIDTH -1) begin
                column <= 0;
                row <= row + 1;
            end
            else begin
                column <= column + 1;
            end
        end
        else 
            window_valid <= 0;
    end
    
endmodule