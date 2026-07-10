`timescale 1ns / 1ps
module interrupt_controller(
    input  wire [3:0] irq,         
    input  wire       clk,
    input  wire       rst,
    input  wire       irq_ack,     
    output reg        intr_valid,  
    output reg  [1:0] intr_id      
);

    
    reg [3:0] irq_latched;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq_latched <= 4'b0000;
            intr_valid  <= 1'b0;
            intr_id     <= 2'b00;
        end else begin
            
            if (irq_ack) begin
                irq_latched <= irq_latched & ~(4'b0001 << intr_id);
                intr_valid  <= 1'b0;
            end else begin
                irq_latched <= irq_latched | irq;
                
               
                if (irq_latched[3]) begin
                    intr_id    <= 2'b11;
                    intr_valid <= 1'b1;
                end else if (irq_latched[2]) begin
                    intr_id    <= 2'b10;
                    intr_valid <= 1'b1;
                end else if (irq_latched[1]) begin
                    intr_id    <= 2'b01;
                    intr_valid <= 1'b1;
                end else if (irq_latched[0]) begin
                    intr_id    <= 2'b00;
                    intr_valid <= 1'b1;
                end else begin
                    intr_valid <= 1'b0;
                end
            end
        end
    end
endmodule
