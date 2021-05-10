module programCounter(clk, nextAddr, currAddr);
input [31:0] nextAddr;
input clk;
output reg [31:0] currAddr = 0;
	always@(posedge clk)begin
		currAddr <= nextAddr;
	end
endmodule