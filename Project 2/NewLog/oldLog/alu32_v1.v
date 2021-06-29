module alu32(sum,a,b,stat,gin);//ALU operation according to the ALU control line values 
output [31:0] sum;
input [31:0] a,b; 
input [2:0] gin;//ALU control line
reg [31:0] sum;
reg [31:0] less;
output[1:0] stat;  // ADDED: status output
reg [1:0] stat;
// output zout;
// reg zout;
// output nout;
// reg nout;
always @(a or b or gin)
begin
	case(gin) 
	3'b100:	sum=a<<b;		//ALU control line=100, SLLV
	3'b011: sum=a&b;		//ALU control line=011, ANDI
	3'b010: sum=a+b; 		//ALU control line=010, ADD
	3'b110: sum=a+1+(~b);	//ALU control line=110, SUB
	3'b111: begin less=a+1+(~b);	//ALU control line=111, set on less than
			if (less[31]) sum=1;	
			else sum=0;
		  end
	3'b000: sum=a & b;	//ALU control line=000, AND
	3'b001: sum=a|b;		//ALU control line=001, OR
	default: sum=31'bx;	
	endcase
stat[1]=~(|sum);
stat[0]=~(|sum[31]);
// zout=~(|sum);  
// nout=~(|sum[31]);// TODO: set status flags + create status register
end
endmodule
