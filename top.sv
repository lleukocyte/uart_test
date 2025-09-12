`timescale 1ns / 1ns

module top;
   axi_if axi();
   uart_if uartif();
   
   axi_uart DUT (.s_axi_araddr(axi.s_axi_araddr), .s_axi_arready(axi.s_axi_arready), .s_axi_arvalid(axi.s_axi_arvalid),
             .s_axi_awaddr(axi.s_axi_awaddr), .s_axi_awready(axi.s_axi_awready), .s_axi_awvalid(axi.s_axi_awvalid),
             .s_axi_bresp(axi.s_axi_bresp), .s_axi_bready(axi.s_axi_bready), .s_axi_bvalid(axi.s_axi_bvalid),
             .s_axi_rdata(axi.s_axi_rdata), .s_axi_rready(axi.s_axi_rready), .s_axi_rresp(axi.s_axi_rresp), .s_axi_rvalid(axi.s_axi_rvalid),
             .s_axi_wdata(axi.s_axi_wdata), .s_axi_wready(axi.s_axi_wready), .s_axi_wstrb(axi.s_axi_wstrb), .s_axi_wvalid(axi.s_axi_wvalid),
             .s_axi_aclk(axi.s_axi_aclk), .s_axi_aresetn(axi.s_axi_aresetn), .freeze(axi.freeze), .ip2intc_irpt(axi.ip2intc_irpt),
             .baudoutn(uartif.baudoutn), .ctsn(uartif.ctsn), .dcdn(uartif.dcdn), .ddis(uartif.ddis), .dsrn(uartif.dsrn),
             .dtrn(uartif.dtrn), .out1n(uartif.out1n), .out2n(uartif.out2n), .rin(uartif.rin), .rtsn(uartif.rtsn), .sin(uartif.sin),
             .rxrdyn(uartif.rxrdyn), .sout(uartif.sout), .txrdyn(uartif.txrdyn));

initial begin
  uvm_config_db #(virtual axi_if)::set(null, "*", "axi", axi);
  uvm_config_db #(virtual uart_if)::set(null, "*", "uartif", uartif);
  run_test();
end

endmodule : top
