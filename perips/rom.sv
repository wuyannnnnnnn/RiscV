`include "../core/defines.v"

module rom (
    input   wire                        clk_i,
    input   wire                        rst_n_i,
    
    input   wire                        wr_en_i,    // write enable
    input   wire [`INST_ADDR_BUS]       wr_addr_i,  // write address
    input   wire [`INST_DATA_BUS]       wr_data_i,  // write data
    
    input   wire [`INST_ADDR_BUS]       rd_addr_i,  // read address
    output  reg  [`INST_DATA_BUS]       rd_data_o,  // read data
    
    input   wire [`INST_ADDR_BUS]       pc_addr_i,  // instruction read address
    output  reg  [`INST_DATA_BUS]       inst_o      // instruction
);

reg [`INST_ADDR_BUS]    rd_addr_reg;
reg [`INST_ADDR_BUS]    pc_addr_reg;
reg [`INST_DATA_BUS]    _rom [0:`ROM_DEPTH - 1];

always_ff @( posedge clk_i ) begin
    if (wr_en_i) begin
        _rom[wr_addr_i[31:2]]   <= wr_data_i;
        rd_addr_reg             <= rd_addr_reg;
        pc_addr_reg             <= pc_addr_reg;
    end
    else begin
        _rom                    <= _rom;
        rd_addr_reg             <= rd_addr_i;
        pc_addr_reg             <= pc_addr_i;
    end
end


always_comb begin 
    if (!rst_n_i) begin
        rd_data_o   = 32'b0;
        inst_o      = 32'b0;
    end
    else begin
        rd_data_o   = _rom[rd_addr_reg[31:2]];
        inst_o      = _rom[pc_addr_reg[31:2]];
    end
end
    
endmodule