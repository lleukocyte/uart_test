`timescale 1ns / 1ns

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    env env_h;
    sequencer sequencer_h;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = env::type_id::create("env_h",this);
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        sequencer_h = env_h.sequencer_h;
    endfunction : end_of_elaboration_phase

    virtual function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
endclass