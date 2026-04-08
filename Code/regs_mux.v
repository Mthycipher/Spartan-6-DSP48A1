module regs_mux(clk,rst,en,d,q ,sel,muxout);
    
    parameter RSTTYPE="SYNC";
    parameter width =1 ;
    input clk,rst,en,sel;
    input[width-1:0] d;
    output reg [width-1:0] q;
    output [width-1:0] muxout;
    generate
        if (RSTTYPE=="ASYNC") begin
            always @(posedge clk or posedge rst) begin
                if(rst)
                    q<=0;
                else begin
                    if (en) begin
                        q<=d;
                    end
                end      
            end
        end else begin
            always @(posedge clk) begin
                if(rst)
                    q<=0;
                else begin
                    if (en) begin
                        q<=d;
                    end
                end      
            end
        end    
    endgenerate
    assign muxout= (sel==1)?q:d;


    
endmodule