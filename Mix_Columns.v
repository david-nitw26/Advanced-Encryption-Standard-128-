`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2023 13:34:24
// Design Name: 
// Module Name: Mix_Columns
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

//mix[127:120]&


module Mix_Columns(af_row, af_col);
input [127:0] af_row;
output reg[127:0] af_col;

always @(*)
begin
//initializing the first column
af_col[127:120]  = multi2(af_row[127:120]) ^ multi3(af_row[119:112]) ^ af_row[111:104] ^ af_row[103:96];
af_col[119:112]  = af_row[127:120] ^ multi2(af_row[119:112]) ^ multi3(af_row[111:104]) ^ af_row[103:96];
af_col[111:104]  = af_row[127:120] ^ af_row[119:112] ^ multi2(af_row[111:104]) ^ multi3(af_row[103:96]);
af_col[103:96]   = multi3(af_row[127:120]) ^ af_row[119:112] ^ af_row[111:104] ^ multi2(af_row[103:96]);

//initializing the second column
af_col[95:88] = multi2(af_row[95:88]) ^ multi3(af_row[87:80]) ^ af_row[79:72] ^ af_row[71:64]; 
af_col[87:80] = af_row[95:88] ^ multi2(af_row[87:80]) ^ multi3(af_row[79:72]) ^ af_row[71:64]; 
af_col[79:72] = af_row[95:88] ^ af_row[87:80] ^ multi2(af_row[79:72]) ^ multi3(af_row[71:64]); 
af_col[71:64] = multi3(af_row[95:88]) ^ af_row[87:80] ^af_row[79:72] ^ multi2(af_row[71:64]); 

//intitializing the third column
af_col[63:56] = multi2(af_row[63:56]) ^ multi3(af_row[55:48]) ^ af_row[47:40] ^ af_row[39:32];
af_col[55:48] = af_row[63:56] ^ multi2(af_row[55:48]) ^ multi3(af_row[47:40]) ^ af_row[39:32];
af_col[47:40] = af_row[63:56] ^ af_row[55:48] ^ multi2(af_row[47:40]) ^ multi3(af_row[39:32]);
af_col[39:32] = multi3(af_row[63:56]) ^ af_row[55:48] ^ af_row[47:40] ^ multi2(af_row[39:32]);

//initializing the fourth column
af_col[31:24] = multi2(af_row[31:24]) ^ multi3(af_row[23:16]) ^ af_row[15:8] ^ af_row[7:0];
af_col[23:16] = af_row[31:24]  ^ multi2(af_row[23:16]) ^ multi3(af_row[15:8]) ^ af_row[7:0];
af_col[15:8]  = af_row[31:24] ^ af_row[23:16] ^ multi2(af_row[15:8]) ^ multi3(af_row[7:0]);
af_col[7:0]   = multi3(af_row[31:24]) ^ af_row[23:16] ^ af_row[15:8] ^ multi2(af_row[7:0]);

end


//intitializing the functions "multi2 and multi3"
function [7:0] multi2;
input [7:0] ip;
begin
    if(ip[7] == 1'b0)
        multi2 = {ip[6:0], 1'b0};
    else    //something to do with 'finite field arithmetic' :)
        multi2 = {ip[6:0], 1'b0} ^ 8'h1b;
end
endfunction

//initializing the function to multiply with 0x03
function [7:0] multi3;
    input [7:0] ip_3;

    multi3 = multi2(ip_3)^ip_3;     //3*x = (2 + 1)*x -> (2*x + x)

endfunction
endmodule

