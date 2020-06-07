
module mips (clk, rst);
	input clk;
	input rst;

	wire 	[31:0] 	pc_next;
	wire 	[31:0] 	pc_cur;
	wire 	[31:0] 	ins;
	wire 	[31:0]	ext_imm;
	wire 	[31:0]	routa;
	wire 	[31:0]	routb;
	wire 	[31:0]	rin;
	wire 	[31:0]	aluSrc_mux_out;
	wire 	[31:0]	alu_out;
	wire 	[31:0]	dm_out;
	wire 	[4:0]	rWin;
	wire 	[4:0]	aluCtr;
	wire 	[1:0]	branch;
	wire 			jump;
	wire 			regDst;
	wire 			aluSrc;
	wire			regL;
	wire 			regWr;
	wire 			memWr;
	wire 			extOp;
	wire 			memtoReg;
	wire 			zero;

	pc pc(
		.clk(clk),
		.rst(rst),
		.next_ins_addr(pc_next),
		.ins_addr(pc_cur)
	);

	npc npc(
		.ins_addr(pc_cur),
		.branch(branch),
		.jump(jump),
		.zero(zero),
		.imm16(ins[15:0]),
		.imm26(ins[25:0]),
		.next_ins_addr(pc_next),
		.op(ins[31:26]),
		.busA(routa)
	);

	im_4k im(
		.ins_addr(pc_cur[11:2]),
		.ins(ins)
	);

	ext extOp_ext(
		.imm16(ins[15:0]),
		.extOp(extOp),
		.dout(ext_imm)
	);


	mux #(32) aluSrc_mux(
		.a(routb),
		.b(ext_imm),
		.ctrl(aluSrc),
		.dout(aluSrc_mux_out)
	);

	mux #(5) regDst_mux(
		.a(ins[20:16]),
		.b(ins[15:11]),
		.ctrl(regDst),
		.dout(rWin)
	);

	rf dut_rf(
		.busW(rin),
		.clk(clk),
		.regWr(regWr),
		.Rw(rWin),
		.Ra(ins[25:21]),
		.Rb(ins[20:16]),
		.busA(routa),
		.busB(routb),
		.regL(regL),
		.curPC(pc_cur)
	);

	alu alu(
		.aluOp(aluCtr),
		.busA(routa),
		.busB(aluSrc_mux_out),
		.result(alu_out),
		.zero(zero),
		.shf(ins[10:6])
	);

	dm_4k dm(
		.addr(alu_out[11:0]),
		.din(routb),
		.memWr(memWr),
		.clk(clk),
		.dout(dm_out),
		.op(ins[31:26])
	);

	mux memtoReg_mux(
		.a(alu_out),
		.b(dm_out),
		.ctrl(memtoReg),
		.dout(rin)
	);

	ctrl ctrl(
		.ins(ins),
		.branch(branch),
		.jump(jump),
		.regDst(regDst),
		.aluSrc(aluSrc),
		.aluOp(aluCtr),
		.regL(regL),
		.regWr(regWr),
		.memWr(memWr),
		.extOp(extOp),
		.memToReg(memtoReg)
	);

	always @ (pc_cur or pc_next) begin
		$display("currentPC:%h\n",pc_cur,"nextPC:%h\n",pc_next);
		if(ins==32'h0721_0010) begin
			$display("routa:%h",routa,"  branch:%b",branch,"  ins:%b",ins[31:26]);
		end
	end

endmodule

