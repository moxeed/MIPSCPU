`timescale 1ns/1ns

module Mux (data, select, expose);

parameter dsize = 32;
parameter dcount = 2;

input [dsize-1:0] data[dcount-1:0];
input [dcount <= 2  ? 1 :
       dcount <= 4  ? 2 :
       dcount <= 8  ? 3 :
       dcount <= 16 ? 4 :
       5: 0] select;

output [dsize-1:0]expose;

assign expose = data[select];
    
endmodule