`timescale 1ns / 1ps

// ====================================================================
// 1. INDIVIDUAL HARDWARE MODULES (As specified by Guidelines)
// ====================================================================

// --- Module 1: Program Memory (ROM) ---
module ProgramMemory (
    input wire [3:0] address,
    output reg [7:0] instruction
);
    always @(*) begin
        case(address)
            // Custom ISA Test Program:
            4'h0: instruction = 8'b0001_0101; // LOADI R0, #5  -> Load 5 into R0
            4'h1: instruction = 8'b0100_0000; // MOV R1, R0    -> Copy R0 (5) into R1
            4'h2: instruction = 8'b0001_0010; // LOADI R0, #2  -> Load 2 into R0
            4'h3: instruction = 8'b0010_0001; // ADD R0, R1    -> R0 = R0 (2) + R1 (5) = 7
            4'h4: instruction = 8'b0011_0001; // SUB R0, R1    -> R0 = R0 (7) - R1 (5) = 2
            default: instruction = 8'b0000_0000; // NOP (No Operation)
        endcase
    end
endmodule

// --- Module 2: Register File ---
module RegisterFile (
    input wire clk,
    input wire rst,
    input wire [1:0] read_reg,
    input wire [1:0] write_reg,
    input wire write_en,
    input wire [3:0] write_data,
    output wire [3:0] read_data,
    output wire [3:0] r0_val, // Dedicated wires to monitor register states
    output wire [3:0] r1_val
);
    reg [3:0] registers [3:0]; // 4 registers, each 4 bits wide

    assign read_data = registers[read_reg];
    assign r0_val    = registers[2'b00]; 
    assign r1_val    = registers[2'b01]; 

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                registers[i] <= 4'b0000;
            end
        end else if (write_en) begin
            registers[write_reg] <= write_data;
        end
    end
endmodule

// --- Module 3: Arithmetic Logic Unit (ALU) ---
module ALU (
    input wire [3:0] operand_a,
    input wire [3:0] operand_b,
    input wire alu_op, // 0 for ADD, 1 for SUB
    output reg [3:0] alu_out
);
    always @(*) begin
        if (alu_op == 1'b0)
            alu_out = operand_a + operand_b;
        else
            alu_out = operand_a - operand_b;
    end
endmodule

// --- Module 4: Standalone Control Unit ---
module ControlUnit (
    input wire [3:0] opcode,
    input wire [3:0] operand,
    output reg reg_write_en,
    output reg [1:0] write_reg,
    output reg [1:0] read_reg,
    output reg alu_op,
    output reg select_alu_src
);
    always @(*) begin
        // Default execution paths
        reg_write_en   = 1'b0;
        write_reg      = 2'b00;
        read_reg       = operand[1:0];
        alu_op         = 1'b0;
        select_alu_src = 1'b0;

        case(opcode)
            4'b0001: begin // LOADI R0, #Immediate
                reg_write_en   = 1'b1;
                write_reg      = 2'b00; // Destination is R0
                select_alu_src = 1'b0; // Route immediate value directly
            end
            4'b0100: begin // MOV R1, Reg Source
                reg_write_en   = 1'b1;
                write_reg      = 2'b01; // Destination is R1
                select_alu_src = 1'b0; // Route read register value directly
            end
            4'b0010: begin // ADD R0, Reg Source
                reg_write_en   = 1'b1;
                write_reg      = 2'b00; // Result goes to Accumulator (R0)
                alu_op         = 1'b0;  // ALU Operation: ADD
                select_alu_src = 1'b1; // Route ALU Result to Register
            end
            4'b0011: begin // SUB R0, Reg Source
                reg_write_en   = 1'b1;
                write_reg      = 2'b00; // Result goes to Accumulator (R0)
                alu_op         = 1'b1;  // ALU Operation: SUB
                select_alu_src = 1'b1; // Route ALU Result to Register
            end
            default: ;
        endcase
    end
endmodule

// ====================================================================
// 2. TOP LEVEL SYSTEM INTERCONNECT
// ====================================================================
module FourBitProcessor (
    input wire clk,
    input wire rst,
    output reg [3:0] pc,
    output wire [3:0] r0_out,
    output wire [3:0] r1_out
);
    // Interconnect wires
    wire [7:0] instruction;
    wire reg_write_en;
    wire [1:0] write_reg;
    wire [1:0] read_reg;
    wire alu_op;
    wire select_alu_src;
    wire [3:0] reg_read_data;
    wire [3:0] alu_result;
    wire [3:0] write_back_data;

    // Program Counter Step Logic
    always @(posedge clk or posedge rst) begin
        if (rst) pc <= 4'b0000;
        else pc <= pc + 1'b1;
    end

    // MUX to decide register data input (Immediate/MOV vs ALU result)
    assign write_back_data = select_alu_src ? alu_result : 
                             (instruction[7:4] == 4'b0001 ? instruction[3:0] : reg_read_data);

    // Structural Instantiations linking all blocks together
    ProgramMemory memory_inst (
        .address(pc),
        .instruction(instruction)
    );

    ControlUnit control_inst (
        .opcode(instruction[7:4]),
        .operand(instruction[3:0]),
        .reg_write_en(reg_write_en),
        .write_reg(write_reg),
        .read_reg(read_reg),
        .alu_op(alu_op),
        .select_alu_src(select_alu_src)
    );

    RegisterFile registers_inst (
        .clk(clk),
        .rst(rst),
        .read_reg(read_reg),
        .write_reg(write_reg),
        .write_en(reg_write_en),
        .write_data(write_back_data),
        .read_data(reg_read_data),
        .r0_val(r0_out),
        .r1_val(r1_out)
    );

    ALU alu_inst (
        .operand_a(r0_out),       // Accumulator input
        .operand_b(reg_read_data), // Register input
        .alu_op(alu_op),
        .alu_out(alu_result)
    );

endmodule



