// Review decode stage

module cpu_decode (
    input clk, 
    input reset,

    input [15:0] i_pc,
    input [15:0] i_ir,    // the entire instruction
    
    // to and from registers
    input [15:0] i_rx_data,
    input [15:0] i_ry_data,
    output logic [3:0] o_rx,
    output logic [3:0] o_ry,

    // outputs
    output logic [15:0] o_pc,
    output logic [15:0] o_ir,
    output logic [15:0] o_A,
    output logic [15:0] o_B
);

    assign o_pc = i_pc;
    assign o_ir = i_ir;

    wire [7:0] imm8;
    wire [10:0] imm11;
    wire [15:0] s_ext_imm8, s_ext_imm11x2;
    assign imm8 = i_ir[15:8];
    assign imm11 = i_ir[15:5];
    assign s_ext_imm8 = { {8{imm8[7]}}, imm8[7:0]};
    assign s_ext_imm11x2 = 2 * { {5{imm11[10]}}, imm11[10:0]};

    logic [4:0] instruction;
    assign instruction = i_ir[4:0];

    localparam  mv =    5'b00000,
                add =   5'b00001,
                sub =   5'b00010,
                cmp =   5'b00011,
                ld =    5'b00100,
                st =    5'b00101,
                
                mvi =   5'b10000,
                addi =  5'b10001,
                subi =  5'b10010,
                cmpi = 5'b10011,
                mvhi =  5'b10110,

                jr =    5'b01000,
                jzr =   5'b01001,
                jnr =   5'b01010,
                callr = 5'b01100,
                
                j =     5'b11000,
                jz =    5'b11001,
                jn =    5'b11010,
                call =  5'b11100;

    // Find o_A, o_B
    always_comb begin
        o_A = '0;
        o_B = '0;
        o_rx = o_ir[7:5];
        o_ry = o_ir[10:8];
        case(instruction)
            mv: begin
                o_rx = '1;
                o_B = i_ry_data;
            end
            mvi: begin
                o_A = s_ext_imm8;
                o_rx = '1;
                o_ry = '1;
            end
            mvhi: begin
                o_A = i_rx_data;
                o_B = s_ext_imm8;
                o_ry = '1;
            end
            add: begin
                o_A = i_rx_data;
                o_B = i_ry_data;
            end
            addi: begin
                o_A = i_rx_data;
                o_B = s_ext_imm8;
                o_ry = '1;
            end
            sub: begin
                o_A = i_rx_data;
                o_B = i_ry_data;
            end
            subi: begin
                o_A = i_rx_data;
                o_B = s_ext_imm8;
                o_ry = '1;
            end
            cmp: begin
                o_A = i_rx_data;
                o_B = i_ry_data;
            end
            cmpi: begin
                o_A = i_rx_data;
                o_B = s_ext_imm8;
                o_ry = '1;
            end
            ld: begin
                o_rx = '1;
                o_B = i_ry_data;
            end
            st: begin
                o_A = i_rx_data;
                o_B = i_ry_data;
            end
            jr: begin
                o_A = i_rx_data;
                o_ry = '1;
            end
            j: begin
                o_A = i_pc;
                o_B = s_ext_imm11x2;
                o_rx = '1;
                o_ry = '1;
            end
            jzr: begin
                o_A = i_rx_data;
                o_ry = '1;
            end
            jz: begin
                o_A = i_pc;
                o_B = s_ext_imm11x2;
                o_rx = '1;
                o_ry = '1;
            end
            jnr: begin
                o_A = i_rx_data;
                o_ry = '1;
            end
            jn: begin
                o_A = i_pc;
                o_B = s_ext_imm11x2;  
                o_rx = '1;
                o_ry = '1;              
            end
            callr: begin
                o_A = i_rx_data;
                o_ry = '1;
            end
            call: begin
                o_A = i_pc;
                o_B = s_ext_imm11x2;
                o_rx = '1;
                o_ry = '1;
            end
        endcase
    end
    
endmodule