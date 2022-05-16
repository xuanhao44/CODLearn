module booth2 (
	input clk,
	input rst_n,
	input[15:0] x,
	input[15:0] y,
	input start,
	output reg [31:0] z,
	output reg busy
);

reg[3:0] addr;
reg[15:0] savex;
reg[15:0] savey;
wire[17:0] px = {{2{savex[15]}}, savex};
wire[17:0] nx = (~px) + 1;
wire[17:0] p2x = {px[16:0], 1'b0};
wire[17:0] n2x = {nx[16:0], 1'b0};
wire[31:0] rz = {{2{z[31]}}, z[31:2]};
wire[16:0] opt = {savey, 1'b0};



always @(posedge clk, negedge rst_n) begin
    if (rst_n == 1'b0) begin
        busy <= 1'b0;
        addr <= 4'h0;
        z <= 32'h0;
        savex <= 16'h0;
        savey <= 16'h0;
    end
    else begin
        if (start == 1'b1) begin
            busy <= 1'b1;
            addr <= 4'h0;
            z <= 32'h0;
            savex <= x;
            savey <= y;
        end
        else if (busy == 1'b1) begin
            case ({opt[addr+2], opt[addr+1], opt[addr]})
                0: z[31:0] <= rz[31:0];
                1: z[31:0] <= {rz[31:14] + px, rz[13:0]};
                2: z[31:0] <= {rz[31:14] + px, rz[13:0]};
                3: z[31:0] <= {rz[31:14] + p2x, rz[13:0]};
                4: z[31:0] <= {rz[31:14] + n2x, rz[13:0]};
                5: z[31:0] <= {rz[31:14] + nx, rz[13:0]};
                6: z[31:0] <= {rz[31:14] + nx, rz[13:0]};
                7: z[31:0] <= rz[31:0];
            endcase
            if (addr == 4'he) busy <= 1'b0;
            else addr <= addr + 2;
        end
    end
end

endmodule
