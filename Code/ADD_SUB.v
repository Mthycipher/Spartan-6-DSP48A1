module ADD_SUB (a,b,opcode,out);
parameter size = 1 ;
input [size-1:0] a,b;
input opcode;
output reg [size-1:0] out;
always @(*) begin
case(opcode)
    1'b0: out = a + b;
    1'b1: out = a - b;
    default: out  = a + b ;
endcase   
end

    
endmodule