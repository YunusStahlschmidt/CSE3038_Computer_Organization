module mult2_to_1_5(out, i0,i1,s0);
output [4:0] out;
input [4:0]i0,i1;
input s0;
assign out = s0 ? i1:i0;
endmodule


// module mult4_to_1_5(out, i00,i01,i10,i11,regdest1,regdest2);  // multiplexor for 
// output [4:0] out;
// input [4:0]i00,i01,i11,i10;
// input s0,s1;
// always @(s0 or s1)
// begin
//     if(~(s0)&~(s1))out=i00; //in 00
//     if(~(s0)&s1)out=i01; //in 01
//     if(s0&~(s1))out=i10; //in 10
//     if(s0&s1)out=i11 //in 11
// end
// endmodule
