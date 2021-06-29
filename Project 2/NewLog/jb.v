module jb (zout,nout,bnj1, bnj2,bnj3,outmux1,outmux0,jbrnmux,wrtdatmux);  // stat => pass array
input zout,nout,bnj1, bnj2,bnj3;
output outmux0,outmux1;
reg outmux0,outmux1; 
output jbrnmux; //
reg jbrnmux;
output wrtdatmux;
reg wrtdatmux;
always @(bnj1 or bnj2 or bnj3 or zout or nout)
begin
    if (~(bnj1)&bnj2&~(bnj3)) begin  // beq => 010  123
        // stat == 1x => 11:00
        assign outmux0=zout; 
        assign outmux1=zout;
        // wrt=x jbrn = 0
        // assign wrtdatamux = ;
        assign jbrnmux= 0;
    end
    if (~(bnj1)&(bnj2)&bnj3) begin // bgez => 011
        // stat == x0 => 11:00
        assign outmux0=~(nout);
        assign outmux1=~(nout);
        // wrt=x jbrn = 0
        // assign wrtdatamux = ;
        assign jbrnmux= 0;
    end
    if (bnj1&~(bnj2)&~(bnj3)) begin // brn => 100     
        // stat == x1 => 01: 00
        assign outmux0=nout;
        assign outmux1=0;
        // wrt=x jbrn = 1
        // assign wrtdatamux = ;
        assign jbrnmux= 1;
    end
    if (bnj1&bnj2&~(bnj3)) begin //balz => 110
        // stat == 1x => 01 : 00
        assign outmux0=zout;
        assign outmux1=0;
        // wrt= 1/0 jbrn=0
        assign wrtdatmux= zout;
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
        assign wrtdatmux = 0;
        assign jbrnmux= 0;
    end
end
endmodule
