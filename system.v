module system (Clock, Reset, dout, q, Run, Done);

input Clock, Reset, Run;
output [15:0] dout, q;
output Done;

wire [15:0] addr, memout;
reg [15:0] procin;

wire [5:0] addr1, addr2;
wire [15:0] q1, q2, q;

wire [15:0] DIN, DOUT;

wire w;
	//wire [7:0] data, q;
	
	//assign data = SW[7:0];
	//assign address = SW[15:11];
	//wire BusWires;
	reg enIn;
	reg [15:0] BusIn, addrIn;
	
	proc proc1 (DIN, Reset, Clock, Run, Done, DOUT, w, Tstep_Q, addr1, addr2, qControl);
	//ramlpm mem1 (addrIn[4:0], Clock, BusWires, enIn, q);
	memory_main mem1(addr1, DOUT, w, Clock, q1);
	memory_instruction mem2(addr2, BusWires, 1'b0, Clock, q2); // instrução
	mux2pra1 mux(q1,q2,qControl, DIN);

	//ramlpm mem2 ()
	
	initial begin
		enIn = 1'b1;
		addrIn = 7'b0000010;
		BusIn = 16'b1111000000000000;
	end


endmodule

module mux2pra1(q1, q2, control, DIN);
input [15:0] q1, q2;
input control;
output reg [15:0] DIN;

always@(q1, q2, control) begin
	case(control)
		1'b0: DIN = q2;
		1'b1: DIN = q1;
	endcase
end

endmodule


