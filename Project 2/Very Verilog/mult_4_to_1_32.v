module mult4_to_1_32(out, i00,i01,i10,i11,s0,s1);  // multiplexor for pcr
output [31:0] out;
input [31:0]i00,i01,i11,i10;
input s0,s1;
always @(s0 or s1)
begin
    if(~(s0)&~(s1))out=i00; //in 00
    if(~(s0)&s1)out=i01; //in 01
    if(s0&~(s1))out=i10; //in 10
    if(s0&s1)out=i11 //in 11
end
endmodule
