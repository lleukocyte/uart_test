`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2025 23:24:20
// Design Name: 
// Module Name: sequencer
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

class sequencer extends uvm_sequencer #(data_item);
  `uvm_component_utils(sequencer)
 
  uvm_analysis_port #(data_item) item_ap;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
    item_ap = new("item_ap", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
endclass