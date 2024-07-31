`include "defines.v"

module clint (
    input   wire                        clk_i,
    input   wire                        rst_n_i,

    input   wire [`INST_DATA_BUS]       inst_i,         
    input   wire [`INST_ADDR_BUS]       inst_addr_i,
    input   wire                        jump_flag_o,
    input   wire [`INST_ADDR_BUS]       jump_addr_o,

    input   wire [`CSR_DATA_BUS]        csr_mtvec_i,
    input   wire [`CSR_DATA_BUS]        csr_mepc_i,
    input   wire [`CSR_DATA_BUS]        csr_mstatus_i,

    input   reg  [`CSR_DATA_BUS]        clint_rdata_i,
    output  reg  [`CSR_ADDR_BUS]        clint_raddr_o,
    output  reg                         clint_wen_o,
    output  reg  [`CSR_ADDR_BUS]        clint_waddr_o,
    output  reg  [`CSR_DATA_BUS]        clint_wdata_o,

    input   wire [`INT_BUS]             int_flag_i, 
    output  wire                        clint_busy_o, 
    output  reg [`INST_ADDR_BUS]        int_addr_o, 
    output  reg                         int_assert_o          
);
    
endmodule