module control(in,regdest1, regdest2, alusrc,memtoreg,regwrite,memread,memwrite, bnj1, bnj2, bnj3,aluop1,aluop2);
input [5:0] in;
output regdest1,regdest2, alusrc,memtoreg,regwrite,memread,memwrite, bnj1, bnj2, bnj3,aluop1,aluop2;
wire rformat,lw,sw, balz, andi, jm, bgez, j, brn;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign balz=(~in[5])&in[4]&in[3]&(~in[2])&in[1]&(~in[0]); // 011010 = 26
assign andi=(~in[5])&(~in[4])&in[3]&in[2]&(~in[1])&(~in[0]); // 001100
assign jm=(~in[5])&in[4]&(~in[3])&(~in[2])&(~in[1])&(~in[0]);  // 16
assign bgez=in[5]&(~in[4])&(~in[3])&in[2]&in[1]&in[0];  // 39
assign j=(~in[5])&(~in[4])&(~in[3])&(~in[2])&in[1]&(~in[0]); // 2
assign regdest1=balz; // TODO 2 bit
assign regdest2=rformat|balz;
assign alusrc=lw|sw|andi|jm;
assign memtoreg=lw|jm;
assign regwrite=rformat|lw|andi|balz;
assign memread=lw|jm;
assign memwrite=sw;
assign bnj1=brn|balz|jm; // TODO 3 bit
assign bnj2=balz|bgez|beq;
assign bnj3=j|bgez|jm;
assign aluop1=rformat|andi;
assign aluop2=beq|bgez|andi;


endmodule
