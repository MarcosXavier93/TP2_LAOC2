module display (SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, KEY, LEDR, LEDG, step, BusWires);
	input [17:0] SW;
	input [0:0] KEY;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	output [17:0] LEDR;
	output [7:0] LEDG;
	
	wire [3:0] a = 4'b0001;
	
	output [1:0] step;
	//wire [4:0] address; 
	//wire [7:0] data, q;
	
	//assign data = SW[7:0];
	//assign address = SW[15:11];
	wire [15:0] addr, DIN;
	output [15:0] BusWires;
	wire w;
	reg enIn;
	reg [15:0] BusIn, addrIn;
	assign Run = SW[16];
	assign Reset = ~KEY[0];
	assign Clock = SW[17];
	assign Done = LEDG[0];
	assign DIN = SW[15:0];
	assign LEDR = SW;
	
	proc proc1 (DIN, Reset, Clock, Run, Done, BusWires, addr, w, step);
	//ramlpm mem1 (addrIn[4:0], Clock, BusWires, enIn, q);
	//ramlpm mem2 ()
	
	/*initial begin
		enIn = 1'b1;
		addrIn = 7'b0000010;
		BusIn = 16'b1111000000000000;
	end*/
	
	hexto7segment h0(BusWires[3:0], HEX0); //ENTRADA
	hexto7segment h1(BusWires[7:4], HEX1); //ENTRADA
	
	hexto7segment h2(BusWires[11:8], HEX2);  //Saída                                                                                                                                                                                                                    
	hexto7segment h3(BusWires[15:12], HEX3);  //Saída
	
	hexto7segment h6({2'b0,step}, HEX6); //ENDEREÇO
	//hexto7segment h5({3'b0,address[4]}, HEX7); //ENDEREÇO
	
endmodule

module hexto7segment(
    input  [3:0]x,
    output reg [6:0]z
    );
always @*
	case (x)
		4'b0000 :      	//Hexadecimal 0
			z = 7'b1000000;
		4'b0001 :    		//Hexadecimal 1
			z = 7'b1111001;
		4'b0010 :  		// Hexadecimal 2
			z = 7'b0100100; 
		4'b0011 : 		// Hexadecimal 3
			z = 7'b0110000;
		4'b0100 :		// Hexadecimal 4
			z = 7'b0011001;
		4'b0101 :		// Hexadecimal 5
			z = 7'b0010010;  
		4'b0110 :		// Hexadecimal 6
			z = 7'b0000010;
		4'b0111 :		// Hexadecimal 7
			z = 7'b1111000;
		4'b1000 :     		 //Hexadecimal 8
			z = 7'b0000000;
		4'b1001 :    		//Hexadecimal 9
			z = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
			z = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
			z = 7'b0000011;
		4'b1100 :		// Hexadecimal C
			z = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
			z = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
			z = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
			z = 7'b0001110 ;
	endcase
 
endmodule
