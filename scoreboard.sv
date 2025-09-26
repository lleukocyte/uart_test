`timescale 1ns / 1ns

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    uvm_tlm_analysis_fifo #(sequence_item) tx_fifo;
    uvm_tlm_analysis_fifo #(sequence_item) rx_fifo;
    int checks_en;
    sequence_item rx_item;
    sequence_item tx_item;
    
    int tx_counter = 0;
    int rx_counter = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rx_fifo = new("rx_fifo", this);
        tx_fifo = new("tx_fifo", this);
        uvm_config_db #(int)::get(this, "", "checks_en", checks_en);
        rx_item = sequence_item::type_id::create("rx_item");
        tx_item = sequence_item::type_id::create("tx_item");
    endfunction
    
    task run_phase(uvm_phase phase);
        fork
            forever begin
                tx_fifo.get(tx_item);
                tx_counter++;
                if (checks_en) begin
                    if (tx_item.tx_rcvd != tx_item.tx_data) begin
                        `uvm_error("SCOREBOARD", $sformatf("! TX mismatch: Exp %h, Got %h !", 
                                tx_item.tx_data, tx_item.tx_rcvd))
                    end
                    if (tx_item.parity != tx_item.calc_parity) begin
                        `uvm_error("SCOREBOARD", "! Parity error !")
                    end
                end
                `uvm_info("SCOREBOARD", $sformatf("TX transaction %d:   %h -> %h", 
                    tx_counter, tx_item.tx_data, tx_item.tx_rcvd), UVM_MEDIUM)
            end
            
            forever begin
                rx_fifo.get(rx_item);
                rx_counter++;
                if (checks_en) begin
                    if (rx_item.rx_rcvd != rx_item.rx_data) begin
                        `uvm_error("SCOREBOARD", $sformatf("! RX mismatch: Exp %h, Got %h !", 
                                rx_item.rx_data, rx_item.rx_rcvd));
                    end
                end
                `uvm_info("SCOREBOARD", $sformatf("RX transaction %d:   %h -> %h", 
                    rx_counter, rx_item.rx_data, rx_item.rx_rcvd), UVM_MEDIUM)
            end
        join
    endtask
endclass