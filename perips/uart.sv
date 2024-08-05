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
localparamq UART_TX_REG     = 4'h0x0C;
localparamq UART_RX_REG     = 4'h0x10;

reg [31:0]  uart_ctrl;
reg [31:0]  uart_status;
reg [31:0]  uart_baud;
reg [31:0]  uart_tx_reg;
reg [31:0]  uart_rx_reg;

always_ff @( posedge clk_i ) begin
    if (!rst_n_i) begin
        uart_ctrl       <= 32'h0;
        uart_status     <= 32'h0;
        uart_baud       <= BAUD_CNT;
        uart_rx_reg     <= 32'h0;
        uart_tx_reg     <= 32'h0;
        tx_data_valid   <= 1'b0;
    end
    else begin
        if (wr_en_i) begin
            case (wr_addr_i[7:0])
                UART_CTRL: begin
                    uart_ctrl       <= wr_data_i;
                    uart_status     <= 32'h0;
                    uart_baud       <= BAUD_CNT;
                    uart_rx_reg     <= 32'h0;
                    uart_tx_reg     <= 32'h0;
                    tx_data_valid   <= 1'b0;
                end
                
                UART_STATUS: begin
                    uart_ctrl       <= 32'h0;
                    uart_status[1]  <= wr_data_i[1];
                    uart_baud       <= BAUD_CNT;
                    uart_rx_reg     <= 32'h0;
                    uart_tx_reg     <= 32'h0;
                    tx_data_valid   <= 1'b0;
                end

                UART_BAUD: begin
                    uart_ctrl       <= 32'h0;
                    uart_status     <= 32'h0;
                    uart_baud       <= wr_data_i;
                    uart_rx_reg     <= 32'h0;
                    uart_tx_reg     <= 32'h0;
                    tx_data_valid   <= 1'b0;
                end



                UART_TX_REG: begin
                    if (uart_ctrl[0] == 1'b1 && uart_status[0] == 1'b0) begin
                        tx_data <= wr_data_i[7:0];
                        uart_status[0] <= 1'b1;
                        tx_data_valid <= 1'b1;
                    end
                end
            endcase
            end else begin
                tx_data_valid <= 1'b0;
                if (tx_data_ready == 1'b1) begin
                    uart_status[0] <= 1'b0;
                end
                if (uart_ctrl[1] == 1'b1) begin
                    if (rx_over == 1'b1) begin
                        uart_status[1] <= 1'b1;
                        uart_rx <= {24'h0, rx_data};
                    end
    end
end

endmodule