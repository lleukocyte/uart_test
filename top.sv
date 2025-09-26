`timescale 1ns / 1ns

import test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top;
   localparam int BAUDTIME = 7850;

   axi_if axi();
   uart_if uartif();
   /*
   logic parity = 1'b0;
   logic db;
   logic [31:0] data = 32'h0000;
   logic [7:0] rbyte = 8'h71;
   logic rx;
   logic clk;
   logic reset;*/
   
   axi_uart DUT (.s_axi_araddr(axi.s_axi_araddr), .s_axi_arready(axi.s_axi_arready), .s_axi_arvalid(axi.s_axi_arvalid),
             .s_axi_awaddr(axi.s_axi_awaddr), .s_axi_awready(axi.s_axi_awready), .s_axi_awvalid(axi.s_axi_awvalid),
             .s_axi_bresp(axi.s_axi_bresp), .s_axi_bready(axi.s_axi_bready), .s_axi_bvalid(axi.s_axi_bvalid),
             .s_axi_rdata(axi.s_axi_rdata), .s_axi_rready(axi.s_axi_rready), .s_axi_rresp(axi.s_axi_rresp), .s_axi_rvalid(axi.s_axi_rvalid),
             .s_axi_wdata(axi.s_axi_wdata), .s_axi_wready(axi.s_axi_wready), .s_axi_wstrb(axi.s_axi_wstrb), .s_axi_wvalid(axi.s_axi_wvalid),
             .s_axi_aclk(axi.s_axi_aclk), .s_axi_aresetn(axi.s_axi_aresetn), .interrupt(uartif.interrupt), .rx(uartif.rx), .tx(uartif.tx));


initial begin
  uvm_config_db #(virtual axi_if)::set(null, "*", "axi", axi);
  uvm_config_db #(virtual uart_if)::set(null, "*", "uartif", uartif);
  uvm_config_db #(int)::set(null, "*", "checks_en", 1);
  run_test("base_test");
  /*
  assign rx = uartif.rx;
  assign clk = axi.s_axi_aclk;
  assign reset = axi.s_axi_aresetn;
  
  axi.reset();
  #100;
  axi.set_waddr(4'hC);
  axi.write_data(32'h0010);
  #100;
  /*uartif.rx = 1'b0;
  #BAUDTIME;
  uartif.rx = 1'b1;
  #BAUDTIME;
  uartif.rx = 1'b0;
  #BAUDTIME;
  for (int i=0; i < 8; i++) begin
        db = rbyte[i];
        uartif.rx = db;
        parity = parity ^ db;
        #BAUDTIME;
  end
  uartif.rx = parity;
  #BAUDTIME;
  uartif.rx = 1'b1;
  #(BAUDTIME);
  
  axi.set_raddr(4'h0);
  axi.read_data(data);
  
  rbyte = 8'h28;
  uartif.rx = 1'b0;
  #BAUDTIME;
  for (int i=0; i < 8; i++) begin
        db = rbyte[i];
        uartif.rx = db;
        parity = parity ^ db;
        #BAUDTIME;
  end
  uartif.rx = parity;
  #BAUDTIME;
  uartif.rx = 1'b1;
  #(BAUDTIME);
  axi.set_raddr(4'h0);
  axi.read_data(data);
  
  axi.set_waddr(4'h4);
  axi.write_data(32'h00a5);
  axi.set_waddr(4'h4);
  axi.write_data(32'h005a);*/
end

endmodule : top