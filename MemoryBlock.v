`timescale 1ns/1ns

module MemoryBlock (clk, addr, write, writeData, readData);
    input clk, write;
    input [31:0] addr;
    input [31:0] writeData, readData;

    reg [31:0] file [65535:0];
    assign readData = file[addr >> 2];

    always @(posedge clk) begin
        if(write)
            file[addr >> 2] <= writeData;
    end
endmodule