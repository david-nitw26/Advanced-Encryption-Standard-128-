`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 15:48:52
// Design Name: 
// Module Name: Gen_op_text
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

// Add Round key, Inverse Mix Columns, Inverse Row shift, Inverse Substitute bytes 
module Gen_op_text(cipher, rnd_key, gen_op);

input [127:0] cipher;
input [127:0] rnd_key;
output [127:0] gen_op;

// Perform all the inverse of the cipher generation process
// Add Round key, Inverse Mix Columns, Inverse Shift Rows, Inverse Substitute Bytes

//Task 1: Add the round key
wire [127:0] add_key = cipher ^ rnd_key;

// Task 2: Perform Inverse Mix Columns 
wire [127:0] inv_mix;
Inv_Mix_Columns m (add_key, inv_mix);

//Task 3: Perform Inverse Row Shifting 
wire [127:0] inv_row;
assign inv_row = {inv_mix[127:120], inv_mix[23:16]  , inv_mix[47:40]  , inv_mix[71:64],     
                  inv_mix[95:88]  , inv_mix[119:112], inv_mix[15:8]   , inv_mix[39:32],
                  inv_mix[63:56]  , inv_mix[87:80]  , inv_mix[111:104], inv_mix[7:0],
                  inv_mix[31:24]  , inv_mix[55:48]  , inv_mix[79:72]  , inv_mix[103:96]};

// Nth row = Nth column in the above arranged inv_row

// Task 4: Perform Inverse Substitution of Bytes
wire [127:0] inv_sub;
    AES_Inv_Sbox s1(inv_row[127:96], inv_sub[127:96]);
    AES_Inv_Sbox s2(inv_row[95:64] , inv_sub[95:64] );
    AES_Inv_Sbox s3(inv_row[63:32] , inv_sub[63:32] );
    AES_Inv_Sbox s4(inv_row[31:0]  , inv_sub[31:0]  );
    
assign gen_op = inv_sub;
endmodule
