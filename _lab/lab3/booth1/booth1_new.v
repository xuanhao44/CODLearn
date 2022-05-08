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
reg [DATA_WIDTH - 1 : 0] cnt;

// double sign digits
reg [DATA_WIDTH     : 0] x_t;
reg [DATA_WIDTH     : 0] x_c;
// only one sign digit, but has an additional bit
reg [DATA_WIDTH     : 0] y_t;

reg sign;

wire [DATA_WIDTH : 0] z_t = {sign, z[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_t;
wire [DATA_WIDTH : 0] z_c = {sign, z[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_c;

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
        // y
        y_t <= {y, 1'b0};
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        busy <= 0;
    end
    else if (start) begin
        cnt <= 0;
        busy <= 1;
    end
    else if (cnt != DATA_WIDTH && busy) begin
        cnt <= cnt + 1;
    end
    else begin
        // cnt = DATA_WIDTH (CNT_END)
        busy <= 0;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n || start) begin
        sign <= 0;
        z <= 0;
    end
    else if (cnt != DATA_WIDTH && busy) begin
        case ({y_t[cnt + 1], y_t[cnt]})
            2'b01: {sign, z} <= {z_t[DATA_WIDTH], z_t, z[DATA_WIDTH - 1 : 1]};
            2'b10: {sign, z} <= {z_c[DATA_WIDTH], z_c, z[DATA_WIDTH - 1 : 1]};
            default: z <= {sign, z[DATA_WIDTH * 2 - 1 : 1]}; // other case, with no operation
        endcase
    end
end

endmodule
