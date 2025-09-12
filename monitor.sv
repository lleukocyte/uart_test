`timescale 1ns / 1ns

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    uvm_analysis_port #(sequence_item) item_ap;
    virtual uart_if uartif;
    virtual axi_if axi;
    sequence_item s_item;
    
    bit checks_en = 1;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port", this);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uartif", uartif))
        `uvm_fatal("MONITOR", "Failed to get uart interface")
        
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
   endfunction
    
    virtual task run_phase();
        forever begin
            @(posedge xmi.sig_clock);
            // Collect the data from the bus into trans_collected.
            if (checks_en)
                perform_checks();
            item_ap.write(s_item);
        end
    endtask : run_phase
    
    function void perform_checks();
        // Perform data checks on trans_collected.
    endfunction : perform_checks
    
endclass