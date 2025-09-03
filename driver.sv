`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2025 19:56:07
// Design Name: 
// Module Name: driver
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

class driver extends uvm_driver #(sequence_item);
   `uvm_component_utils(driver)

   virtual axi_if axi;
   virtual uart_if uartif;
 
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uartif", uartif))
        `uvm_fatal("DRIVER", "Failed to get uart interface")
   endfunction

   task run_phase(uvm_phase phase);
      sequence_item trans;

      forever begin
         
         seq_item_port.item_done();
      end
   endtask
   
endclass