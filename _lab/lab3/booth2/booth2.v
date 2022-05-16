`timescale 1ns / 1ps
module booth2#(
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
reg [DATA_WIDTH - 1 : 0] cnt ;

// double sign digits
reg [DATA_WIDTH     : 0] x_t1;
reg [DATA_WIDTH     : 0] x_t2;
reg [DATA_WIDTH     : 0] x_c1;
reg [DATA_WIDTH     : 0] x_c2;
reg [DATA_WIDTH + 1 : 0] y_t ;

reg sign;

wire [DATA_WIDTH : 0] z_t1 = {sign, z[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_t1;
wire [DATA_WIDTH : 0] z_c1 = {sign, z[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_c1;
wire [DATA_WIDTH : 0] z_t2 = {sign, z[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_t2;
wire [DATA_WIDTH : 0] z_c2 = {sign, z[DATA_WIDTH * 2 - 1 : DATA_WIDTH]} + x_c2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        x_t1 <= 0;
        x_t2 <= 0;
        x_c1 <= 0;
        x_c2 <= 0;
        y_t <= 0;
    end
    else if (start) begin
        // x
        x_t1 <= {x[DATA_WIDTH - 1], x};
        x_t2 <= ({x[DATA_WIDTH - 1], x}) << 1;
        // x's complement
        x_c1 <= ~{x[DATA_WIDTH - 1], x} + 1;
        x_c2 <= (~{x[DATA_WIDTH - 1], x} + 1) << 1;
        // y
        y_t <= {y[DATA_WIDTH - 1], y, 1'b0};
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
        cnt <= cnt + 2;
    end
    else begin
        // cnt = DATA_WIDTH
        busy <= 0;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n || start) begin
        sign <= 0;
        z <= 0;
    end
    else if (cnt != DATA_WIDTH && busy) begin
        case ({y_t[cnt + 2], y_t[cnt + 1], y_t[cnt]})
            // what is most important: when shift, only need the highest bit!!!
            // for example: {sign, z} <= {z_t1[DATA_WIDTH : DATA_WIDTH - 1], z_t1, z[DATA_WIDTH - 1 : 2]}; is wrong!
            // we just need the highest bit!
            3'b001, 3'b010: {sign, z} <= {{2{z_t1[DATA_WIDTH]}}, z_t1, z[DATA_WIDTH - 1 : 2]};
            3'b101, 3'b110: {sign, z} <= {{2{z_c1[DATA_WIDTH]}}, z_c1, z[DATA_WIDTH - 1 : 2]};
			3'b011: {sign, z} <= {{2{z_t2[DATA_WIDTH]}}, z_t2, z[DATA_WIDTH - 1 : 2]};
			3'b100: {sign, z} <= {{2{z_c2[DATA_WIDTH]}}, z_c2, z[DATA_WIDTH - 1 : 2]};
			default: z <= {{2{sign}}, z[DATA_WIDTH * 2 - 1 : 2]}; // other case, with no operation
        endcase
    end
end

endmodule
