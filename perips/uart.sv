`include "../core/defines.v"

module uart (
    input   wire                        clk_i,
    input   wire                        rst_n_i,

    input   wire                        uart_rx,
    output  reg                         uart_tx,

    input   wire                        wr_en_i,
    input   wire [`INST_ADDR_BUS]       wr_addr_i, 
    input   wire [`INST_DATA_BUS]       wr_wr_data_i, 
    input   wire [`INST_ADDR_BUS]       rd_addr_i, 
    output  reg  [`INST_DATA_BUS]       rd_data_o
);

localparam  BAUD_CNT        = `CLK_FREQ / `UART_BPS;
localparamq UART_CTRL       = 4'h0x00;
localparamq UART_STATUS     = 4'h0x04;
localparamq UART_BAUD       = 4'h0x08;
localparamq UART_TX         = 4'h0x0C;
localparamq UART_RX         = 4'h0x10;

reg [31:0]  uart_ctrl;
reg [31:0]  uart_status;
reg [31:0]  uart_baud;
reg [31:0]  uart_tx_reg;
reg [31:0]  uart_rx_reg;
reg         tx_data_valid;
//reg [7:0]   tx_byte_date;
reg [7:0]   rx_byte_date;

// write regs
always_ff @( posedge clk_i ) begin
    if (!rst_n_i) begin
        uart_ctrl       <= 32'h0;
        uart_status     <= 32'h0;
        uart_baud       <= BAUD_CNT;
        uart_tx_reg     <= 32'h0;
        tx_data_valid   <= 1'b0;
    end
    else begin
        if (wr_en_i) begin
            priority case (wr_addr_i[7:0])
                UART_CTRL: begin
                    uart_ctrl       <= wr_data_i;
                end
                
                UART_STATUS: begin
                    uart_status[1]  <= wr_data_i[1];
                end

                UART_BAUD: begin
                    uart_baud       <= wr_data_i;
                end

                UART_TX: begin
                    if (uart_ctrl[0] && uart_status[0]) begin
                        uart_tx_reg     <= wr_data_i;
                        uart_status[0]  <= 1'b1;
                        tx_data_valid   <= 1'b1;
                    end
                end

                default: begin
                    uart_ctrl       <= uart_ctrl;
                    uart_status     <= uart_status;
                    uart_baud       <= uart_baud;
                    uart_tx_reg     <= uart_tx_reg;
                    tx_data_valid   <= tx_data_valid;
                end
            endcase
        end 
        else begin
            tx_data_valid   <= 1'b0;
            uart_status[0]  <= (tx_data_ready) ? 1'b0 : uart_status[0];
            uart_status[1]  <= (uart_ctrl[1] & rx_over) ? 1'b1 : uart_status[1];
            uart_rx_reg     <= (uart_ctrl[1] & rx_over) ? {24'h0, rx_byte_data} : uart_rx_reg;
        end
    end
end

// read regs
always_comb begin 
    if (!rst_n_i) begin
        rd_data_o = 32'b0;
    end
end

endmodule