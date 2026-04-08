module DSP_TB();

    parameter A0REG=1'b0, A1REG=1'b1, B0REG=1'b0,B1REG=1'b1;
    parameter CREG=1'b1, DREG=1'b1, MREG=1'b1, PREG=1'b1; 
    parameter CARRYINREG=1'b1, CARRYOUTREG=1'b1,OPMODEREG=1'b1;
    parameter CARRYINSEL="OPMODE5";//string CARRYIN orOPMODE5.Tie the output of the mux to 0 if none exist
    parameter B_INPUT="DIRECT";// mux tied to 0 if no one of them are here
    parameter RSTTYPE="SYNC";

    //Reset Input Ports
    reg RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP; 
    //Clock Enable Input Ports
    reg CEA ,CEB ,CEC ,CECARRYIN,CED ,CEM,CEOPMODE,CEP;
    // control signals
    reg CLK ;
    reg [7:0]OPMODE;
    //cascade ports
    reg [47:0]PCIN ;
    reg[17:0]BCIN;

    //data input ports
    reg [17:0]A,B,D;
    reg [47:0]C;   
    reg CARRYIN;
    // data output port
    wire [47:0] PCOUT;
    wire [17:0]BCOUT;
    wire  [35:0]M;
    wire [47:0]P;
    wire  CARRYOUT,CARRYOUTF;

    DSP m1 (.RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM),.RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
      .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
      .CLK(CLK), .OPMODE(OPMODE), .PCIN(PCIN), .PCOUT(PCOUT), .BCOUT(BCOUT), .A(A), .B(B), .D(D), .C(C), .BCIN(BCIN),
      .CARRYIN(CARRYIN), .M(M), .P(P), .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF));

    // Clock initialization
    initial begin
        CLK =0;
        forever begin
            #2 CLK=~CLK;
        end
    end
    initial begin

        //Reset verification
        RSTA=1;RSTB=1;RSTC=1;RSTCARRYIN=1;RSTD=1;RSTM=1;RSTOPMODE=1;RSTP=1;
        {CEA ,CEB ,CEC ,CECARRYIN,CED ,CEM,CEOPMODE,CEP}=8'b11111111;
        OPMODE=$random;A=$random;B=$random;C=$random;D=$random;CARRYIN=$random;PCIN=$random;BCIN=$random;
        @( negedge CLK);
        if(CARRYOUT==0 && CARRYOUTF==0 && P==0 && M==0 && BCOUT==0 && PCOUT==0)begin
            $display("Reset verification works successfully");
        end
        else begin
             $display("ERROR :Reset verification ");
             $stop;
        end
        {RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP}=8'b0000_0000;

    //path 1
        OPMODE = 8'b11011101;
        A = 'd20; B = 'd10; C = 'd350;D ='d25;
        BCIN=$random; PCIN=$random;CARRYIN=$random;
        repeat(4)@(negedge CLK);

        if(BCOUT == 'hf && M == 'h12c && P =='h32&& PCOUT =='h32 && CARRYOUT==0 && CARRYOUTF==0)begin
            $display("Path 1 works successfully");
        end
        else begin
            $display("ERROR!! path 1");    
            $stop;
        end

    //path2
        OPMODE = 8'b00010000;
        A = 'd20; B = 'd10; C = 'd350;D ='d25;
        BCIN=$random; PCIN=$random;CARRYIN=$random;
        repeat(3)@(negedge CLK);
        if(BCOUT == 'h23 && M == 'h2bc && P ==0&& PCOUT ==0 && CARRYOUT==0 && CARRYOUTF==0)begin
            $display("Path 2 works successfully");
        end
        else begin
            $display("ERROR!! path 2");  
            $stop;
        end
        
        

    //path3
        OPMODE = 8'b00001010;
        A = 'd20; B = 'd10; C = 'd350;D ='d25;
        BCIN=$random; PCIN=$random;CARRYIN=$random;
        repeat(3)@(negedge CLK );
        if(BCOUT == 'ha && M =='hc8&& P ==0&& PCOUT ==0 && CARRYOUT==0 && CARRYOUTF==0)begin
                $display("Path 3 works successfully");
        end
        else begin
            $display("ERROR!!path3");
            $stop;
        end

    //path 4
        OPMODE = 8'b10100111;
        A = 'd5;B = 'd6; C = 'd350; D = 'd25 ; PCIN = 'd3000;
        BCIN=$random;CARRYIN=$random;
        repeat(3)@(negedge CLK);

        if(BCOUT == 'h6 && M =='h1e && P ==48'hfe6fffec0bb1&& PCOUT == 'hfe6fffec0bb1&& CARRYOUT==1 && CARRYOUTF==1)begin
            $display("Path 4 works successfully");
        end
        else begin
               $display("ERROR!!Path 4"); 
               $stop;
        end
        $display(" the DSP works succussfully");
        $stop;
        
        





        
    end
    
endmodule