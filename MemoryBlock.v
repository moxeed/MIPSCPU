`timescale 1ns/1ns

module MemoryBlock (clk, raddr, waddr, write, writeData, readData);
    input clk, write;
    input [4:0] raddr, waddr;
    input [31:0] writeData, readData;

    reg [31:0] file [65535:0];
    assign readData = file[raddr];

    always @(posedge clk) begin
        if(write)
            file[waddr] <= writeData;
    end
endmodule