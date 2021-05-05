`timescale 1ns/1ns

module ShiftLeft (data, expose);

parameter dsize = 32;
parameter shcount = 2;

input [dsize-1:0] data;
output [dsize-1:0] expose;

assign expose = data << shcount;

endmodule