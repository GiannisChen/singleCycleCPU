module mux #(parameter WIDTH = 32) (
	input 	[WIDTH - 1:0] 	a,
	input 	[WIDTH - 1:0] 	b,
	input 					ctrl,

	output 	[WIDTH - 1:0]	dout
);

	assign dout = ctrl? b: a;

endmodule // Multiplexer

