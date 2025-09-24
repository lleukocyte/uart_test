`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    localparam int BAUDTIME = 7850;
    
    uvm_analysis_port #(sequence_item) item_ap;
    virtual uart_if uartif;
    virtual axi_if axi;
    bit parity;
    bit calc_parity = 1'b0;
    sequence_item s_item;
    event rx_done, tx_done;
    bit rxd, txd;
    bit is_first = 1'b1;
    
    bit [31:0] rx_rcvd;
    bit [7:0] tx_rcvd;
    
    int checks_en;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        item_ap = new("item_ap", this);
        s_item = sequence_item::type_id::create("s_item");
    endfunction : new
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db #(int)::get(null, "*", "checks_en", checks_en);
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uartif", uartif))
        `uvm_fatal("MONITOR", "Failed to get uart interface")
        
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
   endfunction
    
    virtual task run_phase(uvm_phase phase);
        fork
            forever begin
                @(negedge uartif.tx);
                if (is_first) begin
                    is_first = 1'b0;
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
                parity = uartif.tx;
                if (checks_en)
                    check_tx();
                ->tx_done;
            end
            
            forever begin
                @(negedge uartif.interrupt);
                axi.set_raddr(4'h0);
                axi.read_data(rx_rcvd);
                if (checks_en)
                    check_rx();
                ->rx_done;
            end
            
            forever begin
                @(posedge tx_done);
                txd = 1'b1;
            end

            forever begin
                @(posedge rx_done);
                rxd = 1'b1;
            end
            
            forever begin
                wait(rxd && txd);
                item_ap.write(s_item);
                rxd = 1'b0;
                txd = 1'b0;
            end
        join_none
    endtask : run_phase
    
    function void check_tx();
        // Perform data checks on trans_collected.
    endfunction : check_tx
    
    function void check_rx();
        // Perform data checks on trans_collected.
    endfunction : check_rx
    
endclass