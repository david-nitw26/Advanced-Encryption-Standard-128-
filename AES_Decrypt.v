`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.12.2023 11:55:46
// Design Name: 
// Module Name: AES_Decrypt
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

module AES_Decrypt(reset, ip_cipher, ip_key, op_text);
input reset;
input [127:0] ip_cipher;
input [127:0] ip_key;
output [127:0] op_text;

wire [127:0] words [0:9];    //AS working on 128 bit encryption all 10 words each of size 128 bits : each "words" contain 4 words
parameter rc1 = 32'h01000000;
parameter rc2 = 32'h02000000;
parameter rc3 = 32'h04000000;
parameter rc4 = 32'h08000000;
parameter rc5 = 32'h10000000;
parameter rc6 = 32'h20000000;
parameter rc7 = 32'h40000000;
parameter rc8 = 32'h80000000;
parameter rc9 = 32'h1b000000;
parameter rc10 = 32'h36000000;

round_keys k1 (.reset(reset), .ip_key(ip_key), .rnd_cnst(rc1), .op_key(words[0]));
round_keys k2 (.reset(reset), .ip_key(words[0]), .rnd_cnst(rc2), .op_key(words[1]));
round_keys k3 (.reset(reset), .ip_key(words[1]), .rnd_cnst(rc3), .op_key(words[2]));
round_keys k4 (.reset(reset), .ip_key(words[2]), .rnd_cnst(rc4), .op_key(words[3]));
round_keys k5 (.reset(reset), .ip_key(words[3]), .rnd_cnst(rc5), .op_key(words[4]));
round_keys k6 (.reset(reset), .ip_key(words[4]), .rnd_cnst(rc6), .op_key(words[5]));
round_keys k7 (.reset(reset), .ip_key(words[5]), .rnd_cnst(rc7), .op_key(words[6]));
round_keys k8 (.reset(reset), .ip_key(words[6]), .rnd_cnst(rc8), .op_key(words[7]));
round_keys k9 (.reset(reset), .ip_key(words[7]), .rnd_cnst(rc9), .op_key(words[8]));
round_keys k10 (.reset(reset), .ip_key(words[8]), .rnd_cnst(rc10), .op_key(words[9]));

// initial reverse round : Add the last round key to the cipher text, Inverse Row shift, Inverse Substitute bytes
wire [127:0] af_cipher = ip_cipher ^ words[9];

// Last Inverse round: Inverse shift rows, Inverse Substitute bytes, Add the ip_key
wire [127:0] inv_shift;
assign inv_shift = {af_cipher[127:120], af_cipher[23:16]  , af_cipher[47:40]  , af_cipher[71:64],     
                    af_cipher[95:88]  , af_cipher[119:112], af_cipher[15:8]   , af_cipher[39:32],
                    af_cipher[63:56]  , af_cipher[87:80]  , af_cipher[111:104], af_cipher[7:0],
                    af_cipher[31:24]  , af_cipher[55:48]  , af_cipher[79:72]  , af_cipher[103:96]};

//71:64, 39:32, 7:0, 103:96

// final inverse substitution
wire [127:0] inv_sub;
    AES_Inv_Sbox s5(inv_shift[127:96], inv_sub[127:96]);
    AES_Inv_Sbox s6(inv_shift[95:64] , inv_sub[95:64] );
    AES_Inv_Sbox s7(inv_shift[63:32] , inv_sub[63:32] );
    AES_Inv_Sbox s8(inv_shift[31:0]  , inv_sub[31:0]  );
    
// Add reverse round key, Inverse Mix Columns, Inverse shift rows, Inverse substitute bytes : next 9 rounds

//wire [127:0] inv_rnd [0:8];

wire [127:0] inv_1, inv_2, inv_3, inv_4, inv_5, inv_6, inv_7, inv_8, inv_9;
Gen_op_text d9 (inv_sub, words[8] , inv_9);
Gen_op_text d8 (inv_9, words[7], inv_8);
Gen_op_text d7 (inv_8, words[6], inv_7);
Gen_op_text d6 (inv_7, words[5], inv_6);
Gen_op_text d5 (inv_6, words[4], inv_5);
Gen_op_text d4 (inv_5, words[3], inv_4);
Gen_op_text d3 (inv_4, words[2], inv_3);
Gen_op_text d2 (inv_3, words[1], inv_2);
Gen_op_text d1 (inv_2, words[0], inv_1);

assign op_text = inv_1 ^ ip_key ;
endmodule
