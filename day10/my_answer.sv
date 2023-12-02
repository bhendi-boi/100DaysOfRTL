module temp (
    input wire clk,
    input wire reset,
    input wire load_i,
    input wire[3:0] load_val_i,
    output wire[3:0] count_o       
);
    logic [3:0] next_ff;
    always_ff @(posedge clk or posedge reset ) begin : bq
        if(reset) begin
            next_ff <= 4'b0;
        end
        else if(load_i) begin
            next_ff <= load_val_i;
        end
        else begin
            next_ff <= next_ff + 4'b1;
        end
    end
    assign count_o = next_ff;
    
endmodule