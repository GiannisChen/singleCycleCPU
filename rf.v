module rf (
	input 	[31:0] 	busW,
	input 	[4:0] 	Rw,
	input 	[4:0] 	Ra,
	input 	[4:0] 	Rb,
	input 			clk,
	input			regWr,
	input 			regL,
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
		if ((regWr == 1)) begin
			if(regL == 1) 
				register[31] <= curPC + 32'h0000_0004;
			else if(Rw != 0)
				register[Rw] <= busW;
		end
	end
endmodule // Register File

