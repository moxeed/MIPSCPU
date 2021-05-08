`timescale 1ns/1ns

module DataPath (clk, regSrc, regDst, pcSrc, ALUSrc, ALUOp, regWrite, memWrite, zero, opCode, func);
    input clk;

    //pc
    wire [31:0] pcCurrAddr;
    wire [31:0] pcNextAddr;
    programCounter pc(clk, pcNextAddr, pcCurrAddr);

    //

    //Inst Mem
    wire [31:0] instruction;
    output [5:0] opCode, func;
    assign opCode = instruction[31:26];
    assign func = instruction[5:0];
    MemoryBlock instMem(clk, pcCurrAddr,1'b0,,instruction);
    //
    
    //Sign Extend
    wire [31:0] immediate;
    SignExtend signExtend(instruction[15:0], immediate);
    //

    //Register File
    input regWrite;
    input [1:0] regDst;

    wire [4:0] waddr;
    wire [31:0] regWriteData, regReadData1, regReadData2;
    wire [4:0] regDstData[3:0];
    assign regDstData[0] = instruction[20:16];
    assign regDstData[0] = instruction[16:11];
    assign regDstData[0] = 5'b11111;
    Mux #(5, 4) regWriteDstMux(regDstData, regDst, waddr);
    RegisterFile registerFile(clk, instruction[25:21], instruction[20:16], waddr, regWrite, regWriteData, regReadData1, regReadData2);
    //

    //Next pc Path
    input [1:0] pcSrc;

    wire [31:0] pcSrcData[3:0];
    assign pcSrcData[0] = pcCurrAddr + 4;
    assign pcSrcData[1] = {immediate[29:0], 2'b00};
    assign pcSrcData[2] = {pcCurrAddr[31:28], instruction[25:0], 2'b00};
    assign pcSrcData[3] = regReadData1;
    Mux #(32, 4) pcSrcMux(pcSrcData, pcSrc, pcNextAddr);
    //
    
    //ALU
    input ALUSrc;
    input [1:0] ALUOp;
    output zero;

    wire [31:0] rightOp, ALUResult;
    wire [31:0] ALUSrcData[1:0];
    assign ALUSrcData[0] = regReadData2;
    assign ALUSrcData[1] = immediate;
    Mux #(32, 2) ALUSrcMux(ALUSrcData, ALUSrc, rightOp);
    ALU alu(regReadData1, rightOp, ALUOp, ALUResult, zero);
    //

    //Memory
    input memWrite;

    wire [31:0] memReadData;
    MemoryBlock RAM(clk, ALUResult, memWrite, regReadData2, memReadData);
    //

    //Memory Path
    input [1:0] regSrc;

    wire [31:0] regSrcData[3:0];
    assign regSrcData[0] = pcCurrAddr;
    assign regSrcData[0] = memReadData;
    assign regSrcData[0] = ALUResult;
    Mux #(32, 4) regWriteSrcMux(regSrcData, regSrc, regWriteData);
    //

endmodule