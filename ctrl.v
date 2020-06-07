module ctrl (
	input 	        [31:0] 	ins,

	output 	reg 	[4:0]	aluOp,
	output 	reg		[1:0]   branch,
	output 	reg		        jump,
	output 	reg		        regDst,
	output 	reg		        aluSrc,
    output  reg             regL,
	output 	reg		        regWr,
	output 	reg		        memWr,
	output 	reg		        extOp,
	output 	reg		        memToReg
);

	wire [5:0] op;
	wire [5:0] func;

	assign op	= ins[31:26];
	assign func	= ins[5:0];

	//op
    parameter 
        R       = 6'b000000,
        BLTZ    = 6'b000001,//  BGEZ    = 6'b000001,
        J       = 6'b000010,
        JAL     = 6'b000011,
        BEQ     = 6'b000100,
        BNE     = 6'b000101,
        BLEZ    = 6'b000110,
        BGTZ    = 6'b000111,
        ADDIU   = 6'b001001,
        SLTI    = 6'b001010,
        SLTIU   = 6'b001011,
        ANDI    = 6'b001100,
        ORI     = 6'b001101,
        XORI    = 6'b001110,
        LUI     = 6'b001111,
        LB      = 6'b100000,
        LW      = 6'b100011,
        SW      = 6'b101011,
        LBU     = 6'b100100,
        SB      = 6'b101000;
    //func
    parameter 
        ADD     = 6'b100000,
        ADDU    = 6'b100001,
        SUB     = 6'b100010,
        SUBU    = 6'b100011,
        SLT     = 6'b101010,
        AND     = 6'b100100,
        NOR     = 6'b100111,
        OR      = 6'b100101,
        XOR     = 6'b100110,
        SLL     = 6'b000000,
        SRL     = 6'b000010,
        SLTU    = 6'b101011,
        JARL    = 6'b001001,
        JR      = 6'b001000,
        SLLV    = 6'b000100,
        SRA     = 6'b000011,
        SRAV    = 6'b000111,
        SRLV    = 6'b000110;
				
	always @ (*) begin
        case (op)
            R       :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b1;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                
                case (func)
                    ADD     : aluOp = 5'b00000;
                    ADDU    : aluOp = 5'b00000;
                    SUB     : aluOp = 5'b00001;
                    SUBU    : aluOp = 5'b00001;
                    SLT     : aluOp = 5'b00010;
                    AND     : aluOp = 5'b00011;
                    NOR     : aluOp = 5'b00100;
                    OR      : aluOp = 5'b00101;
                    XOR     : aluOp = 5'b00110;
                    SLL     : aluOp = 5'b00111;
                    SRL     : aluOp = 5'b01000;
                    SLTU    : aluOp = 5'b01001;
                    JARL    : begin aluOp = 5'b01010;   regL = 1'b1;    jump = 1'b1; end
                    JR      : begin aluOp = 5'b01011;   jump = 1;   end
                    SLLV    : aluOp = 5'b01100;
                    SRA     : aluOp = 5'b01101;
                    SRAV    : aluOp = 5'b01110;
                    SRLV    : aluOp = 5'b01111;
                endcase
            end
            BLTZ    :begin  //BLTZ & BGEZ
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                jump        = 1'b0;
                aluOp       = 5'b00000;
                if(ins[20:16] == 5'b00001)
                    branch      = 2'b01;
                else if(ins[20:16] == 5'b00000)
                    branch      = 2'b10;
            end
            J       :begin
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b1;
                aluOp       = 5'b00000;
            end
            JAL     :begin
                regL        = 1'b1;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b1;
                aluOp       = 5'b01010;
            end
            BEQ     :begin         
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b11;
                jump        = 1'b0;
                aluOp       = 5'b00001;
            end
            BNE     :begin
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b11;
                jump        = 1'b0;
                aluOp       = 5'b00001;
            end
            BLEZ    :begin
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b11;
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
            BGTZ    :begin
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b0;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b11;
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
            ADDIU   :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00000; 
            end
            SLTI    :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00010;
            end
            SLTIU   :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b01001;
            end
            ANDI    :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00011;
            end
            ORI     :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00101;
            end
            XORI    :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00110;
            end
            LUI     :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b0;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b10000;
            end
            LB      :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b1;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
            LW      :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b1;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
            SW      :begin
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b1;
                memToReg    = 1'b0;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
            LBU     :begin
                regL        = 1'b0;
                regWr       = 1'b1;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b0;
                memToReg    = 1'b1;
                branch      = 2'b00;
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
            SB      :begin
                regL        = 1'b0;
                regWr       = 1'b0;
                regDst      = 1'b0;
                extOp       = 1'b1;
                aluSrc      = 1'b1;
                memWr       = 1'b1;
                memToReg    = 1'b0;
                branch      = 2'b11;//???????
                jump        = 1'b0;
                aluOp       = 5'b00000;
            end
        endcase
    end

endmodule // Control

