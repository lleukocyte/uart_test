`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class sequence_item extends uvm_sequence_item;
    `uvm_object_utils(sequence_item)
    rand bit [7:0] rx_data;
    rand bit [7:0] tx_data;
    
    function new(string name);
        super.new(name);
    endfunction
endclass : sequence_item