`timescale 1ns/1ns

module MIPSCPU (clk);

    input clk;
    
    wire ALUSrc,regWrite,memWrite,zero;
    wire [1:0] regDst,regSrc,pcSrc,ALUOp;
    wire[5:0] opCode,func;
    
    DataPath dataPath(clk, regSrc, regDst, pcSrc, ALUSrc, ALUOp, regWrite, memWrite, zero, opCode, func);
    Controller controller( regSrc, regDst, pcSrc, ALUSrc, ALUOp, regWrite, memWrite, zero, opCode, func);
endmodule