module jb (stat,bnj1, bnj2,bnj3,outmux1,outmux0,jbrnmux,wrtdatmux);  // stat => pass array
input [1:0]stat,bnj1, bnj2,bnj3,brnstat;
output outmux0,outmux1;
reg outmux0,outmux1; 
output jbrnmux; //
reg jbrnmux;
output wrtdatmux;
reg wrtdatmux;
always @(bjsignal or stat)
begin
    if (~(bnj1)&bnj2&~(bnj3)) begin  // beq => 010  123
        // stat == 1x => 11:00
        assign outmux0=stat[1]; 
        assign outmux1=stat[1];
        // wrt=x jbrn = 0
        // assign wrtdatamux = ;
        assign jbrnmux= 0;
    end
    if (~(bnj1)&(bnj2)&bnj3) begin // bgez => 011
        // stat == x0 => 11:00
        assign outmux0=~(stat[0]);
        assign outmux1=~(stat[0]);
        // wrt=x jbrn = 0
        // assign wrtdatamux = ;
        assign jbrnmux= 0;
    end
    if (bnj1&~(bnj2)&~(bnj3)) begin // brn => 100     
        // stat == x1 => 01: 00
        assign outmux0=stat[0];
        assign outmux1=0;
        // wrt=x jbrn = 1
        // assign wrtdatamux = ;
        assign jbrnmux= 1;
    end
    if (bnj1&bnj2&~(bnj3)) begin //balz => 110
        // stat == 1x => 01 : 00
        assign outmux0=stat[1];
        assign outmux1=0;
        // wrt= 1/0 jbrn=0
        assign wrtdatamux= stat[1];
        assign jbrnmux= 0;
    end
    if (bnj1&~(bnj2)&bnj3) begin // jm => 101
        // stat x => 10
        assign outmux0=0;
        assign outmux1=1;
        // wrt=x jbrn = 0
        // assign wrtdatamux = ;
        assign jbrnmux= 0;
    end
    if (~(bnj1)&~(bnj2)&bnj3) begin // j => 001
        // stat x => 01
        assign outmux0=1;
        assign outmux1=0;
        // wrt=x jbrn = 0
        // assign wrtdatamux = ;
        assign jbrnmux= 0;
    end
    if (~(bnj1)&~(bnj2)&~(bnj3)) begin // R-Type - lw - sw - andi 
        // stat x => 01
        assign outmux0=0;
        assign outmux1=0;
        assign wrtdatamux = 0;
        assign jbrnmux= 0;
    end
end
// TODO instructions => [ j, r type, sw, lw,...]    
endmodule
