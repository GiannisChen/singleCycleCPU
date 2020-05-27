module rf (
	input 	[31:0] 	busW,
	input 	[4:0] 	Rw,
	input 	[4:0] 	Ra,
	input 	[4:0] 	Rb,
	input 			clk,
	input			regWr,
	input 	[31:0] 	ins,
	input 	[31:0] 	curPC,
	output 	[31:0] 	busA,
	output	[31:0] 	busB
);

	reg		[31:0] 	register[0:31];

	initial begin
		register[0] 	= 0;// $zero;

	end

	assign busA = (Ra != 0)? register[Ra]: 0;
	assign busB = (Rb != 0)? register[Rb]: 0;

	always @ ( posedge clk ) begin
		if ((regWr == 1) && (Rw != 0)) begin
			if(ins[31:26]==6'b000000 && ins[5:0]==6'b001001)
				register[31] <= curPC + 32'h0000_0004;
			else if(ins[31:26]==6'b000011) 
				register[31] <= curPC + 32'h0000_0004;
			else
				register[Rw] <= busW;
		end
	end
endmodule // Register File

