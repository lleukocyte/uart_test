`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class base_test extends uvm_test;
    //`uvm_component_utils(base_test)
    typedef uvm_component_registry #(base_test, "base_test") type_id;
    env env_h;
    sequencer sequencer_h;
    simple_sequence seq;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = env::type_id::create("env_h",this);
        seq = simple_sequence::type_id::create("seq");
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        sequencer_h = env_h.agent_h.sequencer_h;
        if (env_h == null || env_h.agent_h == null || sequencer_h == null) 
            `uvm_fatal("TEST", "Null pointer in sequencer assignment")
    endfunction : end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(sequencer_h);
        phase.drop_objection(this);
    endtask

    virtual function new (string name = "base_test", uvm_component parent = null);
        super.new(name,parent);
        `uvm_info("TEST", "base_test constructor called", UVM_LOW)
    endfunction : new
endclass