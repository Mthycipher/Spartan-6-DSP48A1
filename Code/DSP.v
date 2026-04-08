module DSP(RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,CEA ,CEB ,CEC ,CECARRYIN,CED ,CEM,CEOPMODE,CEP,CLK,OPMODE,PCIN,PCOUT,BCOUT,
            A,B,D,C,BCIN,CARRYIN,M,P,CARRYOUT,CARRYOUTF);
    //parameters
    parameter A0REG=1'b0, A1REG=1'b1, B0REG=1'b0,B1REG=1'b1;
    parameter CREG=1'b1, DREG=1'b1, MREG=1'b1, PREG=1'b1; 
    parameter CARRYINREG=1'b1, CARRYOUTREG=1'b1,OPMODEREG=1'b1;
    parameter CARRYINSEL="OPMODE5";//string CARRYIN orOPMODE5.Tie the output of the mux to 0 if none exist
    parameter B_INPUT="DIRECT";// mux tied to 0 if no one of them are here
    parameter RSTTYPE="SYNC";
    //Reset Input Ports
    input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP; 
    //Clock Enable Input Ports
    input CEA ,CEB ,CEC ,CECARRYIN,CED ,CEM,CEOPMODE,CEP;
    // control signals
    input CLK ;
    input[7:0]OPMODE;
    //cascade ports
    input [47:0]PCIN ;
    input [17:0]BCIN;
    output[47:0] PCOUT;
    output[17:0]BCOUT;
    //data input ports
    input [17:0]A,B,D;
    input[47:0]C;   
    input CARRYIN;
    // data output port
    output [35:0]M;
    output[47:0]P;
    output CARRYOUT,CARRYOUTF;
    
//A0,B0,C,D register_mux

    wire [17:0] B_Muxout,A0_Qreg,B0_Qreg,D_Qreg,A0_Muxout,B0_Muxout,D_Muxout;
    wire [47:0] C_Qreg,C_Muxout;
    assign B_Muxout=(B_INPUT=="DIRECT")? B:(B_INPUT=="CASCADE")?BCIN:0;
    
    regs_mux #(.RSTTYPE(RSTTYPE),.width (18)) A0 (.clk(CLK), .rst(RSTA), .en(CEA), .d(A), .q(A0_Qreg), .sel(A0REG), .muxout(A0_Muxout));
    regs_mux #(.RSTTYPE(RSTTYPE),.width (18)) B0 (.clk(CLK), .rst(RSTB), .en(CEB), .d(B_Muxout), .q(B0_Qreg), .sel(B0REG), .muxout(B0_Muxout));
    regs_mux #(.RSTTYPE(RSTTYPE),.width (48)) C_regmux (.clk(CLK), .rst(RSTC), .en(CEC), .d(C), .q(C_Qreg), .sel(CREG), .muxout(C_Muxout));
    regs_mux #(.RSTTYPE(RSTTYPE),.width (18)) D_regmux (.clk(CLK), .rst(RSTD), .en(CED), .d(D), .q(D_Qreg), .sel(DREG), .muxout(D_Muxout));

    //opcode
    wire [7:0] OPMODE_Qreg,OPMODE_Muxout;
    regs_mux #(.RSTTYPE(RSTTYPE),.width (8)) opcode_reg_mux (.clk(CLK), .rst(RSTOPMODE), .en(CEOPMODE), .d(OPMODE), .q(OPMODE_Qreg), .sel(OPMODEREG), .muxout(OPMODE_Muxout));

// Pre adder_subtractor and A1,B1 register_mux

    wire [17:0] Pre_out,pre_mux_out,A1_Qreg,B1_Qreg,A1_Muxout,B1_Muxout;

    ADD_SUB #(.size(18)) pre_add_sub (.a(D_Muxout), .b(B0_Muxout), .opcode(OPMODE_Muxout[6]), .out(Pre_out));

    assign pre_mux_out = (OPMODE_Muxout[4]==1)?Pre_out:B0_Muxout;

    regs_mux #(.RSTTYPE(RSTTYPE),.width (18)) A1_regmux (.clk(CLK), .rst(RSTA), .en(CEA), .d(A0_Muxout), .q(A1_Qreg), .sel(A1REG), .muxout(A1_Muxout));
    regs_mux #(.RSTTYPE(RSTTYPE),.width (18)) B1_regmux (.clk(CLK), .rst(RSTB), .en(CEB), .d(pre_mux_out), .q(B1_Qreg), .sel(B1REG), .muxout(B1_Muxout));
    assign BCOUT=B1_Muxout;

//Multiplier && M register_mux, cascade carryin register_mux

    wire[35:0] multiply_out,M_Qreg,M_Muxout;

    assign multiply_out = B1_Muxout*A1_Muxout;
    regs_mux #(.RSTTYPE(RSTTYPE),.width (36)) M_regmux (.clk(CLK), .rst(RSTM), .en(CEM), .d(multiply_out), .q(M_Qreg), .sel(MREG), .muxout(M_Muxout));
    assign M = M_Muxout;
    wire car_cascade_Muxout,CYI_Qreg,CYI_Muxout;
    assign car_cascade_Muxout= (CARRYINSEL=="OPMODE5")?OPMODE_Muxout[5]:(CARRYINSEL=="CARRYIN")? CARRYIN:0;
    regs_mux #(.RSTTYPE(RSTTYPE),.width (1)) CYI_regmux (.clk(CLK), .rst(RSTCARRYIN), .en(CECARRYIN), .d(car_cascade_Muxout), .q(CYI_Qreg), .sel(CARRYINREG), .muxout(CYI_Muxout));

//Mux 4-1

    wire[47:0] ABD_conc,conc_M_Muxout;
    
    reg [47:0] mux_X_out,mux_Z_out;

    //mux X
    assign ABD_conc = {D_Muxout[11:0], A1_Muxout, B1_Muxout};
    assign conc_M_Muxout = {12'b0,M_Muxout};
    always @(*) begin
        case (OPMODE_Muxout[1:0])
            2'b00: mux_X_out = 48'b0;
            2'b01: mux_X_out = conc_M_Muxout;
            2'b10: mux_X_out = P;
            2'b11: mux_X_out = ABD_conc;
        endcase
    end

    //mux Z
    always @(*) begin
       case (OPMODE_Muxout[3:2])
            2'b00: mux_Z_out = 48'b0;
            2'b01: mux_Z_out = PCIN;
            2'b10: mux_Z_out = P;
            2'b11: mux_Z_out = C_Muxout;
        endcase
    end

//post add-sub and outputs

    //post add-sub
    reg [47:0]post_out;
    reg CRY_postout;
    always @(*) begin
        case(OPMODE_Muxout[7])
            1'b0:{CRY_postout,post_out} =mux_Z_out +mux_X_out+CYI_Muxout;
            1'b1:{CRY_postout,post_out} =mux_Z_out -(mux_X_out+CYI_Muxout);
            default:{CRY_postout,post_out} =mux_Z_out +mux_X_out+CYI_Muxout ;
        endcase   
    end

    //registers
    wire CYO_Qreg,CYO_muxout;
    regs_mux #(.RSTTYPE(RSTTYPE),.width (1)) carry_out_regmux (.clk(CLK), .rst(RSTCARRYIN), .en(CECARRYIN), .d(CRY_postout), .q(CYO_Qreg), .sel(CARRYOUTREG), .muxout(CYO_muxout));
    assign CARRYOUT=CYO_muxout;
    assign CARRYOUTF= CYO_muxout;

    wire [47:0] P_Qreg,P_muxout;
    regs_mux #(.RSTTYPE(RSTTYPE),.width (48)) P_regmux (.clk(CLK), .rst(RSTP), .en(CEP), .d(post_out), .q(P_Qreg), .sel(PREG), .muxout(P_muxout));
    assign P=P_muxout;
    assign PCOUT=P_muxout;
   
endmodule