module i2c_master (
    input wire clk
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    input wire [6:0] ext_slave_addr,
    input wire [7:0] ext_reg_addr,
    input wire read_write,
     output wire  scl,
     output wire SDA_out,
     input wire SDA_in,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
);
    
    localparam IDLE = 4'b0000;
    localparam START = 4'b0001;
    localparam ADDRESS = 4'b0010;
                                                                                                                                                                                                                                                                                                                                                         
    
endmodule