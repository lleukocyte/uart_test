`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2025 19:56:07
// Design Name: 
// Module Name: environment
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

class env extends uvm_env;
    `uvm_component_utils(env);
    
   sequencer sequencer_h;
   uart_driver uart_driver_h;
   uart_monitor uart_monitor_h;
   scoreboard scoreboard_h;
   axi_driver axi_driver_h;
   axi_monitor axi_monitor_h;
   
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      sequencer_h = new("sequencer_h",this);
      uart_driver_h = uart_driver::type_id::create("uart_driver_h",this);
      axi_driver_h = axi_driver::type_id::create("axi_driver_h",this);
      uart_monitor_h = uart_monitor::type_id::create("uart_monitor_h",this);
      axi_monitor_h = axi_monitor::type_id::create("axi_monitor_h",this);
      scoreboard_h  = scoreboard::type_id::create("scoreboard",this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);

      uart_driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
      axi_driver_h.seq_item_port.connect(sequencer_h.seq_item_export);

      monitor_h.ap.connect(scoreboard_h.data_f.analysis_export);
   endfunction : connect_phase
endclass