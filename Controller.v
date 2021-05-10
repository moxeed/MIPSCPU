`timescale 1ns/1ns

module Controller( regSrc, regDst, pcSrc, ALUSrc, ALUOp, regWrite, memWrite, zero, opCode, func);
input zero;
input[5:0] opCode,func;
output reg [1:0] regDst,regSrc,pcSrc,ALUOp;
output reg ALUSrc,regWrite,memWrite;

parameter [5:0]
	RTYPE = 0,ADDI = 8,SLTI = 10,LW = 35,SW = 43,J = 2,JAL = 3,BEQ = 4,BNE = 5;

parameter [5:0]
	ADD = 32,SUB = 34,SLT = 42 , JR =  8;

reg[2:0] ALUcontrol;
reg [1:0] branchOC;
always@(opCode)begin
	{regDst,regSrc,pcSrc,ALUcontrol,ALUSrc,regWrite,memWrite,branchOC} = 0;
	case(opCode)
		RTYPE:begin regSrc=2; regWrite= func==8 ? 0 : 1; memWrite=0; ALUSrc=0; regDst=1; ALUcontrol=3;  branchOC=0;end
		ADDI: begin regSrc=2; regWrite=1; memWrite=0;		     ALUSrc=1; regDst=0; ALUcontrol=0;  branchOC=0; end
		SLTI: begin regSrc=2; regWrite=1; memWrite=0; 		     ALUSrc=1; regDst=1; ALUcontrol=2;  branchOC=0; end
		LW:   begin regSrc=1; regWrite=1; memWrite=0; 		     ALUSrc=1; regDst=0; ALUcontrol=0;  branchOC=0; end
		SW:   begin regSrc=0; regWrite=0; memWrite=1; 		     ALUSrc=1; regDst=0; ALUcontrol=0;  branchOC=0; end
		J:    begin regSrc=0; regWrite=0; memWrite=0;     	     ALUSrc=0; regDst=0; ALUcontrol=0;  branchOC=2;  end
		JAL:  begin regSrc=0; regWrite=1; memWrite=0; 		     ALUSrc=0; regDst=2; ALUcontrol=0;  branchOC=2;  end
		BEQ:  begin regSrc=0; regWrite=0; memWrite=0; 		     ALUSrc=0; regDst=0; ALUcontrol=1;  branchOC=1;  end
		BNE:  begin regSrc=0; regWrite=0; memWrite=0; 		     ALUSrc=0; regDst=0; ALUcontrol=1;  branchOC=3;  end
		endcase
end

reg branchF;
always@(func, ALUcontrol)begin
	ALUOp = 0;branchF=0;
	if(ALUcontrol == 3)begin
		case(func)
			ADD:ALUOp = 0;
			SUB:ALUOp = 1;
			SLT:ALUOp = 2;
			JR: branchF = 1;
		endcase
	end
	else
		ALUOp = ALUcontrol;
end
always@(zero, branchOC)begin
	pcSrc = 0;
	if(branchF == 1) pcSrc = 3;
	else if(branchOC == 1) pcSrc = {1'b0,zero};
	else if(branchOC == 2) pcSrc = 2;
	else if(branchOC == 3) pcSrc = {1'b0,~zero};
end

endmodule
