module regFile (busW, clk, wE, rW, rA, rB, busA, busB, ins, curPC);
	input 	[31:0] 	busW;
	input 	[4:0] 	rW, rA, rB;
	input 			clk, wE;
	input [31:0] ins;
	input [31:0] curPC;
	output 	[31:0] 	busA, busB;

	reg		[31:0] 	register[0:31];

	initial begin
		register[0] 	= 0;// $zero;

	end

	assign busA = (rA != 0)? register[rA]: 0;
	assign busB = (rB != 0)? register[rB]: 0;

	always @ ( posedge clk ) begin
		if ((wE == 1) && (rW != 0)) begin
			if(ins[31:26]==6'b000000 && ins[5:0]==6'b001001)
				register[31] <= curPC + 32'h0000_0004;
			else if(ins[31:26]==6'b000011) 
				register[31] <= curPC + 32'h0000_0004;
			else
				register[rW] <= busW;
		end
	end
endmodule // Register File

