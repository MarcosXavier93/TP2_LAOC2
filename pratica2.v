module proc (DIN, Resetn, Clock, Run, Done, q, w, Tstep_Q, Daddress, R7, memControl);

	input [15:0] DIN;
	input Resetn, Clock, Run;
	output reg Done, w, memControl;
	output [15:0] Daddress;
	output reg [15:0] q;
	//output [15:0] DOUT;
	output wire [15:0] R7;

	initial begin
		memControl = 1'b0;
	end

	parameter n = 16;
	wire [n-1:0] BusWires;
	reg [n/2-1:0] Rin, Rout;
	wire [n-1:0] instruction;
	output wire [1:0] Tstep_Q;
	
	reg Ain, IRin, Gin, Gout, ADDRin, DOUTin, incr_pc,DINout;
	reg [2:0] opUla;
	reg [1:0] controlALU;
	wire [n-1:0] R0, R1, R2, R3, R4, R5, R6;
	wire [n-1:0] Qa, G;
	//wire [n-1:0] register [7:0];
	wire [3:0] opcode;
	wire Clear = Resetn;
	wire [7:0] Xreg;
	wire [7:0] Yreg;
	wire [n-1:0] aluOut;
	
	upcount Tstep (Clear, Clock, Tstep_Q);
	
	regn RegInstruction(DIN, IRin, Clock, instruction);
	
	//assign opcode = instruction[15:12];
	
	//assign R0 = 16'b0000000000000001;
	//assign R1 = 16'b0000000000000010;
	
	dec3to8 decX (instruction[11:9], 1'b1, Xreg);
	dec3to8 decY (instruction[8:6], 1'b1, Yreg);
	
	regni RegAddress(BusWires, ADDRin, Clock, Daddress);
	//regn RegDOut(BusWires, DOUTin, Clock, DOUT);
	
	always @(Tstep_Q or Xreg or Yreg)
		begin
			Done = 1'b0;
			memControl = 1'b0;
			w = 1'b0;
			//Rin = 7'b0;
			Rout = 7'b0;
			Ain = 1'b0;
			IRin = 1'b0;
			Gin = 1'b0;
			Gout = 1'b0;
			ADDRin = 1'b0;
			DOUTin = 1'b0;
			incr_pc = 1'b0;
			DINout = 1'b0;
			opUla = 3'b0;
			controlALU = 2'b0;
			if(Run) begin
				case (Tstep_Q)
				2'b00: // PASSO 0
					begin
						IRin = 1'b1;
						ADDRin = 1'b0;
						DINout = 1'b0;
						w = 1'b0;
						incr_pc = 1'b1;
						Gout = 1'b0;
						Rout = 16'b0;
						Rin = 16'b0;
						Done = 1'b0;
						memControl = 1'b0;
					end
				2'b01: // PASSO 1
					case (instruction[15:12])
					 4'b1000: //STORE
					 	begin 
					 		incr_pc = 1'b0;
					 		IRin = 1'b0;
					 		Rout = Yreg;
					 		ADDRin = 1'b1;
					 	end
					 4'b1001: // LOAD
						 begin
							incr_pc = 1'b0;
							ADDRin = 1'b1;
							IRin = 1'b0;
							Rout = Yreg;
						 end
					  4'b1111: // MVI
						 begin
							incr_pc = 1'b0;
							IRin = 1'b0;
							//ADDRin = 1'b1;
							Rin = Xreg;
						 end
					  4'b1100: // MVNZ
						 begin
							incr_pc = 1'b0;
							IRin = 1'b0;
							if(G != 16'b0) begin
								Rout = Yreg;
								Rin = Xreg;
							end
							Done = 1'b1;
						end
					  4'b0001: // SUB
						begin
							Rout = Xreg;
							IRin = 1'b0;
							Ain  = 1'b1;
							incr_pc = 1'b0;
						end
					  4'b0110: // SLT
						begin
							incr_pc = 1'b0;
							Rout = Xreg;
							IRin = 1'b0;
							Ain  = 1'b1;
						end
					  4'b0101: // SRL
						 begin
							incr_pc = 1'b0;
							Rout = Xreg;
							IRin = 1'b0;
							Ain  = 1'b1;
						end
					  4'b0100: // SLL
						 begin
							incr_pc = 1'b0;
							Rout = Xreg;
							IRin = 1'b0;
							Ain  = 1'b1;
						end
					  4'b0010: // OR
						begin
						  IRin = 1'b0;
							Rout = Xreg;
							Ain = 1'b1;
							incr_pc = 1'b0;
						end  
					  4'b0000: // ADD
						 begin
							IRin = 1'b0;
							Rout = Xreg;
							Ain = 1'b1;
							incr_pc = 1'b0;
						 end  
						4'b1110: // MV
							begin
							  IRin = 1'b0;
							  Rin = Xreg;
							  Rout = Yreg;
							  incr_pc = 1'b0;
							end
					endcase
				2'b10: // PASSO 2
				 case(instruction[15:12])

				   4'b1000: //STORE
					 	begin
					 		ADDRin = 1'b0;
					 		Rout = Xreg;
					 	end
				   4'b1001: // LOAD
						begin
						  ADDRin = 1'b0;
						  Rout = 16'bx;
						  memControl = 1'b1;
						end
					 4'b1111: // MVI
						begin
						  incr_pc = 1'b1;
						  ADDRin = 1'b0;
						  Done = 1'b1;
						  DINout = 1'b1;
						  //DINout = 1'b0;
						 
						end
					4'b0001: // SUB
					 begin
						Rout = Yreg;
						Gin = 1'b1;
						Ain = 1'b0;
						opUla = 3'b001;
					  end
					4'b0110: // SLT
					 begin
						Rout = Yreg;
						Gin = 1'b1;
						Ain = 1'b0;
						opUla = 3'b101;
					  end
					4'b0101: // SRL
					  begin
						Rout = Yreg;
						Gin = 1'b1;
						Ain = 1'b0;
						opUla = 3'b111;
					  end
					4'b0100: // SLL
					  begin
						Rout = Yreg;
						Gin = 1'b1;
						Ain = 1'b0;
						opUla = 3'b110;
					  end
					 4'b0010: // OR
					  begin
						 Rout = Yreg;
						 Gin = 1'b1;
						 Ain = 1'b0; 
						 opUla = 3'b011;
					  end
					 4'b0000: // ADD
						begin
						 Rout = Yreg;
						 Gin = 1'b1;
						 Ain = 1'b0; 
						 opUla = 3'b000;
						end
					4'b1110: // MV
						begin
							Done = 1'b1;
						end
					endcase
				2'b11: // PASSO 3
				  case(instruction[15:12])
				    4'b1000: //STORE
					 	begin 
					 		w = 1'b1;
					 		ADDRin = 1'b0;
					 		q = BusWires;
					 	end
				    4'b1001: // LOAD
						begin
						  memControl = 1'b1;
						  Rin = Xreg;
						  DINout = 1'b1;
						end
				    4'b1111: // MVI
						begin
						  DINout = 1'b0;
						  Rin = 16'b0;
						  incr_pc = 1'b0;
						end
					4'b0001: // SUB
					  begin
						Gout = 1'b1;
						Rin = Xreg;
						opUla = 3'bxx;
						Done = 1'b1;
					  end
					4'b0110: // SLT
					  begin
						Gout = 1'b1;
						Rin = Xreg;
						opUla = 3'bxx;
						Done = 1'b1;
					  end
					4'b0101: // SRL
					  begin
						Gout = 1'b1;
						Rin = Xreg;
						opUla = 3'bxx;
						Done = 1'b1;
					  end
					4'b0100: // SLL
					  begin
						Gout = 1'b1;
						Rin = Xreg;
						opUla = 3'bxx;
						Done = 1'b1;
					  end
					 4'b0010: // OR
					  begin
						Gout = 1'b1;
						Rin = Xreg;
						opUla = 3'bxx;
						Done = 1'b1;
						end
					4'b0000: // ADD
						begin
							Gout = 1'b1;
							Rin = Xreg;
							opUla = 3'bxx;
							Done = 1'b1;
						end
					endcase
				endcase	
			end
		end

	regn reg_0 (BusWires, Rin[0], Clock, R0);
	regn reg_1 (BusWires, Rin[1], Clock, R1);
	regn reg_2 (BusWires, Rin[2], Clock, R2);
	regn reg_3 (BusWires, Rin[3], Clock, R3);
	regn reg_4 (BusWires, Rin[4], Clock, R4);
	regn reg_5 (BusWires, Rin[5], Clock, R5);
	regn reg_6 (BusWires, Rin[6], Clock, R6);
	
	PC_reg7 PC(BusWires, Rin[7], incr_pc, Clock, R7);
	
	regn rega(BusWires, Ain, Clock, Qa);
	alu ula(Qa, BusWires, opUla, G);
	
	muxBus mb(DIN, R0, R1, R2, R3, R4, R5, R6, G, Rout, Gout, DINout, BusWires);
	
	//alu alu1 (R0, R1, controlALU, R0);
endmodule

module muxBus(DIN, R0, R1, R2, R3, R4, R5, R6, G, Rout, Gout, DINout, bus);
  parameter n = 16;
  input [n-1:0] DIN, G, R0, R1, R2, R3, R4, R5, R6;
  input [n/2-1:0] Rout;
  input Gout, DINout;
  output reg [n-1:0] bus;
  reg En;
  wire [2:0] Reg;
  
  dec8to3 dec(Rout, En, Reg);
  
  always @(Rout, Gout, DINout) begin
    if(Gout) 
      bus <= G;
    else if(DINout)
      bus = DIN;
    else
      /*En <= 1'b1;
      case (Reg)
        3'b000: bus <= R0;
        3'b001: bus <= R1;
      endcase*/
	if (Rout[0] == 1) 
        bus <= R0;
	else if (Rout[1] == 1)
        bus <= R1;
	else if (Rout[2] == 1)
        bus <= R2;
	else if (Rout[3] == 1)
        bus <= R3;
	else if (Rout[4] == 1)
        bus <= R4;
	else if (Rout[5] == 1)
        bus <= R5;
	else if (Rout[6] == 1)
        bus <= R6;
      /*else
        bus <= 16'bx;*/
  end
endmodule

module dec8to3(In, En, Out);
  input [7:0] In;
  input En;
  output reg [2:0] Out;
  
  always @(In, En) begin
    case (In)
      8'b00000001: Out <= 3'b000;
      8'b00000010: Out <= 3'b001;
      8'b00000100: Out <= 3'b010;
      8'b00001000: Out <= 3'b011;
      8'b00010000: Out <= 3'b100;
      8'b00100000: Out <= 3'b101;
      8'b01000000: Out <= 3'b110;
      8'b10000000: Out <= 3'b111;
    endcase
  end
endmodule

module upcount(Clear, Clock, Q);

	input Clear, Clock;
	output reg [1:0] Q;
	
	always @(posedge Clock)
		if (Clear)
			Q <= 2'b0;
		else
			Q <= Q + 1'b1;
endmodule

module dec3to8(W, En, Y);

		input [2:0] W;
		input En;
		output [0:7] Y;
		reg [0:7] Y;
		
		always @(W or En)
			begin
				if (En == 1)
					case (W)
						3'b000: Y = 8'b00000001;
						3'b001: Y = 8'b00000010;
						3'b010: Y = 8'b00000100;
						3'b011: Y = 8'b00001000;
						3'b100: Y = 8'b00010000;
						3'b101: Y = 8'b00100000;
						3'b110: Y = 8'b01000000;
						3'b111: Y = 8'b10000000;
					endcase
				else
					Y = 8'b00000000;
			end
endmodule

module regn(R, Rin, Clock, Q);

	parameter n = 16;
	input [n-1:0] R;
	input Rin, Clock;
	output [n-1:0] Q;
	
	initial begin
	 // Q = 16'b0000000000000010;
	end
	
	reg [n-1:0] Q;
	
	always @(posedge Clock)
		if (Rin)	
			Q <= R;
endmodule

module regni(R, Rin, Clock, Q);
parameter n = 16;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;
reg [n-1:0] Q;


initial 
begin
  Q <= 16'b0;
end


always @(posedge Clock)
if (Rin)
	Q <= R;
endmodule

module PC_reg7 (R, L, incr_pc, Clock, Q);
input [15:0] R;
input L, incr_pc, Clock;
output reg [15:0] Q;

initial
begin
  Q <= 16'b0;
end

always @(posedge Clock)
if (L)
	Q <= R;
else
	if (incr_pc)
		Q <= Q + 1'b1;
endmodule

module alu (opA, opB, control, result);

input	[2:0]  control;
input	[15:0]  opA, opB;
output	reg [15:0]  result;

always @(opA, opB, control )
	case (control)
	  3'b000: 		result <= opA + opB;
	  3'b001: 		result <= opA - opB;
	  3'b011:		result <= opA | opB;
	  3'b101:		begin
	  					if (opA < opB) 
	  					result <= 1'b1; 
						else 
							result <= 1'b0;
					end
	  3'b110:		result <= opA << opB;
	  3'b111:		result <= opA >> opB;
	  endcase
endmodule
