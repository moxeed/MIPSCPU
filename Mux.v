`timescale 1ns/1ns

module Mux (data, select, expose);

parameter dsize = 32;
parameter dcount = 2;

input [dsize-1:0] data[dcount-1:0];
input [dcount <= 2  ? 0 :
       dcount <= 4  ? 1 :
       dcount <= 8  ? 2 :
       dcount <= 16 ? 3 :
       4: 0] select;

output [dsize-1:0]expose;

assign expose = data[select];
    
endmodule