`timescale 1ns/1ps

module tb_true_dual_port_ram;
    localparam WIDTH = 8;
    localparam DEPTH = 64;
    localparam DEPTH_LOG = $clog2(DEPTH);

    reg clk;
    reg we_a, we_b;
    reg [DEPTH_LOG-1:0] addr_a, addr_b;
    reg [WIDTH-1:0] data_a, data_b;
    wire [WIDTH-1:0] q_a, q_b;

    integer i;
    integer test_count = 0;
    integer success_count = 0;
    integer error_count = 0;
    reg [DEPTH_LOG-1:0] rand_addr_a, rand_addr_b;

    // Instantiate the RAM module
    true_dual_port_ram dut (
        .q_a(q_a), 
        .q_b(q_b), 
        .data_a(data_a), 
        .data_b(data_b), 
        .addr_a(addr_a), 
        .addr_b(addr_b), 
        .we_a(we_a), 
        .we_b(we_b), 
        .clk(clk)
    );

    // Clock generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        data_a = 0; data_b = 0;
        #10;

        // Test 1: Write to port A, read from port A
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_a = $random;
            write_data_a(data_a, i);
            read_data_a(i);
            #1;
            compare_data(i, data_a, q_a, 0); // Port A
        end

        // Test 2: Write to port B, read from port B
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_b = $random;
            write_data_b(data_b, i);
            read_data_b(i);
            #1;
            compare_data(i, data_b, q_b, 1); // Port B
        end

        // Test 3: Write simultaneously to both ports, read both
        for (i = 0; i < DEPTH; i = i + 1) begin
            rand_addr_a = $random % DEPTH;
            rand_addr_b = $random % DEPTH;
            data_a = (rand_addr_a << 3) | (rand_addr_a % 2 ? 4'hA : 4'h5);
            data_b = (rand_addr_b << 2) | (rand_addr_b % 2 ? 4'hC : 4'h3);
            write_data_both(data_a, rand_addr_a, data_b, rand_addr_b);
            read_data_a(rand_addr_a);
            read_data_b(rand_addr_b);
            #1;
            compare_data(rand_addr_a, data_a, q_a, 0);
            compare_data(rand_addr_b, data_b, q_b, 1);
        end

        // Print test results
        $display("TEST RESULTS: success = %0d, errors = %0d, total = %0d", success_count, error_count, test_count);
        #20 $stop;
    end

    // Task: Write to port A
    task write_data_a(input [WIDTH-1:0] data_in, input [DEPTH_LOG-1:0] address_in);
        begin
            @(posedge clk);
            we_a = 1; data_a = data_in; addr_a = address_in;
            @(posedge clk);
            $display("[WRITE A] Addr_A = %0d, Data_A = %0x", addr_a, data_a);
            we_a = 0;
        end
    endtask

    // Task: Write to port B
    task write_data_b(input [WIDTH-1:0] data_in, input [DEPTH_LOG-1:0] address_in);
        begin
            @(posedge clk);
            we_b = 1; data_b = data_in; addr_b = address_in;
            @(posedge clk);
            $display("[WRITE B] Addr_B = %0d, Data_B = %0x", addr_b, data_b);
            we_b = 0;
        end
    endtask

    // Task: Write to both ports simultaneously
    task write_data_both(
        input [WIDTH-1:0] data_in_a, input [DEPTH_LOG-1:0] address_in_a,
        input [WIDTH-1:0] data_in_b, input [DEPTH_LOG-1:0] address_in_b
    );
        begin
            @(posedge clk);
            we_a = 1; data_a = data_in_a; addr_a = address_in_a;
            we_b = 1; data_b = data_in_b; addr_b = address_in_b;
            @(posedge clk);
            $display("[WRITE BOTH] Addr_A = %0d, Data_A = %0x | Addr_B = %0d, Data_B = %0x", 
                    addr_a, data_a, addr_b, data_b);
            we_a = 0; we_b = 0;
        end
    endtask

    // Task: Read data from port A
    task read_data_a(input [DEPTH_LOG-1:0] address_in);
        begin
            addr_a = address_in;
        end
    endtask


    // Task: Read data from port B
    task read_data_b(input [DEPTH_LOG-1:0] address_in);
        begin
            addr_b = address_in;
        end
    endtask

    // Task: Compare expected vs observed data
    task compare_data(input [DEPTH_LOG-1:0] address, 
                      input [WIDTH-1:0] expected_data, 
                      input [WIDTH-1:0] observed_data, 
                      input bit port);
        begin
            if (expected_data !== observed_data) begin
                $display("ERROR [Port %0s] Addr = %0d, Exp = %0x, 
                Obs = %0x", (port == 0) ? "A" : "B", address, expected_data, observed_data);
                error_count = error_count + 1;
                // $stop;  // stop when error
            end else if (expected_data === observed_data) begin
                $display("SUCCESS [Port %s] Addr = %0d, Exp = %0x, Obs = %0x", 
                         (port == 0) ? "A" : "B", address, expected_data, observed_data);
                success_count = success_count + 1;
            end else begin
                $display("ERROR [Port %s] Addr = %0d, Exp = %0x, Obs = %0x", 
                         (port == 0) ? "A" : "B", address, expected_data, observed_data);
                error_count = error_count + 1;
            end
            test_count = test_count + 1;
        end
    endtask
endmodule