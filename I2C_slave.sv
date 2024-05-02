module I2C_slave (
    input wire clk,
    input wire reset,
    input wire SDA_i,
    output wire add_Ack_o,
    output wire reg_Ack_o,
    output wire data_Ack_o,   
    input wire SCL_i
);

parameter slave_add = 7'b1001011 ;
parameter reg_add = 8'b10101011 ;

reg scl_counter = 1'b0;
reg [2:0] state, nextstate;
reg [6:0] addreg;
reg [7:0] slavereg, datareg;
reg [3:0] slave_counter, data_counter;
reg [2:0] addcounter;

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam ADDRESS = 3'b010;
localparam r_w = 4'b0011;
localparam ADD_ACK_NACK = 4'B0100;
localparam slave_reg = 4'b0101 ;
localparam reg_ACK_NACK = 4'b0110 ;
localparam DATA = 4'b0111 ;
localparam DATA_ACK_NACK = 4'b1000 ;
localparam STOP = 4'b1001; 

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        state <= IDLE;
        scl_counter <= 1'b0;
        addcounter <= 3'b000;
    end else begin
        state <= nextstate;
    end
end    

always_ff @(posedge clk) begin
    scl_counter <= scl_counter + 1;
    addcounter <= addcounter + 1;
end

always_comb begin
    case (state)
        IDLE: begin
            addcounter = 3'b000;
            if (SDA_i == 1'b1 && SCL_i == 1'b1) begin
                nextstate = START;
            end else begin
                nextstate = IDLE;
            end
        end
        START: begin
            addcounter = 3'b000;
            if (SCL_i == 1'b0 && SDA_i == 1'b0) begin
                nextstate = ADDRESS;
            end else begin
                nextstate = START;
            end
        end
        ADDRESS: begin
            if (scl_counter == 1) begin
                addcounter = addcounter + 1;
                addreg = {addreg[6:0], SDA_i};
            end
            if (addcounter == 3'b111) begin
                nextstate = ADD_ACK_NACK;
            end else begin
                nextstate = ADDRESS;
            end
        end
        ADD_ACK_NACK: begin
            if (addreg == slave_add) begin
                add_Ack_o = 1'b1;
            end else begin
                add_Ack_o = 1'b0;
            end
            nextstate = slave_reg;
        end
        slave_reg: begin
            slave_counter = 3'b0000;
            if (scl_counter == 1) begin
                slave_counter = slave_counter + 1;
                slavereg = {slavereg[6:0], SDA_i};
            end
            if (slave_counter == 4'b1001) begin
                nextstate = reg_ACK_NACK;
            end else begin
                nextstate = slave_reg;
            end
        end
        reg_ACK_NACK: begin
            if (slavereg == reg_add) begin
                reg_Ack_o = 1'b1;
            end else begin
                reg_Ack_o = 1'b0;
            end
            nextstate = DATA;
        end
        DATA: begin
            data_counter = 3'b0000;
            if (scl_counter == 1) begin
                data_counter = data_counter + 1;
                datareg = {datareg[6:0], SDA_i};
            end
            if (data_counter == 4'b1001) begin
                nextstate = DATA_ACK_NACK;
            end else begin
                nextstate = DATA;
            end
        end
        DATA_ACK_NACK: begin
            data_Ack_o = 1'b1;
            nextstate = STOP;
        end
        STOP: begin
            if (SDA_i == 1'b1 && SCL_i == 1'b0) begin
                nextstate = IDLE;
            end else begin
                nextstate = STOP;
            end
        end
    endcase
end

endmodule
