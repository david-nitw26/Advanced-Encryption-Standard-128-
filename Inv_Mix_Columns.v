`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 16:18:34
// Design Name: 
// Module Name: Inv_Mix_Columns
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


module Inv_Mix_Columns(bmix, amix);
input [127:0] bmix;
output [127:0] amix;

// The below is the fixed matrix to multiply with !
    // 14  11  13  09          //if multi2 is the fn to multiply with (02) in hexa and "ip" is the input 
    // 09  14  11  13          // multi(09) = multi_8^ip
    // 13  09  14  11          // multi(11) = multi(08)^multi2^ip
    // 11  13  09  14          // multi(13) = multi(11)^multi2
                               // multi(14) = multi(13)^ip
                               
// Initializing the functions required for the multiplication

// Multiply with 02 :
  function [7 : 0] multi_2(input [7 : 0] op);
    begin
      multi_2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});
    end
  endfunction 

// Multiplies with 03: 
  function [7 : 0] multi_3(input [7 : 0] op);
    begin
      multi_3 = multi_2(op) ^ op;
    end
  endfunction

// Multiplies with 04: 
  function [7 : 0] multi_4(input [7 : 0] op);
    begin
      multi_4 = multi_2(multi_2(op));
    end
  endfunction

// Multiplies with 08:
  function [7 : 0] multi_8(input [7 : 0] op);
    begin
      multi_8 = multi_2(multi_4(op));
    end
  endfunction

// Multiplies with 09: 
  function [7 : 0] multi_9(input [7 : 0] op);
    begin
      multi_9 = multi_8(op) ^ op;
    end
  endfunction

// Multiplies with 11 (0B): 
  function [7 : 0] multi_11(input [7 : 0] op);
    begin
      multi_11 = multi_8(op) ^ multi_2(op) ^ op;
    end
  endfunction

// Multiplies with 13 (0D):
  function [7 : 0] multi_13(input [7 : 0] op);
    begin
      multi_13 = multi_8(op) ^ multi_4(op) ^ op;
    end
  endfunction

// Multiplies with 14 (0E):
  function [7 : 0] multi_14(input [7 : 0] op);
    begin
      multi_14 = multi_8(op) ^ multi_4(op) ^ multi_2(op);
    end
  endfunction

// assigning the first column
assign amix [127:120] = multi_14(bmix[127:120]) ^ multi_11(bmix[119:112]) ^ multi_13(bmix[111:104]) ^ multi_9(bmix[103:96]);
assign amix [119:112] = multi_9(bmix[127:120]) ^ multi_14(bmix[119:112]) ^ multi_11(bmix[111:104]) ^ multi_13(bmix[103:96]);
assign amix [111:104] = multi_13(bmix[127:120]) ^ multi_9(bmix[119:112]) ^ multi_14(bmix[111:104]) ^ multi_11(bmix[103:96]);
assign amix [103:96]  = multi_11(bmix[127:120]) ^ multi_13(bmix[119:112]) ^ multi_9(bmix[111:104]) ^ multi_14(bmix[103:96]);

// assigning the second column
assign amix [95:88] = multi_14(bmix[95:88]) ^ multi_11(bmix[87:80]) ^ multi_13(bmix[79:72]) ^ multi_9(bmix[71:64]);
assign amix [87:80] = multi_9(bmix[95:88]) ^ multi_14(bmix[87:80]) ^ multi_11(bmix[79:72]) ^ multi_13(bmix[71:64]);
assign amix [79:72] = multi_13(bmix[95:88]) ^ multi_9(bmix[87:80]) ^ multi_14(bmix[79:72]) ^ multi_11(bmix[71:64]);
assign amix [71:64] = multi_11(bmix[95:88]) ^ multi_13(bmix[87:80]) ^ multi_9(bmix[79:72]) ^ multi_14(bmix[71:64]);

// assigning the third column
assign amix [63:56] = multi_14(bmix[63:56]) ^ multi_11(bmix[55:48]) ^ multi_13(bmix[47:40]) ^ multi_9(bmix[39:32]);
assign amix [55:48] = multi_9(bmix[63:56]) ^ multi_14(bmix[55:48]) ^ multi_11(bmix[47:40]) ^ multi_13(bmix[39:32]);
assign amix [47:40] = multi_13(bmix[63:56]) ^ multi_9(bmix[55:48]) ^ multi_14(bmix[47:40]) ^ multi_11(bmix[39:32]);
assign amix [39:32] = multi_11(bmix[63:56]) ^ multi_13(bmix[55:48]) ^ multi_9(bmix[47:40]) ^ multi_14(bmix[39:32]);

// assigning the fourth column
assign amix [31:24] = multi_14(bmix[31:24]) ^ multi_11(bmix[23:16]) ^ multi_13(bmix[15:8]) ^ multi_9(bmix[7:0]);
assign amix [23:16] = multi_9(bmix[31:24]) ^ multi_14(bmix[23:16]) ^ multi_11(bmix[15:8]) ^ multi_13(bmix[7:0]);
assign amix [15:8]  = multi_13(bmix[31:24]) ^ multi_9(bmix[23:16]) ^ multi_14(bmix[15:8]) ^ multi_11(bmix[7:0]);
assign amix [7:0]   = multi_11(bmix[31:24]) ^ multi_13(bmix[23:16]) ^ multi_9(bmix[15:8]) ^ multi_14(bmix[7:0]);

endmodule
