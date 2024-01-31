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
