`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2025 17:35:56
// Design Name: 
// Module Name: bfm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

interface bfm;
   byte         unsigned        A;
   byte         unsigned        B;
   bit          clk;
   bit          reset_n;
   wire [2:0]   op;
   bit          start;
   wire         done;
   wire [15:0]  result;
   operation_t  op_set;

   initial begin
      clk = 0;
      forever begin
         #10;
         clk = ~clk;
      end
   end
endinterface : bfm