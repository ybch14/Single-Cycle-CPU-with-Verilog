
module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address[9:2])
			// addi $a0, $zero, 3
			8'd0:    Instruction <= {6'h08, 5'd0 , 5'd4 , 16'h0003};
			// jal sum
			8'd1:    Instruction <= {6'h03, 26'd3};
			// Loop:
			// beq $zero, $zero, Loop
			8'd2:    Instruction <= {6'h04, 5'd0 , 5'd0 , 16'hffff};
			// sum:
			// addi $sp, $sp, -8
			8'd3:    Instruction <= {6'h08, 5'd29 , 5'd29 , 16'hfff8};
			// sw $ra, 4($sp)
			8'd4:    Instruction <= {6'h2b, 5'd29 , 5'd31 , 16'h0004};
			// sw $a0, 0($sp)
			8'd5:    Instruction <= {6'h2b, 5'd29 , 5'd4 , 16'h0000};
			// slti $t0, $a0, 1
			8'd6:    Instruction <= {6'h0a, 5'd4, 5'd8, 16'h0001};
			// beq $to, $zero, L1
			8'd7:    Instruction <= {6'h04, 5'd8, 5'd0, 16'h0003};
			// xor $v0, $zero, $zero
			8'd8:    Instruction <= {6'h00, 5'd0, 5'd0, 5'd2, 5'd0, 6'h26};
			// addi $sp, $sp, 8
			8'd9:    Instruction <= {6'h08, 5'd29, 5'd29, 16'h0008};
			// jr $ra
			8'd10:   Instruction <= {6'h00, 5'd31 , 5'd0 , 5'd0 , 5'd0 , 6'h08};
			// L1:
			// addi $a0, $a0, -1
			8'd11:   Instruction <= {6'h08, 5'd4, 5'd4, 16'hffff};
			// jal sum
			8'd12:   Instruction <= {6'h03, 26'd3};
			// lw $a0, 0($sp)
			8'd13:   Instruction <= {6'h23, 5'd29, 5'd4, 16'h0000};
			// lw $ra, 4($sp)
			8'd14:   Instruction <= {6'h23, 5'd29, 5'd31, 16'h0004};
			//addi $sp, $sp, 8
			8'd15:   Instruction <= {6'h08, 5'd29, 5'd29, 16'h0008};
			// add $v0, $a0, $v0
			8'd16:   Instruction <= {6'h00, 5'd2, 5'd4, 5'd2, 5'd0, 6'd20};
			// jr $ra
			8'd17:   Instruction <= {6'h00, 5'd31, 5'd0, 5'd0, 5'd0, 6'h08};
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
