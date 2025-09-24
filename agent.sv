`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class agent extends uvm_agent;
    `uvm_component_utils(agent)
    sequencer sequencer_h;
    driver driver_h;
    monitor monitor_h;
    
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_h = monitor::type_id::create("monitor_h",this);
        if (is_active == UVM_ACTIVE) begin
            sequencer_h = sequencer::type_id::create("sequencer_h", this);
            driver_h = driver::type_id::create("driver_h", this);
        end
    endfunction : build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //monitor_h.item_ap.connect(scoreboard_h.data_f.analysis_export);
        if (is_active == UVM_ACTIVE) begin
            driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
    end
    endfunction : connect_phase
endclass