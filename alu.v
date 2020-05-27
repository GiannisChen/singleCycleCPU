module alu (ALUop, busA, busB, result, zero, shf);
	input 	[4:0] 		ALUop;
	input 	[31:0] 		busA, busB;
	input 	[10:6]		shf;
	output 				zero;
	output reg 	[31:0] 	result;

	assign zero = (result == 0)? 1: 0;
	wire [31:0] high = {1'b1,{31{1'b0}}};
    wire SLTUA = busA ^ high;
    wire SLTUB = busB ^ high;

	always @ ( ALUop or busA or busB ) begin
		case (ALUop)
			5'b00000: result = busA + busB;
            5'b00001: result = busA - busB;
            5'b00010: result = (busA < busB) ? 1 : 0;
            5'b00011: result = busA & busB;
            5'b00100: result = ~(busA | busB);
            5'b00101: result = busA | busB;
            5'b00110: result = busA ^ busB;
            5'b00111: result = busB << shf;
            5'b01000: result = busB >> shf;
            5'b01001: result = (SLTUA < SLTUB) ? 1 : 0;
            //5'b01010: ;jar & jalr
            //5'b01011: ;jr
            5'b01100: result = busB << busA;
            5'b01101: result = ($signed(busB)) >>> shf;
            5'b01110: result = ($signed(busB)) >>> busA;
            5'b01111: result = busB >> busA;
            5'b10000: result = {busB[15:0],16'd0};
			default: result = 32'h0000_0000;
		endcase
	end

endmodule // Arithmetic Logic Unit

