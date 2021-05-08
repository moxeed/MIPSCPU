module Controller( regSrc, regDst, pcSrc, ALUSrc, ALUOp, regWrite, memWrite, zero, opCode, func);
input zero;
input[5:0] opCode,func;
output reg [1:0] regDst,regSrc,pcSrc,ALUOp;
output reg ALUSrc,regWrite,memWrite;

parameter [5:0]
RTYPE = 0,ADDI = 8,SLTI = 10,LW = 35,SW = 43,J = 2,JAL = 3,BEQ = 4,BNE = 5;

reg[3:0] decodedOpcode;
assign decodedOpcode = opCode == 0 ? 0 :
			opCode == 8 ? 8 :
 			opCode == 10 ? 10 :
 			opCode == 35 ? 35 :
 			opCode == 43 ? 43 :
 			opCode == 2 ? 2 :
 			opCode == 3 ? 3 :
			opCode == 4 ? 4 :
			opCode == 5 ? 5 :0;

parameter [5:0]
ADD = 32,SUB = 34,SLT = 42 , JR =  8;
reg[1:0] decodedFunction ;
assign decodedFunction = func == 32 ? 32 :
			func == 34 ? 34 :
			func == 42 ? 42 :
			func == 8 ? 8 :32;

reg[2:0] ALUcontrol;
reg [1:0] branchOC;
always@(decodedOpcode)begin
	{regDst,regSrc,pcSrc,ALUcontrol,ALUSrc,regWrite,memWrite,branchOC} = 0;
	case(decodedOpcode)
		RTYPE:begin regSrc=2; regWrite=1; regDst=1;   ALUcontrol=3; end
		ADDI: begin regSrc=2; regWrite=1; ALUSrc=1;   regDst=0; ALUcontrol=0;  end
		SLTI: begin regSrc=2; regWrite=1; ALUSrc=1;   regDst=1; ALUcontrol=2;  end
		LW:   begin regSrc=1; regWrite=1; ALUSrc=1;   regDst=0; ALUcontrol=0;  end
		SW:   begin regSrc=0; memWrite=1; regWrite=0; ALUSrc=1; ALUcontrol=0;  end
		J:    begin regSrc=0; regWrite=0; pcSrc=2;  branchOC=2; end
		JAL:  begin regSrc=0; regWrite=1; regDst=2; branchOC=2; end
		BEQ:  begin regSrc=0; regWrite=0; ALUSrc=0; branchOC=1; regWrite=0; ALUcontrol=1;end
		BNE:  begin regSrc=0; regWrite=0; ALUSrc=0; branchOC=3; regWrite=0; ALUcontrol=1;end
		endcase
end
reg branchF;
always@(decodedFunction)begin
	ALUOp = 0;branchF=0;
	if(ALUcontrol == 3)begin
		case(decodedFunction)
			ADD:ALUOp = 0;
			SUB:ALUOp = 1;
			SLT:ALUOp = 2;
			JR: branchF = 1;
		endcase
	end
	else
		ALUOp = ALUcontrol;
end
always@(zero)begin
	pcSrc = 0;
	if(branchF == 1) pcSrc = 3;
	else if(branchOC == 1) pcSrc = {0,zero};
	else if(branchOC == 2) pcSrc = 2;
	else if(branchOC == 3) pcSrc = {0,~zero};
end

endmodule