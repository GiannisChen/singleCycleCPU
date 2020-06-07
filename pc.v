module pc (
	input 				clk,
	input 				rst,
	input 		[31: 0] next_ins_addr,
	
	output reg 	[31: 0] ins_addr
);

	always @ ( posedge clk ) begin
		if (rst)
			ins_addr <= 32'h0000_3000;
		else
			ins_addr <= next_ins_addr;
	end
endmodule // Program Counter

