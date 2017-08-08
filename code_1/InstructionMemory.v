
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address[9:2])
			// addi $a0, $zero, 12345 #(0x3039)
			8'd0:    Instruction <= {6'h08, 5'd0 , 5'd4 , 16'h3039};
			// addiu $a1, $zero, -11215 #(0xd431)
			8'd1:    Instruction <= {6'h09, 5'd0 , 5'd5 , 16'hd431};
			// sll $a2, $a1, 16
			8'd2:    Instruction <= {6'h00, 5'd0 , 5'd5 , 5'd6 , 5'd16 , 6'h00};
			// sra $a3, $a2, 16
			8'd3:    Instruction <= {6'h00, 5'd0 , 5'd6 , 5'd7 , 5'd16 , 6'h03};
			// beq $a3, $a1, L1
			8'd4:    Instruction <= {6'h04, 5'd7 , 5'd5 , 16'h0001};
			// lui $a0, -11111 #(0xd499)
			8'd5:    Instruction <= {6'h0f, 5'd0 , 5'd4 , 16'hd499};
			// L1:
			// add $t0, $a2, $a0
			8'd6:    Instruction <= {6'h00, 5'd6 , 5'd4 , 5'd8 , 5'd0 , 6'h20};
			// sra $t1, $t0, 8
			8'd7:    Instruction <= {6'h00, 5'd0 , 5'd8 , 5'd9 , 5'd8 , 6'h03};
			// addi $t2, $zero, -12345 #(0xcfc7)
			8'd8:    Instruction <= {6'h08, 5'd0 , 5'd10, 16'hcfc7};
			// slt $v0, $a0, $t2
			8'd9:    Instruction <= {6'h00, 5'd4 , 5'd10 , 5'd2 , 5'd0 , 6'h2a};
			// sltu $v1, $a0, $t2
			8'd10:   Instruction <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'h2b};
			// Loop:
			// j Loop
			8'd11:   Instruction <= {6'h02, 26'd11};
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
