`timescale 1ns/1ns

module ALU (lop, rop, op, result, zero);
    input [1:0] op;
    input [31:0] lop, rop;
    output zero;
    output [31:0] result;

    parameter Add = 2'b00, Sub = 2'b01, Slt = 2'b10;

    assign result = op == Add ? lop + rop :
                    op == Sub ? lop - rop :
                    op == Slt ? lop < rop ? 32'b1 : 32'b0 
                    :32'b0;

    assign zero = result == 32'b0;
endmodule