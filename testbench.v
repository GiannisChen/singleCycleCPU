
module testbench ();
	reg clk, rst;

	initial begin
		clk = 0;
		rst = 1;
		#100 rst = 0;
	end

	always #50 clk = ~clk;

	mips mips(
		.clk(clk),
		.rst(rst)
	);

endmodule // Test Bench;

