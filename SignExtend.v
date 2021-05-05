`timescale 1ns/1ns

module SignExtend (data, expose);

parameter outsize = 32;
parameter insize = 16;

input [insize-1:0] data;
output [outsize-1:0] expose;

assign expose = {{(outsize-insize){data[insize - 1]}}, data};

endmodule