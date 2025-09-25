`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    localparam int BAUDTIME = 7850;
    
    uvm_analysis_port #(sequence_item) item_ap;
    virtual uart_if uartif;
    virtual axi_if axi;
    bit calc_parity = 1'b0;
    sequence_item s_item;
    bit rx_done = 1'b0;
    bit tx_done = 1'b0;
    bit rx_is_first = 1'b1;
    bit tx_is_first = 1'b1;
    
    bit [31:0] rx_rcvd;
    bit [7:0] rx_sent;
    bit [7:0] tx_rcvd;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        item_ap = new("item_ap", this);
        s_item = sequence_item::type_id::create("s_item");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uartif", uartif))
        `uvm_fatal("MONITOR", "Failed to get uart interface")
        
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
   endfunction
    
    virtual task run_phase(uvm_phase phase);
        fork
            forever begin
                @(posedge axi.s_axi_wready);
                s_item.tx_data = axi.s_axi_wdata[7:0];
                
                @(negedge uartif.tx);
                if (tx_is_first) begin
                    tx_is_first = 1'b0;
                    @(negedge uartif.tx);                
                end
                #(BAUDTIME/2);
                calc_parity = 1'b0;
                for (int i=0; i < 8; i++) begin
                    #BAUDTIME;
                    calc_parity = calc_parity ^ uartif.tx;
                    tx_rcvd[i] = uartif.tx;
                end
                #BAUDTIME;
                s_item.parity = uartif.tx;
                s_item.calc_parity = calc_parity;
                s_item.tx_rcvd = tx_rcvd;
                tx_done = 1'b1;
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
                s_item.rx_data = rx_sent;
                
                @(negedge uartif.interrupt);
                axi.set_raddr(4'h0);
                axi.read_data(rx_rcvd);
                s_item.rx_rcvd = rx_rcvd[7:0];
                rx_done = 1'b1;
            end
            
            forever begin
                wait(rx_done && tx_done);
                item_ap.write(s_item);
                rx_done = 1'b0;
                tx_done = 1'b0;
            end
        join_none
    endtask : run_phase
    
endclass