`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2023 11:41:17
// Design Name: 
// Module Name: AES_Main
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

//intital round -> add rounded(input) key
//next 10 rounds -> shift rows, mix columns, add rounded keys
//last round -> shift rows, add rounded key

module AES_Main(reset, ip_text, ip_key, op_cipher);
//input clk, reset;
input reset;
input [127:0] ip_text, ip_key;
output [127:0] op_cipher;
//output [127:0] op_text;

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

// Addition of the rounded key in the initial round
wire [127:0] init_rnd = ip_text ^ ip_key;

// Intitialize a wire array to store and perform next 9 rounds
wire [127:0] rnd_transform [0:8];

Gen_Cipher g1 (init_rnd, words[0], rnd_transform[0]);
Gen_Cipher g2 (rnd_transform[0], words[1], rnd_transform[1]);
Gen_Cipher g3 (rnd_transform[1], words[2], rnd_transform[2]);
Gen_Cipher g4 (rnd_transform[2], words[3], rnd_transform[3]);
Gen_Cipher g5 (rnd_transform[3], words[4], rnd_transform[4]);
Gen_Cipher g6 (rnd_transform[4], words[5], rnd_transform[5]);
Gen_Cipher g7 (rnd_transform[5], words[6], rnd_transform[6]);
Gen_Cipher g8 (rnd_transform[6], words[7], rnd_transform[7]);
Gen_Cipher g9 (rnd_transform[7], words[8], rnd_transform[8]);
//Gen_Cipher g10(rnd_transform[8], words[9], rnd_transform[9]);

// Perform the last round without the Mix_Column Operation
//Substitution of bytes
wire [127:0] penultimate;
assign penultimate = rnd_transform[8];

wire [127:0] fin_sub;
    AES_Sbox s1(penultimate[127:96], fin_sub[127:96]);
    AES_Sbox s2(penultimate[95:64] , fin_sub[95:64] );
    AES_Sbox s3(penultimate[63:32] , fin_sub[63:32] );
    AES_Sbox s4(penultimate[31:0]  , fin_sub[31:0]  );
    
// Row shifting 
wire [127:0] fin_row;
assign fin_row = {fin_sub[127:120], fin_sub[87:80]  , fin_sub[47:40]  , fin_sub[7:0],
                  fin_sub[95:88]  , fin_sub[55:48]  , fin_sub[15:8]   , fin_sub[103:96],
                  fin_sub[63:56]  , fin_sub[23:16]  , fin_sub[111:104], fin_sub[71:64],
                  fin_sub[31:24]  , fin_sub[119:112], fin_sub[79:72]  , fin_sub[39:32]};
                  
// Addition of the Round key
assign op_cipher = fin_row ^ words[9];

endmodule
