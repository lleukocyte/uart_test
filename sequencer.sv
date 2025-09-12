`timescale 1ns / 1ns

class sequencer extends uvm_sequencer #(sequence_item);
  `uvm_component_utils(sequencer)
 
  uvm_analysis_port #(sequence_item) item_ap;
  
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