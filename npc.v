module npc (
	input [31:0] ins_addr,
	input branch,
	input jump,
	input zero,
	input [15:0] imm16,
	input [25:0] imm26,
	input [5:0] op,
	input [31:0] busA,
	input [31:0] ins,
	
	output reg [31:0] next_ins_addr
);

	wire [31:0] pc_plus_4;
	assign pc_plus_4 = ins_addr + 3'b100;

	wire [15:0] offset = ins[15:0];

	always @(*) begin
		if(branch) begin
			case (op)
				//BEQ
				6'b000100 : next_ins_addr = zero ? ({{14{offset[15]}}, offset[15:0], 2'b00} + ins_addr) : pc_plus_4;
				//BNE
				6'b000101 : next_ins_addr = (zero == 0) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + ins_addr) : pc_plus_4;
				//BGTZ
				6'b000111 : next_ins_addr = ((busA[31] == 0) && (busA[31:0] != 32'h0000_0000)) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + ins_addr) : pc_plus_4;
				//BLEZ
				6'b000110 : next_ins_addr = ((busA[31] == 1) || (busA[31:0] == 32'h0000_0000)) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + ins_addr) : pc_plus_4;
				//BLTZ & BGEZ
				6'b000001 : begin
					if (ins[20:16] == 5'b00000)	begin//BLTZ
						
						next_ins_addr = (busA[31] == 1) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + ins_addr) : pc_plus_4;
						//$display("BLTZ:%h",busA,"  niaddr:%h",next_ins_addr);
					end
					else begin
						next_ins_addr = (busA[31] == 0) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + ins_addr) : pc_plus_4;
						//$display("BGEZ:%h",busA,"  niaddr:%h",next_ins_addr);
					end
				end
				default: next_ins_addr = pc_plus_4;
			endcase
		end
		else if(jump)
			next_ins_addr = 32'h0000_3000 + {ins_addr[31:28], imm26[25:0], 2'b00};
		//jr & jarl
		else if(op == 6'b000000 && ((ins[5:0] == 6'b001000) || (ins[5:0] == 6'b001001)))
			next_ins_addr = 32'h0000_3000 + busA;
		else
			next_ins_addr = pc_plus_4;
	end

	// always @ ( * ) begin
	// 	if (zero && branch) begin	// Branch
	// 		niaddr = {{14{imm16[15]}}, imm16[15:0], 2'b00} + pc_plus_4;
	// 	end else if (jump) begin	// Jump
	// 		niaddr = {ins_addr[31:28], imm26[25:0], 2'b00};
	// 	end else begin
	// 		niaddr = pc_plus_4;
	// 	end
	// end

endmodule // Next Program Counter

