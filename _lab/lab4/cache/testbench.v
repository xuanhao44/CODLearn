`timescale 1ns / 1ps

module testbench();

reg         clk;
reg         reset;
wire [12:0] end_addr = 13'b1_1111_1111_1111;
wire [11:0] count;
wire        rd_test_success;
wire        test_success;
wire        test_fail;

driver g0 (
    .clk_in             (clk            ),
    .reset_in           (reset          ),
    .end_addr           (end_addr       ),
    .count              (count          ),
    .rd_test_success    (rd_test_success),
    .test_success       (test_success   ),
    .test_fail          (test_fail      )
);

integer fp_w;
reg f0;
initial begin
    #0
    fp_w  = $fopen("result.txt", "w");
    reset = 1;
    clk   = 0;
    f0    = 0;
    #105 
    reset = 0;
end

always #10 clk = ~clk;

always @(posedge clk) begin
    if (g0.current_state == 4'h1)
        $display("���ʵ�ַΪ",g0.test_addr);
    if (g0.current_state == 4'h2 && g0.next_state == 4'h2 && !g0.cache_whit)
        $display("�ȴ�Cache��Ӧ��Ӧ�õ�����",g0.data_from_trace);
    if (g0.current_state == 4'h2 && g0.next_state == 4'h2 && g0.cache_whit)
        $display("�ȴ�Cache��Ӧ��Ӧ�õ�����",g0.cache_wdata);
    if (g0.current_state == 4'h2 && g0.cache_hit)
        $display("Cache������!");
    if (g0.current_state == 4'h3)
        $display("Cache��ȡ������", g0.data_from_cache);
    if (g0.current_state == 4'h3 && (g0.next_state == 4'h1 && !rd_test_success || g0.next_state == 4'h5 && rd_test_success))
        $display("�õ�ַ������ȷ����������һ����ַ\n ----------- ");
    if (g0.current_state == 4'h5)
        $display("д��ַΪ%d��д����Ϊ%d", g0.test_addr, g0.cache_wdata);
    if (g0.current_state == 4'h6 && g0.cache_hit)
        $display("Cacheд����!");
    if (g0.current_state == 4'h6 && !g0.cache_hit)
        $display("Cacheдȱʧ!");
    if (g0.current_state == 4'h8 && g0.next_state != 4'h8)
        $display("��ǰCache�б��滻");
end

always @(posedge clk) begin
    if (rd_test_success & !f0) begin
        $fwrite(fp_w, "CACHE-READING TEST PASSED\n");
        $fwrite(fp_w, "Cycles spent on reading cache: %d\n", count);
        $display("=======================��Cache����ȫ��ͨ��=========================");
        f0 <= 1;
    end
    if (test_success) begin
        $fwrite(fp_w, "CACHE-WRITING-HIT TEST PASSED\n");
        $fclose(fp_w);
        $display("=======================Cacheд����ȫ��ͨ��=========================");
        $display("========================���в���ȫ��ͨ����==========================");
        $stop;
    end
    if (test_fail) begin   
        $fwrite(fp_w, "TEST FAILED\n");
        $fwrite(fp_w, "At read addr %x, expect %x, but get %x\n", g0.test_addr, g0.data_from_trace, g0.data_from_cache);
        $fclose(fp_w);
        $display("==========================����δͨ���������뿴���������Ϣ==========================");
        $stop;
    end
end

endmodule
