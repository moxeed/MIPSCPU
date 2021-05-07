`timescale 1ns/1ns

module RegisterFile (clk, raddr1, raddr2, waddr, write, writeData, readData1, readData2);
    input clk, write;
    input [4:0] raddr1, raddr2, waddr;
    input [31:0] writeData, readData1, readData2;

    reg [31:0] file [31:0];
    assign readData1 = file[raddr1 >> 2];
    assign readData2 = file[raddr2 >> 2];

    always @(posedge clk) begin
        if(write)
            file[waddr >> 2] <= writeData;
    end
endmodule