`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Daniel P
// 
// Create Date: 01/29/2024 12:00:00 PM
// Design Name: 
// Module Name: barrel_shifter
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

//This is a right_barrel shifter:
//module right_barrel_shifter(
//    input logic [7:0] a,
//    input logic [2:0] amt,
//    output logic [7:0] y
//    );
    
//    logic [7:0] s0, s1;
    
//    assign s0 = amt[0] ? {a[0], a[7:1]} : a;
    
//    assign s1 = amt[1] ? {s0[1:0], s0[7:2]} : s0;
    
//    assign y = amt[2] ? {s1[3:0], s1[7:4]} : s1;
    
//endmodule

module barrel_shifter
    #(parameter N = 3)
    (input logic [2**N-1:0] a,
     input logic [N-1:0] amt,
     input logic lr,
     output logic [2**N-1:0] y
    );
    
    logic [2**N-1:0] rightmuxfeed, leftmuxfeed;
    
    param_right_shifter #(N) rightshift(.y(rightmuxfeed), .*);
    param_left_shifter #(N) leftshift(.y(leftmuxfeed), .*);
    
    multi_barrel_shifter_mux #(N) mymux(.d0(leftmuxfeed), .d1(rightmuxfeed), .*);
    
endmodule

module param_right_shifter
    #(parameter N = 3)
    (
    input logic [2**N-1:0] a,
    input logic [N-1:0] amt,
    output logic [2**N-1:0] y
    );
    
    logic [2**N-1:0] sx [0:N-1];
    genvar i;
    
    generate
        assign sx[0] = amt[0] ? {a[0], a[2**N-1:1]} : a;
        for(i = 1; i < N; i = i + 1) begin: forloop
            assign sx[i] = amt[i] ? {sx[i-1][2**i-1:0], sx[i-1][2**N-1:2**i]} : sx[i-1];
        end
        
    endgenerate
    
    assign y = sx[N-1];
        
endmodule

module param_left_shifter
    #(parameter N = 3)
    (
    input logic [2**N-1:0] a,
    input logic [N-1:0] amt,
    output logic [2**N-1:0] y
    );
    
    logic [2**N-1:0] sn [0:N-1];
    genvar i;
    
    generate
        assign sn[0] = amt[0] ? {a[2**N-2:0], a[2**N-1]} : a;
        for(i = 1; i < N; i = i + 1) begin: forloop
            assign sn[i] = amt[i] ? {sn[i-1][2**N-1-2**i:0], sn[i-1][2**N-1:2**N-2**i]} : sn[i-1];
        end
        
    endgenerate 
    
    assign y = sn[N-1];

endmodule

module multi_barrel_shifter_mux
    #(N = 3)
    (input logic[2**N-1:0] d0, d1,
     input logic lr,
     output logic[2**N-1:0] y);
     
     assign y = lr ? d1 : d0;
     
endmodule
     
