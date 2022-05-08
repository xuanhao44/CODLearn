`timescale 1ns / 1ps
module booth#(
    parameter DATA_WIDTH = 16
)
(
    input  wire                          clk  ,
    input  wire                          rst_n,
    input  wire [DATA_WIDTH - 1     : 0] x    ,
    input  wire [DATA_WIDTH - 1     : 0] y    ,
    input  wire                          start,
    output reg  [DATA_WIDTH * 2 - 1 : 0] z    ,
    output reg                           busy
);


// count, from 0 to 16(10000)
reg [DATA_WIDTH - 1 : 0] cnt = 0 ;
// double sign digit
reg [DATA_WIDTH     : 0] x_t = 0 ;
reg [DATA_WIDTH     : 0] x_c = 0 ;
reg [DATA_WIDTH - 1 : 0] y_t = 0 ;
reg [DATA_WIDTH * 2 : 0] res = 0 ;
reg exp = 0;

always @ (*) begin
    if (start) begin
        // x
        x_t[DATA_WIDTH - 1 : 0] = x;
        x_t[DATA_WIDTH] = x_t[DATA_WIDTH - 1];
        // x's complement
        x_c[DATA_WIDTH - 1 : 0] = ~x + 1;
        x_c[DATA_WIDTH] = x_c[DATA_WIDTH - 1];
        // y
        y_t = y;
        // res
        res = 0;
        // init
        cnt = 0;
        exp = 0;
        busy = 1;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (cnt != DATA_WIDTH && busy) begin
        cnt <= cnt + 1;
    end
    else begin
        // cnt = CNT_END or busy = 0
        busy <= 0;
        z <= res[DATA_WIDTH * 2 - 1 : 0];
    end
end

always @ (*) begin
    if (cnt != DATA_WIDTH && busy) begin

        case ({y_t[0], exp})
            2'b01: res = {res[DATA_WIDTH * 2 : DATA_WIDTH] + x_t, res[DATA_WIDTH - 1 : 0]};
            2'b10: res = {res[DATA_WIDTH * 2 : DATA_WIDTH] + x_c, res[DATA_WIDTH - 1 : 0]};
            default: res = res;
        endcase

        res = {res[DATA_WIDTH * 2], res[DATA_WIDTH * 2 : 1]};
        exp = y_t[0];
        y_t = y_t >> 1;
    end
end

endmodule
