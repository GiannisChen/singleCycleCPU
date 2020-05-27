module npc (iaddr, branch, jump, zero, imm16, imm26, niaddr, op, busA, ins);
	input 	branch, jump, zero;
	input [31:0]	iaddr;		// Now instruction address
	input [15:0] 	imm16;
	input [25:0]	imm26;
	input [5:0]		op;
	input [31:0]	busA;
	input [31:0]		ins;

	output reg [31:0] niaddr;	// Next instruction address

	wire [31:0] pc4;
	assign pc4 = iaddr + 3'b100;

	wire [15:0] offset = ins[15:0];

	always @(*) begin
		if(branch) begin
			case (op)
				//BEQ
				6'b000100 : niaddr = zero ? ({{14{offset[15]}}, offset[15:0], 2'b00} + iaddr) : pc4;
				//BNE
				6'b000101 : niaddr = (zero == 0) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + iaddr) : pc4;
				//BGTZ
				6'b000111 : niaddr = ((busA[31] == 0) && (busA[31:0] != 32'h0000_0000)) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + iaddr) : pc4;
				//BLEZ
				6'b000110 : niaddr = ((busA[31] == 1) || (busA[31:0] == 32'h0000_0000)) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + iaddr) : pc4;
				//BLTZ & BGEZ
				6'b000001 : begin
					if (ins[20:16] == 5'b00000)	begin//BLTZ
						
						niaddr = (busA[31] == 1) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + iaddr) : pc4;
						$display("BLTZ:%h",busA,"  niaddr:%h",niaddr);
					end
					else begin
						niaddr = (busA[31] == 0) ? ({{14{offset[15]}}, offset[15:0], 2'b00} + iaddr) : pc4;
						$display("BGEZ:%h",busA,"  niaddr:%h",niaddr);
					end
				end
				default: niaddr = pc4;
			endcase
		end
		else if(jump)
			niaddr = 32'h0000_3000 + {iaddr[31:28], imm26[25:0], 2'b00};
		//jr & jarl
		else if(op == 6'b000000 && ((ins[5:0] == 6'b001000) || (ins[5:0] == 6'b001001)))
			niaddr = 32'h0000_3000 + busA;
		else
			niaddr = pc4;
	end

	// always @ ( * ) begin
	// 	if (zero && branch) begin	// Branch
	// 		niaddr = {{14{imm16[15]}}, imm16[15:0], 2'b00} + pc4;
	// 	end else if (jump) begin	// Jump
	// 		niaddr = {iaddr[31:28], imm26[25:0], 2'b00};
	// 	end else begin
	// 		niaddr = pc4;
	// 	end
	// end

endmodule // Next Program Counter

