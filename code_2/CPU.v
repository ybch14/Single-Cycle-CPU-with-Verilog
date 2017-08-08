
module CPU(reset, clk);
	input reset, clk;
	
	reg [31:0] PC;
	wire [31:0] PC_next;
	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00000000;
		else
			PC <= PC_next;
	
	wire [31:0] PC_plus_4;
	assign PC_plus_4 = PC + 32'd4;
	
	wire [31:0] Instruction;
	InstructionMemory instruction_memory1(.Address(PC), .Instruction(Instruction));
	
	wire [1:0] RegDst;
	wire [1:0] PCSrc;
	wire Branch;
	wire MemRead;
	wire [1:0] MemtoReg;
	wire [3:0] ALUOp;
	wire ExtOp;
	wire LuOp;
	wire MemWrite;
	wire ALUSrc1;
	wire ALUSrc2;
	wire RegWrite;
	
	Control control1(
		.OpCode(Instruction[31:26]), .Funct(Instruction[5:0]),
		.PCSrc(PCSrc), .Branch(Branch), .RegWrite(RegWrite), .RegDst(RegDst), 
		.MemRead(MemRead),	.MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp),	.ALUOp(ALUOp));
	
	wire [31:0] Databus1, Databus2, Databus3;
	wire [4:0] Write_register;
	assign Write_register = (RegDst == 2'b00)? Instruction[20:16]: (RegDst == 2'b01)? Instruction[15:11]: 5'b11111;
	RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(RegWrite), 
		.Read_register1(Instruction[25:21]), .Read_register2(Instruction[20:16]), .Write_register(Write_register),
		.Write_data(Databus3), .Read_data1(Databus1), .Read_data2(Databus2));
	
	wire [31:0] Ext_out;
	assign Ext_out = {ExtOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
	
	wire [31:0] LU_out;
	assign LU_out = LuOp? {Instruction[15:0], 16'h0000}: Ext_out;
	
	wire [4:0] ALUCtl;
	wire Sign;
	ALUControl alu_control1(.ALUOp(ALUOp), .Funct(Instruction[5:0]), .ALUCtl(ALUCtl), .Sign(Sign));
	
	wire [31:0] ALU_in1;
	wire [31:0] ALU_in2;
	wire [31:0] ALU_out;
	wire Zero;
	assign ALU_in1 = ALUSrc1? {17'h00000, Instruction[10:6]}: Databus1;
	assign ALU_in2 = ALUSrc2? LU_out: Databus2;
	ALU alu1(.in1(ALU_in1), .in2(ALU_in2), .ALUCtl(ALUCtl), .Sign(Sign), .out(ALU_out), .zero(Zero));
	
	wire [31:0] Read_data;
	DataMemory data_memory1(.reset(reset), .clk(clk), .Address(ALU_out), .Write_data(Databus2), .Read_data(Read_data), .MemRead(MemRead), .MemWrite(MemWrite));
	assign Databus3 = (MemtoReg == 2'b00)? ALU_out: (MemtoReg == 2'b01)? Read_data: PC_plus_4;
	
	wire [31:0] Jump_target;
	assign Jump_target = {PC_plus_4[31:28], Instruction[25:0], 2'b00};
	
	wire [31:0] Branch_target;
	assign Branch_target = (Branch & Zero)? PC_plus_4 + {LU_out[29:0], 2'b00}: PC_plus_4;
	
	assign PC_next = (PCSrc == 2'b00)? Branch_target: (PCSrc == 2'b01)? Jump_target: Databus1;

endmodule
	