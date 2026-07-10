`timescale 1ns/1ps
module tb_interrupt_ctrl;
    reg [3:0] irq;
    reg clk, rst, irq_ack;
    wire intr_valid;
    wire [1:0] intr_id;

    interrupt_controller uut (
        .irq(irq), .clk(clk), .rst(rst), 
        .irq_ack(irq_ack), .intr_valid(intr_valid), .intr_id(intr_id)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("interrupt.vcd"); $dumpvars(0, tb_interrupt_ctrl);
        clk = 0; rst = 1; irq = 0; irq_ack = 0; #20;
        rst = 0;

        // Scenario 1: Single low-priority interrupt
        #10 irq = 4'b0001; 
        #20 irq = 4'b0000;
        wait(intr_valid); #10 irq_ack = 1; #10 irq_ack = 0;

        // Scenario 2: Multiple simultaneous interrupts (Check Priority)
        #10 irq = 4'b0110; // IRQ 1 and 2
        #10 irq = 4'b0000;
        // Should service IRQ 2 first
        wait(intr_valid); #10 irq_ack = 1; #10 irq_ack = 0;
        // Should then immediately service IRQ 1
        wait(intr_valid); #10 irq_ack = 1; #10 irq_ack = 0;

        #50 $finish;
    end
endmodule