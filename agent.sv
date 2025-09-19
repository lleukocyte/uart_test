`timescale 1ns / 1ns

class agent extends uvm_agent;
    `uvm_component_utils(agent)
    sequencer #(sequence_item) sequencer_h;
    driver driver_h;
    monitor monitor_h;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase)
        monitor = simple_monitor::type_id::create("monitor",this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = uvm_sequencer#(simple_item)::type_id::create("sequencer_h", this);
            driver = simple_driver::type_id::create("driver_h", this);
        end
    endfunction : build_phase
    
    virtual function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer_h.seq_item_export);
    end
    endfunction : connect_phase
endclass