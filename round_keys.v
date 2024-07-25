`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2023 21:15:41
// Design Name: 
// Module Name: round_keys
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module g_fun(ip_word, rnd_cnst, op_word);
input [31:0] ip_word;
input [31:0] rnd_cnst;
output [31:0] op_word;

wire [31:0] int_word;       //int_word = intermediate word after performing the left shift on the input word (32 bits)
wire [31:0] subs_word;      //subs_word = after left shifting and substituting from the s-box


assign int_word ={ip_word[23:0], ip_word[31:24]};   //perfoming the right shift on the input word (32 bits)
AES_Sbox f1(int_word, subs_word);
assign op_word = subs_word ^ rnd_cnst;

endmodule


module round_keys(reset, ip_key, rnd_cnst, op_key);
//input clk, reset;
input reset;
input [127:0] ip_key;
input [31:0] rnd_cnst;
output reg [127:0] op_key;

wire [31:0] op_word;        //stores the output word (32 bits) coming from the g_function
g_fun g(ip_key[31:0], rnd_cnst, op_word);

always @(*)
begin
if(reset)
op_key = 128'hx;

else
begin
op_key[127:96] = ip_key[127:96] ^ op_word[31:0];   //be careful about indices and it starts from 127 and way down to 0
op_key[95:64]  = ip_key[95:64]  ^ op_key[127:96];
op_key[63:32]  = ip_key[63:32]  ^ op_key[95:64];
op_key[31:0]   = ip_key[31:0]   ^ op_key[63:32];
end

end
endmodule
