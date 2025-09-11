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

class uart_driver extends uvm_driver #(sequence_item);
   `uvm_component_utils(uart_driver)

   sequence_item s_item;
   virtual uart_if uartif;
 
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uartif", uartif))
        `uvm_fatal("UART_DRIVER", "Failed to get uart interface")
   endfunction

   task run_phase(uvm_phase phase);
      sequence_item trans;

      forever begin
         seq_item_port.get_next_item(s_item);
         drive_item(s_item);
         seq_item_port.item_done();
      end
   endtask
   
   task drive_item (input simple_item item);
    //dsd
   endtask : drive_item
   
endclass

class axi_driver extends uvm_driver #(sequence_item);
   `uvm_component_utils(axi_driver)

    sequence_item s_item;
    virtual axi_if axi;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("UART_DRIVER", "Failed to get axi interface")
   endfunction

   task run_phase(uvm_phase phase);
      sequence_item trans;

      forever begin
         seq_item_port.get_next_item(s_item);
         drive_item(s_item);
         seq_item_port.item_done();
      end
   endtask
   
   task drive_item (input simple_item item);
        //dsd
   endtask : drive_item
   
endclass