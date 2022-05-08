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
reg [DATA_WIDTH - 1 : 0]    cnt;

// double sign digits
reg [DATA_WIDTH     : 0]    x_t;
reg [DATA_WIDTH     : 0]    x_c;
reg [DATA_WIDTH     : 0]    y_t;

reg sign;
reg [DATA_WIDTH * 2 - 1: 0] res;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        x_t <= 0;
        x_c <= 0;
        y_t <= 0;
    end
    else if (start) begin
        // x
        x_t <= {x[DATA_WIDTH - 1], x};
        // x's complement
        x_c <= ~{x[DATA_WIDTH - 1], x} + 1;
        y_t <= {y, 1'b0};
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        busy <= 0;
        z <= 0;
    end
    else if (start) begin
        cnt <= 0;
        busy <= 1;
        z <= 0;
    end
    else if (cnt != DATA_WIDTH && busy) begin
        cnt <= cnt + 1;
    end
    else begin
        // cnt = DATA_WIDTH (CNT_END)
        busy <= 0;
        z <= res;
    end
end

always @ (*) begin
    if (start) begin
        sign = 0;
        res = 0;
    end
    else if (cnt != DATA_WIDTH && busy) begin
        case ({y_t[cnt + 1], y_t[cnt]})
            2'b01: res = {{sign, res[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_t, res[DATA_WIDTH - 1 : 0]} >> 1;
            2'b10: res = {{sign, res[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_c, res[DATA_WIDTH - 1 : 0]} >> 1;
            default: res = {sign, res} >> 1; // other case, with no operation
        endcase
        sign = res[DATA_WIDTH * 2 - 1];
    end
end

endmodule
