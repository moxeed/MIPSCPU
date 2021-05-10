`timescale 1ns/1ns

module MIPSCPUTB ();

    reg clk = 1'b0;
    MIPSCPU UUT(clk);

    always #4 clk = ~clk;

    initial begin
        $readmemb("./instMem.mem", UUT.dataPath.instMem.file);
        $readmemb("./MemoryBlock.mem", UUT.dataPath.RAM.file, 250);
    end
endmodule