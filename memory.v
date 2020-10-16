module memory_main (addr, data, wr_en, Clock, q);

input [4:0] addr; 
input [15:0] data;
input wr_en, Clock;
output reg [15:0] q;

reg [15:0] Mem [0:7];


initial 
begin

Mem[3] = 16'b0000000000000100;
  
/*Mem[ 5'h0] = 16'hf000;

  
  Mem[ 5'h1d] = 16'h0;
  Mem[ 5'h1e] = 16'h0;
  Mem[ 5'h1f] = 16'h1;*/
  

  
end

always @(posedge Clock , addr) begin
	q = Mem[addr];
end

always @(posedge Clock)
begin
  if (wr_en) Mem[addr] = data;
  
end

endmodule

module memory_instruction (addr, data, wr_en, Clock, q);

input [5:0] addr; 
input [15:0] data;
input wr_en, Clock;
output reg [15:0] q;

wire [15:0] a;

reg [15:0] Mem [0:64];

always @(addr) begin
assign q = Mem[addr];
end

initial 
begin
  
  Mem[0] =  16'b1111000000000000; // MVI R0, #2
  Mem[1] =  16'b0000000000000010;
  Mem[2] =  16'b1111001000000000; // MVI R1, #3
  Mem[3] =  16'b0000000000000011;
  Mem[4] =  16'b0000001000000000; // ADD R1, R0
  Mem[5] =  16'b1111010000000000; // MVI R2, #6
  Mem[6] =  16'b0000000000000110;
  Mem[7] =  16'b0001010001000000; // SUB R2, R1
  Mem[8] =  16'b1110011010000000; // MV R3, R2
  Mem[9] =  16'b0000000011000000; // ADD R0, R3
  Mem[10] = 16'b0010001000000000; // OR R1, R0
  Mem[11] = 16'b0001001000000000; // SUB R1, R0
  Mem[12] = 16'b0000001011000000; // ADD R1, R3
  Mem[13] = 16'b0100001011000000; // SLL R1, R3
  Mem[14] = 16'b0101001011000000; // SRL R1, R3
  Mem[15] = 16'b1111000000000000; // MVI R0, #0
  Mem[16] = 16'b0000000000000000;
  Mem[17] = 16'b0110000001000000; // SLT R0, R1
  Mem[18] = 16'b0110001001000000; // SLT R1, R1
  Mem[19] = 16'b1111011000000000; // MVI R3, #3
  Mem[20] = 16'b0000000000000011;
  Mem[21] = 16'b1111001000000000; // MVI R1, #5
  Mem[22] = 16'b0000000000000101;
  Mem[23] = 16'b0000000011000000; // ADD R0, R3
  Mem[24] = 16'b1111000000000000; // MVI R0, #0
  Mem[25] = 16'b0000000000000000;
  Mem[26] = 16'b1001010011000000; // LD R2, R3
  Mem[27] = 16'b0000010011000000; // ADD R2, R3
  Mem[28] = 16'b1000010000000000; // SD R2, R0
  Mem[29] = 16'b1001000000000000; // LD R0 R0
  Mem[30] = 16'b0001000011000000; // SUB R0, R3
  Mem[31] = 16'b1111000000000000; // MVI R0, #0
  Mem[32] = 16'b0000000000000000;
  Mem[33] = 16'b0000000000000000; // ADD R0, R0
  Mem[34] = 16'b1100000010000000; // MVNZ R0, R2
  Mem[35] = 16'b0001001011000000; // SUB R1, R3
  Mem[36] = 16'b1100000010000000; // MVNZ R0, R2
  Mem[37] = 16'b0000000001000000; // ADD R0, R1
/*Mem[ 5'h0] = 16'hf000;

  
  Mem[ 5'h1d] = 16'h0;
  Mem[ 5'h1e] = 16'h0;
  Mem[ 5'h1f] = 16'h1;*/
  
end

always @(posedge Clock)
begin
  if (wr_en) Mem[addr] = data;
  
end

endmodule

