module sobelCore (
    input logic clk,
    input logic reset,
    input logic [7:0] window [0:2][0:2],
    input logic window_in,

    output logic signed [11:0] gx, // signed as it could be negetive
    output logic signed [11:0] gy,
    output logic valid_out
);

    always_ff @( posedge clk ) begin 
        if (reset) begin
            gx <= 0;
            gy <=0;
            valid_out <= 0;
        end
        else begin
            // Matrix Equations
            gx <= -window[0][0] + window[0][2] - 2*window[1][0] + 2*window[1][2] - window[2][0] + window[2][2];
            gy <= -window[0][0] -2*window[0][1] - window[0][2] + window[2][0] + 2*window[2][1] + window[2][2];
            valid_out <= window_in;
        end
    end

    
endmodule