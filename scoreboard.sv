`timescale 1ns / 1ns

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    uvm_tlm_analysis_fifo #(sequence_item) item_fifo;
    int checks_en;
    
    bit err;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_fifo = new("item_fifo", this);
        uvm_config_db #(int)::get(this, "", "checks_en", checks_en);
    endfunction
    
    task run_phase(uvm_phase phase);
        sequence_item item;
        forever begin
            item_fifo.get(item);
            err = 1'b0;
            if (checks_en) begin
                if (item.tx_rcvd != item.tx_data) begin
                    `uvm_error("SCOREBOARD", $sformatf("TX mismatch: Exp %h, Got %h", 
                               item.tx_data, item.tx_rcvd));
                    err = 1'b1;
                end
                if (item.rx_rcvd != item.rx_data) begin
                    `uvm_error("SCOREBOARD", $sformatf("RX mismatch: Exp %h, Got %h", 
                               item.rx_data, item.rx_rcvd));
                    err = 1'b1;
                end
                if (item.parity != item.calc_parity) begin
                    `uvm_error("SCOREBOARD", "Parity error");
                    err = 1'b1;
                end
            end
            if (!err) begin
                `uvm_info("SCOREBOARD", $sformatf("Correct: TX: %h -> %h ; RX: %h -> %h", 
                        item.tx_data, item.tx_rcvd, item.rx_data, item.rx_rcvd), UVM_MEDIUM)
            end
        end
    endtask
endclass