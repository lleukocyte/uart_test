`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class env extends uvm_env;
    `uvm_component_utils(env)
    
   sequencer sequencer_h;
   //scoreboard scoreboard_h;
   agent agent_h;
   
   function new (string name, uvm_component parent);
        super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_h = agent::type_id::create("agent_h",this);
        //scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
   endfunction : build_phase
   
   virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        sequencer_h = agent_h.sequencer_h;
    endfunction : end_of_elaboration_phase

   function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
   endfunction : connect_phase
endclass