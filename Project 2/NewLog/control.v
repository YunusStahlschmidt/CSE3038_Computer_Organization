module control(in,funcIn,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch, bnj1, bnj2, bnj3,aluop1,aluop2);
input [5:0] in;
input [4:0] funcIn;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch, bnj1, bnj2, bnj3,aluop1,aluop2;
wire rformat,lw,sw, beq, balz, andi, jm, bgez, j, brn;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
// new commands
assign balz=(~in[5])&in[4]&in[3]&(~in[2])&in[1]&(~in[0]); // 011010 = 26
assign andi=~in[5]&(~in[4])&in[3]&in[2]&(~in[1])&(~in[0]);     // opcode=12 001100
assign jm=(~in[5])&in[4]&(~in[3])&(~in[2])&(~in[1])&(~in[0]);  // 16
assign bgez=in[5]&(~in[4])&(~in[3])&in[2]&in[1]&in[0];  // 39
assign j=(~in[5])&(~in[4])&(~in[3])&(~in[2])&in[1]&(~in[0]); // 2
assign brn=(rformat)&(funcIn[4]&(~funcIn[3])&funcIn[2]&(~funcIn[1])&funcIn[0]); // if funcIn 10101
// new commands end
// assign regdest1=balz; // TODO 2 bit
// assign regdest2=rformat|balz;
assign regdest=rformat;

assign alusrc=lw|sw|andi;
assign memtoreg=lw;
assign regwrite=rformat|lw|andi;
assign memread=lw;
assign memwrite=sw;

assign branch=beq;
// bnj
assign bnj1=brn|balz|jm; // TODO 3 bit left to right
assign bnj2=balz|bgez|beq;
assign bnj3=j|bgez|jm;
// bnj end
assign aluop1=rformat|andi;
assign aluop2=beq|andi|bgez;
endmodule
