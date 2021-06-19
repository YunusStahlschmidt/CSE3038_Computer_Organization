module alucont(aluop1,aluop0,f5,f4,f3,f2,f1,f0,gout);//Figure 4.12 
input aluop1,aluop0,f5,f4,f3,f2,f1,f0;
output [2:0] gout;
reg [2:0] gout;
always @(aluop1 or aluop0 or f5 or f4 or f3 or f2 or f1 or f0)
begin
if(~(aluop1|aluop0))gout=3'b010; //(add - 00) => sw - lw - jm
if(aluop0&~(aluop1))gout=3'b110; //(sub - 01) => bez - bgez
if(aluop0&aluop1)gout=3'b000; //(andi - 11) => andi
if(aluop1&~(aluop0)) //R-type (10)
begin
	if (~(f3|f2|f1|f0))gout=3'b010; 	//function code=0000,ALU control=010 (add)
	if (f1&f3&~(f0)&~(f2))gout=3'b111;			//function code=1010,ALU control=111 (set on less than)
	if (f1&~(f3)&~(f0)&~(f2))gout=3'b110;		//function code=0010,ALU control=110 (sub) 
	if (f2&f0&~(f3)&~(f1))gout=3'b001;			//function code=0101,ALU control=001 (or)
	if (f2&~(f0)&~(f1)&~(f3)&f5)gout=3'b000;		//function code=100100,ALU control=000 (and)
	if (f2&~(f0)&~(f1)&~(f3)&~(f4)&~(f5))gout=3'b100;		//function code=000100,ALU control=100 (sllv) ----
end
end
endmodule

// I have no idea what I am ~(doing | reading)