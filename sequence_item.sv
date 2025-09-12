`timescale 1ns / 1ns

class sequence_item extends uvm_sequence_item;
    `uvm_object_utils(sequence_item)
    rand bit [7:0] data;
    rand int wlen;
    rand bit nstop_bits;
    rand bit parity;
    rand bit is_even;
    rand int divisor;
    
    constraint wlen_c { wlen inside {[5:8]}; };
    
    constraint divisor_c { baud_rate inside {[1:65535]}; };
    
    function new(string name);
        super.new(name);
    endfunction
endclass : sequence_item