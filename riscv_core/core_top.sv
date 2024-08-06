module core (
    .clk_i,
    .rst_n_i,

    
);


pc_reg      u_pc_reg (
    .clk_i              (clk_i),
    .rst_n_i            (rst_n_i),
    .hold_flag_i        (ctrl_hold_flag),
    .jump_flag_i        (ctrl_jump_flag),
    .jump_addr_i        (ctrl_jump_addr),
    .pc_addr_o          (pc_addr_o)
);

inst_fetch  u_if(
    .clk_i              (clk_i),
    .rst_n_i            (rst_n_i),
    .hold_flag_i        (ctrl_hold_flag),       
    .interrupt_flag_i   (ctrl_int_flag),  
    .interrupt_flag_o   (int_flag_o),  
    .inst_i             (inst_i),            
    .inst_addr_i        (inst_addr_i),       
    .inst_o             (inst),            
    .inst_addr_o        (inst_addr)        
);

endmodule