module mult4_to_1_5(out, i00,i01,i11,regdest1,regdest2);  // multiplexor for regdest
output [4:0] out;
input [4:0]i00,i01,i11;
input regdest1,regdest2;
always @(regdest1 or regdest2)
begin
    if(~(regdest1)&~(regdest2))out=i00; //in 00
    if(~(regdest1)&regdest2)out=i01; //in 01
    if(regdest1&regdest2)out=i11 //in 11
end
endmodule