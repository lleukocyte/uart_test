`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2025 22:17:12
// Design Name: 
// Module Name: interfaces
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

interface axi_if #(parameter real PERIOD = 10.0);

bit s_axi_aclk;
bit s_axi_aresetn;
logic freeze;
logic ip2intc_irpt;

logic [12:0] s_axi_araddr;
logic s_axi_arready;
logic s_axi_arvalid;

logic [12:0] s_axi_awaddr;
logic s_axi_awready;
logic s_axi_awvalid;

logic [1:0] s_axi_bresp;
logic s_axi_bready;
logic s_axi_bvalid;

logic [31:0] s_axi_rdata;
logic [1:0] s_axi_rresp;
logic s_axi_rready;
logic s_axi_rvalid;

logic [31:0] s_axi_wdata;
logic [3:0] s_axi_wstrb;
logic s_axi_wready;
logic s_axi_wvalid;

int divisor;

task reset;
    s_axi_aresetn = 1'b0;
    @(negedge s_axi_aclk);
    @(negedge s_axi_aclk);
    s_axi_aresetn = 1'b1;
endtask : reset

task set_waddr(input logic [12:0] addr);
    @(posedge s_axi_aclk);
    s_axi_awvalid = 1'b1;
    s_axi_awaddr = addr;
    @(posedge s_axi_aclk);
    s_axi_awready = 1'b1;
endtask : set_waddr

task write_data();
    @(posedge s_axi_aclk);
    s_axi_wvalid = 1'b1;
    s_axi_wstrb = 4'b0001;
    @(posedge s_axi_aclk);
    s_axi_wready = 1'b1;
    @(posedge s_axi_aclk);
    s_axi_wready = 1'b0;
    s_axi_wvalid = 1'b0;
    s_axi_awready = 1'b0;
    s_axi_awvalid = 1'b0;
endtask : write_data

task set_lcr(input int wlen, input bit nstop_bits, input bit parity, input bit is_even, input bit divisor);
    set_waddr(13'h100c); 
    case (wlen)
        5 : s_axi_wdata[1:0] = 2'b00;
        6 : s_axi_wdata[1:0] = 2'b01;
        7 : s_axi_wdata[1:0] = 2'b10;
        8 : s_axi_wdata[1:0] = 2'b11;
    endcase
    s_axi_wdata[4:2] = {is_even, parity, nstop_bits};
    s_axi_wdata[6:5] = 2'b00;
    s_axi_wdata[7] = divisor;
    write_data();
endtask : set_lcr

task set_format(input int wlen, input bit nstop_bits, input bit parity, input bit is_even, int baud_rate);
    set_lcr(wlen, nstop_bits, parity, is_even, 1);
    set_baud_rate(baud_rate);
    set_lcr(wlen, nstop_bits, parity, is_even, 0);
endtask : set_format

task enable_fifo(input int trigger_level);
    set_waddr(13'h1008);
    case (trigger_level)
        1 : s_axi_wdata[7:6] = 2'b00;
        4 : s_axi_wdata[7:6] = 2'b01;
        8 : s_axi_wdata[7:6] = 2'b10;
        14 : s_axi_wdata[7:6] = 2'b11;
    endcase
    s_axi_wdata[5:4] = 2'b00;
    s_axi_wdata[3] = 1'b1;
    s_axi_wdata[2:1] = 2'b00;
    s_axi_wdata[0] = 1'b1;
    write_data();
endtask : enable_fifo

task enable_interrupts();
    set_waddr(13'h1004);
    s_axi_wdata[2:0] = 3'b111;
    s_axi_wdata[7:3] = 5'h00;
    write_data();
endtask : enable_interrupts

task set_baud_rate(int rate);
    set_waddr(13'h1000);
    divisor = 1000000000 / (16 * PERIOD * rate);
    s_axi_wdata[7:0] = divisor[7:0];
    write_data();
    set_waddr(13'h1004);
    s_axi_wdata[7:0] = divisor[15:8];
    write_data();
endtask : set_baud_rate

initial begin
    s_axi_aclk = 1'b0;
    forever #(PERIOD/2) s_axi_aclk = ~s_axi_aclk;
end

endinterface


interface uart_if;

logic baudoutn;
logic ctsn;
logic dcdn;
logic ddis;
logic dsrn;
logic dtrn;
logic out1n;
logic out2n;
logic rin;
logic rtsn;
logic sin;
logic rxrdyn;
logic sout;
logic txrdyn;

endinterface