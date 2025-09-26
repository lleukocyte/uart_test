`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    localparam int BAUDTIME = 7850;
    
    uvm_analysis_port #(sequence_item) rx_ap;
    uvm_analysis_port #(sequence_item) tx_ap;
    virtual uart_if uartif;
    virtual axi_if axi;
    bit calc_parity = 1'b0;
    sequence_item s_item_rx;
    sequence_item s_item_tx;
    bit rx_is_first = 1'b1;
    bit tx_is_first = 1'b1;
    
    logic [31:0] rx_rcvd;
    logic [7:0] rx_sent;
    logic [7:0] tx_rcvd;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        rx_ap = new("rx_ap", this);
        tx_ap = new("tx_ap", this);
        s_item_tx = sequence_item::type_id::create("s_item_tx");
        s_item_rx = sequence_item::type_id::create("s_item_rx");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual uart_if)::get(this, "", "uartif", uartif))
        `uvm_fatal("MONITOR", "Failed to get uart interface")
        
      if(!uvm_config_db #(virtual axi_if)::get(this, "", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
   endfunction
    
    virtual task run_phase(uvm_phase phase);
        fork
            forever begin
                @(posedge axi.s_axi_wready);
                if (tx_is_first) begin
                    tx_is_first = 1'b0;
                    @(posedge axi.s_axi_wready);
                end
                s_item_tx.tx_data = axi.s_axi_wdata[7:0];
                
                @(negedge uartif.tx);
                #(BAUDTIME/2);
                calc_parity = 1'b0;
                for (int i=0; i < 8; i++) begin
                    #BAUDTIME;
                    calc_parity = calc_parity ^ uartif.tx;
                    tx_rcvd[i] = uartif.tx;
                end
                #BAUDTIME;
                s_item_tx.parity = uartif.tx;
                s_item_tx.calc_parity = calc_parity;
                s_item_tx.tx_rcvd = tx_rcvd;
                tx_ap.write(s_item_tx);
            end
            
            forever begin
                @(negedge uartif.rx);
                if (rx_is_first) begin
                    rx_is_first = 1'b0;
                    @(negedge uartif.rx);
                end
                #(BAUDTIME/2);
                for (int i=0; i < 8; i++) begin
                    #BAUDTIME;
                    rx_sent[i] = uartif.rx;
                end
                s_item_rx.rx_data = rx_sent;
                
                @(posedge uartif.interrupt);
                axi.set_raddr(4'h0);
                axi.read_data(rx_rcvd);
                s_item_rx.rx_rcvd = rx_rcvd[7:0];
                rx_ap.write(s_item_rx);
            end
        join_none
    endtask : run_phase
    
endclass