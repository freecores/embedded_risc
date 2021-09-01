/****************************************************************************************
 MODULE:        Sub Level Arithmatic Logic Unit Block

 FILE NAME:    alu.v
 VERSION:    1.0
 DATE:        September 28th, 2001
 AUTHOR:        Hossein Amidi
 COMPANY:    California Unique Electrical Co.
 CODE TYPE:    Register Transfer Level

 Instantiations:
 
 DESCRIPTION:
 Sub Level RTL Arithmatic Logic Unit block

 Hossein Amidi
 (C) September 2001
 California Unique Electric

***************************************************************************************/

`timescale 1ns / 1ps

module ALU # (
   parameter DataWidth = 32,
             OpcodeSize = 8,
             StateSize = 2,
             FunctionSize = 8,

            // Instructions options
             LDA = 8'h0,
             STO = 8'h1,
             ADD = 8'h2,
             SUB = 8'h3,
             JMP = 8'h4,
             JGE = 8'h5,
             JNE = 8'h6,
             STP = 8'h7,
             SHR = 8'h8,
             SHL = 8'h9,
             AND = 8'ha,
             OR  = 8'hb,
             XOR = 8'hc,
             COM = 8'hd,
             SWP = 8'he,
             NOP = 8'hf,

            // Instruction for Memory Map devices
             MAP = 9'h64,

            // Current State options
             Init = 2'b00;
             InstrFetch = 2'b01;
             InstrExec  = 2'b10;

            // Function Select options
             FnAdd    = 8'b0000_0000;
             FnSub    = 8'b0000_0001;
             FnPassB = 8'b0000_0010;
             FnIncB    = 8'b0000_0011;
             FnShtR    = 8'b0000_0100;
             FnShtL    = 8'b0000_0101;
             FnAnd    = 8'b0000_0110;
             FnOr     = 8'b0000_0111;
             FnXor    = 8'b0000_1000;
             FnCom    = 8'b0000_1001;
             FnSwp    = 8'b0000_1010;
             FnNop   = 8'b0000_1011;
) (
   input [DataWidth - 1 : 0] ALUSrcA,
                             ALUSrcB,
   input [OpcodeSize - 1 : 0] OpCode,
   input [StateSize - 1 : 0] CurrentState,

   output reg [DataWidth - 1 : 0] ALUDataOut
);

// Signal Assignments
reg [FunctionSize - 1 : 0] FunctSel;
reg CIn;

wire [DataWidth - 1 : 0] AIn, BIn;

// Assignment
assign AIn = ALUSrcA;
assign BIn = ALUSrcB;

always @(OpCode or CurrentState) begin
   if (CurrentState == InstrFetch) begin
      if (OpCode != STP) begin // In the Fetch cycle increment PC
         FunctSel <= FnIncB;
         CIn <= 1;
      end else begin
         FunctSel <= FnPassB;
         CIn <= 0;
      end
   end else if(CurrentState == InstrExec) begin
      case (OpCode)
         LDA : begin
            FunctSel <= FnPassB;
            CIn <= 0;
         end

         STO : begin
            FunctSel <= FnAdd;
            CIn <= 0;
         end

         ADD : begin
            FunctSel <= FnAdd;
            CIn <= 0;
         end

         SUB : begin
            FunctSel <= FnSub;
            CIn <= 0;
         end

         JMP : begin
            FunctSel <= FnPassB;
            CIn <= 0;
         end

         JGE : begin
            FunctSel <= FnPassB;
            CIn <= 0;
         end

         JNE : begin
            FunctSel <= FnPassB;
            CIn <= 0;
         end

         STP : begin
            FunctSel <= FnPassB;
            CIn <= 0;
         end

         SHR : begin
            FunctSel <= FnShtR;
            CIn <= 0;
         end

         SHL : begin
            FunctSel <= FnShtL;
            CIn <= 0;
         end

         AND : begin
            FunctSel <= FnAnd;
            CIn <= 0;
         end

         OR : begin
            FunctSel <= FnOr;
            CIn <= 0;
         end

         XOR : begin
            FunctSel <= FnXor;
            CIn <= 0;
         end

         COM : begin
            FunctSel <= FnCom;
            CIn <= 0;
         end

         SWP : begin
            FunctSel <= FnSwp;
            CIn <= 0;
         end

         NOP : begin
            FunctSel <= FnNop;
            CIn <= 0;
         end

         default : ;
      endcase
   end
end

always @(AIn or BIn or CIn or FunctSel) begin
   case (FunctSel)
      FnAdd    :  ALUDataOut <= AIn + BIn;
      FnSub    :  ALUDataOut <= AIn - BIn;
      FnPassB  :  ALUDataOut <= BIn;
      FnIncB   :  ALUDataOut <= BIn + CIn;
      FnShtR   :  ALUDataOut <= AIn >> 1;
      FnShtL   :  ALUDataOut <= AIn << 1;
      FnAnd    :  ALUDataOut <= AIn & BIn;
      FnOr     :  ALUDataOut <= AIn | BIn;
      FnXor    :  ALUDataOut <= AIn ^ BIn;
      FnCom    :  ALUDataOut <= ~BIn;
      FnSwp    :  ALUDataOut <= {BIn[15:0],BIn[31:16]};
      FnNop    :  ALUDataOut <= BIn;
      default  :  ALUDataOut <= AIn + BIn;
   endcase
end

endmodule
