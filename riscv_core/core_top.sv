`include "defines.v"

module core_top (
    input   wire                        clk_i,
    input   wire                        rst_n_i,

    // pc_reg
    output  wire [`INST_ADDR_BUS]       pc_addr_o,

    // inst_fetch
    input   wire [`INST_DATA_BUS]       rib_inst_i,           
    input   wire [`INST_ADDR_BUS]       rib_inst_addr_i, 
);

// pc_reg
wire [`HOLD_BUS]            hold_flag_ctrl;
wire                        jump_flag_ctrl;
wire [`INST_ADDR_BUS]       jump_addr_ctrl;

// inst_fetch
wire [`HOLD_BUS]            hold_flag_ctrl;       
wire [`INT_BUS]             int_flag_ctrl;  
wire [`INT_BUS]             int_flag_id;  
wire [`INST_DATA_BUS]       inst_if;         
wire [`INST_ADDR_BUS]       inst_addr_if;      

// inst_decode
wire [`REG_DATA_BUS]        reg1_rdata_id;
wire [`REG_ADDR_BUS]        reg1_raddr_id;
wire [`REG_DATA_BUS]        reg2_rdata_id;
wire [`REG_ADDR_BUS]        reg2_raddr_id;
wire [`CSR_DATA_BUS]        csr_rdata_id;
wire [`CSR_ADDR_BUS]        csr_raddr_id;
wire [`REG_DATA_BUS]        op1_id;
wire [`REG_DATA_BUS]        op2_id;
wire [`REG_DATA_BUS]        offset_id;
wire [`INST_DATA_BUS]       inst_id;         
wire [`INST_ADDR_BUS]       inst_addr_id;        
wire                        reg_wen_id;             
wire [`REG_ADDR_BUS]        reg_waddr_id;    
wire                        csr_wen_id;        
wire [`CSR_DATA_BUS]        csr_rdata_id;      
wire [`CSR_ADDR_BUS]        csr_waddr_id;

// id_to_ex
wire [`REG_DATA_BUS]        op1_id_to_ex;
wire [`REG_DATA_BUS]        op2_id_to_ex;
wire [`REG_DATA_BUS]        offset_id_to_ex;
wire [`INST_DATA_BUS]       inst_id_to_ex;         
wire [`INST_ADDR_BUS]       inst_addr_id_to_ex;        
wire                        reg_wen_id_to_ex;             
wire [`REG_ADDR_BUS]        reg_waddr_id_to_ex;    
wire                        csr_wen_id_to_ex;        
wire [`CSR_DATA_BUS]        csr_rdata_id_to_ex;      
wire [`CSR_ADDR_BUS]        csr_waddr_id_to_ex;

pc_reg      u_pc_reg (
    .clk_i                  (clk_i),
    .rst_n_i                (rst_n_i),
    .hold_flag_i            (hold_flag_ctrl),
    .jump_flag_i            (jump_flag_ctrl),
    .jump_addr_i            (jump_addr_ctrl),
    .pc_addr_o              (pc_addr_o)
);

inst_fetch  u_if(
    .clk_i                  (clk_i),
    .rst_n_i                (rst_n_i),
    .hold_flag_i            (hold_flag_ctrl),       
    .interrupt_flag_i       (int_flag_ctrl),  
    .interrupt_flag_o       (int_flag_id),  
    .inst_i                 (rib_inst_i),            
    .inst_addr_i            (rib_inst_addr_i),       
    .inst_o                 (inst_if),            
    .inst_addr_o            (inst_addr_if)        
);

inst_decode u_id(
    .clk_i                  (clk_i),
    .rst_n_i                (rst_n_i),
    .inst_i                 (inst_if),            
    .inst_addr_i            (inst_addr_if),       
    
    .reg1_rdata_i           (reg1_rdata_id),
    .reg2_rdata_i           (reg2_rdata_id),
    .reg1_raddr_o           (reg1_raddr_id),
    .reg2_raddr_o           (reg2_raddr_id),

    .csr_rdata_i            (csr_rdata_id),
    .csr_raddr_o            (csr_raddr_id),  

    .op1_o                  (op1_o_id),
    .op2_o                  (op2_o_id),
    .offset_o               (offset_id),
    .inst_o                 (inst_id),         
    .inst_addr_o            (inst_addr_id),        
    .reg_wen_o              (reg_wen_id),             
    .reg_waddr_o            (reg_waddr_id),    
    .csr_wen_o              (csr_wen_id),        
    .csr_rdata_o            (csr_rdata_id),      
    .csr_waddr_o            (csr_waddr_id)   
);

id_to_ex(
    .clk_i                  (clk_i),
    .rst_n_i                (rst_n_i),
    input   wire [`HOLD_BUS]            hold_flag_i,                        

    // from ID   
    input   reg  [`REG_DATA_BUS]        op1_i,
    input   reg  [`REG_DATA_BUS]        op2_i,
    input   reg  [`REG_DATA_BUS]        offset_i,
    input   reg  [`INST_DATA_BUS]       inst_i,         
    input   reg  [`INST_ADDR_BUS]       inst_addr_i,        
    input   reg                         reg_wen_i,             
    input   reg  [`REG_ADDR_BUS]        reg_waddr_i,    
    input   reg                         csr_wen_i,        
    input   reg  [`CSR_DATA_BUS]        csr_rdata_i,      
    input   reg  [`CSR_ADDR_BUS]        csr_waddr_i,   

    // to EX     
    output  reg  [`REG_DATA_BUS]        op1_o,
    output  reg  [`REG_DATA_BUS]        op2_o,
    output  reg  [`REG_DATA_BUS]        offset_o,
    output  reg  [`INST_DATA_BUS]       inst_o,         
    output  reg  [`INST_ADDR_BUS]       inst_addr_o,        
    output  reg                         reg_wen_o,             
    output  reg  [`REG_ADDR_BUS]        reg_waddr_o,    
    output  reg                         csr_wen_o,        
    output  reg  [`CSR_DATA_BUS]        csr_rdata_o,      
    output  reg  [`CSR_ADDR_BUS]        csr_waddr_o       
);


endmodule