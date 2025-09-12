`timescale 1ns / 1ns

class simple_sequence extends uvm_sequence #(sequence_item);
    `uvm_object_utils(simple_sequence)
    rand int count;
    constraint c1 { count > 0; count < 50; }
    
    function new(string name="simple_sequence");
        super.new(name);
    endfunction
    virtual task body();
        repeat(count)
        `uvm_do(req)
    endtask : body
endclass : simple_sequence