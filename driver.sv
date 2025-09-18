`timescale 1ns / 1ns

class driver extends uvm_driver #(sequence_item);
   `uvm_component_utils(driver)

   sequence_item s_item;
   virtual uart_if uart;
   virtual axi_if axi;
 
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(!uvm_config_db #(virtual uart_if)::get(null, "*", "uart", uart))
        `uvm_fatal("DRIVER", "Failed to get uart interface")
        
      if(!uvm_config_db #(virtual axi_if)::get(null, "*", "axi", axi))
        `uvm_fatal("DRIVER", "Failed to get axi interface")
   endfunction

   task run_phase(uvm_phase phase);
      forever begin
         seq_item_port.try_next_item(s_item);
         if (s_item == null) begin
            // idle trans
         end
         else begin
            drive_item(s_item);
            seq_item_port.item_done();
         end
      end
   endtask
   
   task drive_item (input sequence_item item); // каждый seq в оба направления
      axi.set_format(item.wlen, item.nstop_bits, parity, is_even, divisor);
      axi
   endtask : drive_item
   
endclass