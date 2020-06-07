module dm_4k (
	input 		[11:0] 	addr,
	input 		[31:0] 	din,
	input  				memWr,
	input 				clk,
	input		[5:0]   op,

	output  reg	[31:0] 	dout
);
	reg [31:0] dm [1023:0];// 32-bit*1024
	wire [7:0] tmpD[3:0];

	integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            dm[i] = 32'h0000_0000;
        end 
    end

	//assign dout = dm[addr[11:2]][31:0];

	always @ (negedge clk) begin
        if(memWr) begin
            if(op == 6'b101011)         //sw
                dm[addr[11:2]][31:0] <= din[31:0]; 
            else if(op == 6'b101000)    //sb
            begin
                if      (addr[1:0]==2'b00) dm[addr[11:2]][ 7: 0] <= din[7:0];
                else if (addr[1:0]==2'b01) dm[addr[11:2]][15: 8] <= din[7:0];
                else if (addr[1:0]==2'b10) dm[addr[11:2]][23:16] <= din[7:0];
                else if (addr[1:0]==2'b11) dm[addr[11:2]][31:24] <= din[7:0];
            end
        end
    end

    assign tmpD[0] = dm[addr[11:2]][ 7: 0];
    assign tmpD[1] = dm[addr[11:2]][15: 8];
    assign tmpD[2] = dm[addr[11:2]][23:16];
    assign tmpD[3] = dm[addr[11:2]][31:24];

    //lw  lb  lbu
    always @ (*) begin
        if      (op == 6'b100011) begin  
            assign dout = dm[addr[11:2]];
        end
        else if (op == 6'b100000) begin
            assign dout = {{24{tmpD[addr[1:0]][7]}},tmpD[addr[1:0]]};
        end
        else if (op == 6'b100100) begin
            assign dout = {24'b0,tmpD[addr[1:0]]};
        end
    end

endmodule // 4K Data Memeory

