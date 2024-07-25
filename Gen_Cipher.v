`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 15:15:18
// Design Name: 
// Module Name: Gen_Cipher
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


module Gen_Cipher(to_cipher, rnd_key, af_cipher);

input [127:0] to_cipher;
input [127:0] rnd_key;
output [127:0] af_cipher;

//Tasks : Substitute bytes, Shift rows, Mix columns, Add rounded keys
//Task 1: Substitute bytes
wire [127:0] sub_bytes;
    AES_Sbox s1(to_cipher[127:96], sub_bytes[127:96]);
    AES_Sbox s2(to_cipher[95:64] , sub_bytes[95:64] );
    AES_Sbox s3(to_cipher[63:32] , sub_bytes[63:32] );
    AES_Sbox s4(to_cipher[31:0]  , sub_bytes[31:0]  );
    
//Task 2: Shift Rows
wire [127:0] shift_rows;
assign shift_rows = {sub_bytes[127:120], sub_bytes[87:80]  , sub_bytes[47:40]  , sub_bytes[7:0],
                     sub_bytes[95:88]  , sub_bytes[55:48]  , sub_bytes[15:8]   , sub_bytes[103:96],
                     sub_bytes[63:56]  , sub_bytes[23:16]  , sub_bytes[111:104], sub_bytes[71:64],
                     sub_bytes[31:24]  , sub_bytes[119:112], sub_bytes[79:72]  , sub_bytes[39:32]};
                     
//Task 3: Mix Columns
wire [127:0] mix_col;
Mix_Columns m1 (shift_rows, mix_col);

//Task 4: Add the rounded keys
assign af_cipher = mix_col ^ rnd_key;

endmodule
