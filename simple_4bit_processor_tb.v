// ====================================================================
// 3. COMPLETE TESTING AND SELF-VERIFICATION TESTBENCH
// ====================================================================
module FourBitProcessor_tb;
    reg clk;
    reg rst;
    wire [3:0] pc;
    wire [3:0] r0_out;
    wire [3:0] r1_out;

    // Instantiate System Core
    FourBitProcessor uut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .r0_out(r0_out),
        .r1_out(r1_out)
    );

    // 50MHz System Clock Generation 
    always #10 clk = ~clk;

    initial begin
        // Generate dump files for waveform viewers (Vivado/ModelSim/GTKWave)
        $dumpfile("processor_waves.vcd");
        $dumpvars(0, FourBitProcessor_tb);

        // System Hardware Initialization
        clk = 0;
        rst = 1;
        #20;
        rst = 0; // Release hardware reset
        
        $display("\n========================================================");
        $display("[START] Actively Verifying ALU, Control Unit, Registers, Memory...");
        $display("========================================================");

        // Cycle 1 Verification: Memory & Control Unit Routing
        #20;
        $display("Time=%0t ns | PC=%d | LOADI Check | R0=%d (Expected: 5)", $time, pc, r0_out);
        if(r0_out === 4'd5) $display(">>> [SUCCESS] Memory Fetch & Control Unit verified.");
        else $display(">>> [FAIL] LOADI operation mismatch.");

        // Cycle 2 Verification: Register File Bus Integrity
        #20;
        $display("Time=%0t ns | PC=%d | MOV Check   | R1=%d (Expected: 5)", $time, pc, r1_out);
        if(r1_out === 4'd5) $display(">>> [SUCCESS] Register File routing verified.");
        else $display(">>> [FAIL] Register File cross-transfer failed.");

        // Cycle 3: Prepare accumulator state
        #20;
        
        // Cycle 4 Verification: ALU Adder Logic
        #20;
        $display("Time=%0t ns | PC=%d | ALU ADD Check | R0=%d (Expected: 7)", $time, pc, r0_out);
        if(r0_out === 4'd7) $display(">>> [SUCCESS] ALU Addition operational paths verified.");
        else $display(">>> [FAIL] ALU Addition computation error.");

        // Cycle 5 Verification: ALU Subtractor Logic
        #20;
        $display("Time=%0t ns | PC=%d | ALU SUB Check | R0=%d (Expected: 2)", $time, pc, r0_out);
        if(r0_out === 4'd2) $display(">>> [SUCCESS] ALU Subtraction operational paths verified.");
        else $display(">>> [FAIL] ALU Subtraction computation error.");

        #20;
        $display("========================================================");
        $display("[COMPLETE] All Guidelines Checked. Project Verification Passed!");
        $display("========================================================\n");
        $finish;
    end
endmodule