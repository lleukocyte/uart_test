`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class driver extends uvm_driver #(sequence_item);
   localparam int BAUDTIME = 7850;
   `uvm_component_utils(driver)

   sequence_item s_item;
   virtual uart_if uartif;
   virtual axi_if axi;
   bit parity = 1'b0;
   bit is_first = 1'b1;
 
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uartif", uartif))
        `uvm_fatal("DRIVER", "Failed to get uart interface")
        
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
   endfunction

   task run_phase(uvm_phase phase);
      forever begin
         seq_item_port.get_next_item(s_item);
         if (s_item == null) begin
            // idle trans
         end
         else begin
            drive_item(s_item);
            seq_item_port.item_done();
         end
      end
   endtask
   
   task drive_item (input sequence_item item);
        fork
            begin
                axi.set_waddr(4'h4);
                axi.write_data({24'h000, item.tx_data});
            end

            begin
                if (is_first) begin
                    is_first = 1'b0;
                    uartif.rx = 1'b0;
                    #BAUDTIME;
                    uartif.rx = 1'b1;
                    #BAUDTIME;
                end
                uartif.rx = 1'b0;
                #BAUDTIME;
                parity = 1'b0;
                for (int i=0; i < 8; i++) begin
                    parity = parity ^ item.rx_data[i];
                    uartif.rx = item.rx_data[i];
                    #BAUDTIME;
                end
                uartif.rx = parity;
                #BAUDTIME;
                uartif.rx = 1'b1;
                #BAUDTIME;
            end
        join
   endtask : drive_item
   
endclass