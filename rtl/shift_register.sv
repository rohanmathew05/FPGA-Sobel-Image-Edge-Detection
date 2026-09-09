module shiftRegister (
    input logic clk,
    input logic reset,
    input logic valid_in,
    input logic [7:0] pixel_in,

    output logic [7:0] pixel_0,
    output logic [7:0] pixel_1,
    output logic [7:0] pixel_2
);

    always_ff @( posedge clk ) begin 
        if (reset) begin
            pixel_0 <= 0;
            pixel_1 <= 0;
            pixel_2 <= 0;
        end
        else if (valid_in) begin
            pixel_0 <= pixel_1;
            pixel_1 <= pixel_2;
            pixel_2 <= pixel_in;
        end

    end
    
endmodule