`timescale 1ns/1ns

module ALU (lop, rop, op, result);
    input [2:0] op;
    input [31:0] lop, rop;
    output [31:0] result;

    parameter Add = 3'b000, Sub = 3'b001, And = 3'b010, Or = 3'b011, Slt = 3'b100;

    assign result = op == Add ? lop + rop :
                    op == Sub ? lop - rop :
                    op == Or  ? lop | rop :
                    op == And ? lop & rop :
                    op == Slt ? lop < rop ? 32'b1 : 32'b0 
                    :32'b0;
endmodule