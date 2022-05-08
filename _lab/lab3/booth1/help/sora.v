module booth (
    input  wire        clk  ,
    input  wire        rst_n,
    input  wire [15:0] x    ,
    input  wire [15:0] y    ,
    input  wire        start,
    output reg  [31:0] z    ,
    output wire        busy
);

reg[3:0] cnt;
reg sign_d;
reg busy_reg;
reg [15:0] savex;
reg [15:0] savey;

wire [16:0] px = {savex[15], savex};
wire [16:0] nx = ~px + 1;
wire [16:0] opt = {savey, 1'b0};
wire cnt_end = {cnt == 15};
wire [16:0] pz = {sign_d, z[31:16]} + px;
wire [16:0] nz = {sign_d, z[31:16]} + nx;

assign busy = busy_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n || start) cnt <= 0;
    else if (busy && ~cnt_end) cnt <= cnt + 1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        savex <= 0;
        savey <= 0;
    end
    else if (start) begin
        savex <= x;
        savey <= y;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) busy_reg <= 1'b0;
    else if (start) busy_reg <= 1'b1;
    else if (cnt_end) busy_reg <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n || start) begin
        z <= 0;
        sign_d <= 0;
    end
    else if (busy) begin
        case ({opt[cnt + 1], opt[cnt]})
            // wire [16:0] pz = {sign_d, z[31:16]} + px;
            2'b01: {sign_d, z} <= {pz[16], pz, z[15:1]};
            // wire [16:0] nz = {sign_d, z[31:16]} + nx;
            2'b10: {sign_d, z} <= {nz[16], nz, z[15:1]};
            default: z <= {sign_d, z[31:1]};
        endcase
    end
end

endmodule
