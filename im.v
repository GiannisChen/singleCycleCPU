module im_4k (
	input 	[11:2] ins_addr,
	output 	[31:0] ins
);

	reg	[31:0]	im[1023:0];// 32bit * 1024

	initial begin
		$readmemh("code.txt", im);
	end

	assign ins = im[ins_addr[11:2]][31:0];

endmodule // 4k Instruction Memeory

