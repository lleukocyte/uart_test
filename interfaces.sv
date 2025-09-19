`timescale 1ns / 1ns

interface axi_if;

bit s_axi_aclk;
bit s_axi_aresetn;

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

task reset;
    s_axi_aresetn = 1'b0;
    @(negedge s_axi_aclk);
    @(negedge s_axi_aclk);
    s_axi_aresetn = 1'b1;
endtask : reset

task set_waddr(input logic [3:0] addr);
    @(posedge s_axi_aclk);
    s_axi_awvalid <= 1'b1;
    s_axi_awaddr <= addr;
endtask : set_waddr

task write_data(input logic [31:0] data);
    @(posedge s_axi_aclk);
    s_axi_awvalid <= 1'b1;
    s_axi_wdata <= data;
    s_axi_wvalid <= 1'b1;
    s_axi_bready <= 1'b1;
    s_axi_wstrb <= 4'b0001;
    @(posedge s_axi_aclk);
    @(posedge s_axi_aclk);
    s_axi_wvalid <= 1'b0;
    s_axi_awvalid <= 1'b0;
endtask : write_data

task set_raddr(input logic [3:0] addr);
    @(posedge s_axi_aclk);
    s_axi_arvalid <= 1'b1;
    s_axi_araddr <= addr;
endtask : set_raddr

task read_data(output logic [31:0] data);
    @(posedge s_axi_aclk);
    s_axi_rready <= 1'b1;
    @(posedge s_axi_rvalid);
    data <= s_axi_rdata;
    s_axi_arvalid <= 1'b0;
    s_axi_rready <= 1'b0;
endtask : read_data

initial begin
    s_axi_aclk = 1'b0;
    forever #5 s_axi_aclk = ~s_axi_aclk;
end

endinterface


interface uart_if;

logic rx;
logic tx;
logic interrupt;

initial begin
    rx = 1'b1;
end

endinterface