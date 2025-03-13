module true_dual_port_ram(
    output reg [7:0] q_a, q_b,
    input [7:0] data_a, data_b,
    input [5:0] addr_a, addr_b,
    input we_a, we_b, clk
);
    reg [7:0] ram [63:0];
    always @ (posedge clk) begin
        // Check if both ports write the same address
        if (we_a && we_b && (addr_a == addr_b)) begin

            $display("Warning: Simultaneous write to same address %d!", addr_a);
        end else begin
            // port a
            if (we_a) begin
                ram[addr_a] <= data_a;
                q_a <= data_a;
            end else begin
                q_a <= ram[addr_a];
            end

            // port b
            if (we_b) begin
                ram[addr_b] <= data_b;
                q_b <= data_b;
            end else begin
                q_b <= ram[addr_b];
            end
        end
    end
endmodule
