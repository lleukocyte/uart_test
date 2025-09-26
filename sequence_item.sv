`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

class sequence_item extends uvm_sequence_item;
    `uvm_object_utils(sequence_item)
    rand logic [7:0] rx_data;
    rand logic [7:0] tx_data;
    logic [7:0] rx_rcvd;
    logic [7:0] tx_rcvd;
    logic parity;
    logic calc_parity;
    
    function new(string name = "my_object");
        super.new(name);
    endfunction
endclass : sequence_item