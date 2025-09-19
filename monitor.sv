`timescale 1ns / 1ns

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    uvm_analysis_port #(sequence_item) item_ap;
    virtual uart_if uartif;
    virtual axi_if axi;
    bit parity;
    bit calc_parity = 1'b0;
    sequence_item s_item;
    event rx_done, tx_done;
    bit rxd, txd;
    
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
        fork
            forever begin
                @(negedge uartif.tx);
                #(BAUDTIME/2);
                calc_parity = 1'b0;
                for (int i=0; i < 8; i++) begin
                    #BAUDTIME;
                    calc_parity = calc_parity ^ uartif.tx;
                    s_item.tx_data[i] = uartif.tx;
                end
                #BAUDTIME;
                parity = uartif.tx;
                if (checks_en)
                    check_tx();
                ->tx_done;
            end
            
            forever begin
                @(negedge uartif.tx);
                for (int i=0; i < 8; i++) begin
                    s_item.data[i] = uartif.tx;
                end
                if (checks_en)
                    check_rx();
                ->rx_done;
            end
            
            forever begin
                @(posedge tx_done);
                txd = 1'b1;
            end

            forever begin
                @(posedge rx_done);
                rxd = 1'b1;
            end
            
            forever begin
                wait(rxd && txd);
                item_ap.write(s_item);
                rxd = 1'b0;
                txd = 1'b0;
            end
        join_none
    endtask : run_phase
    
    function void check_tx();
        // Perform data checks on trans_collected.
    endfunction : check_tx
    
    function void check_rx();
        // Perform data checks on trans_collected.
    endfunction : check_rx
    
endclass