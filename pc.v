module pc (clk, rst, niaddr, iaddr);
	input 			clk;
	input 			rst;
	input 	[31:0]	niaddr;		// Next instruction address
	output reg	[31:0]	iaddr;	// Instruction address

	always @ ( posedge clk ) begin
		if (rst)
			iaddr <= 32'h0000_3000;
		else
			iaddr <= niaddr;
	end
endmodule // Program Counter

