module magnitudeCore (
    input logic clk,
    input logic reset,
    input logic valid_in,

    input logic signed [11:0] gx, // signed as it could be negetive
    input logic signed [11:0] gy,

    output logic [11:0] magnitude,
    output logic magnitude_out
);

    always_ff @( posedge clk ) begin 
        if (reset) begin
            magnitude <=0;
            magnitude_out <= 0;
        end
        else begin
            magnitude <= (gx < 0 ? -gx : gx) + (gy < 0 ? -gy : gy);
            magnitude_out <= valid_in;  
        end
    end
    
endmodule