module I2C_master1 (
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [7:0] data_in,
    input logic [6:0] ext_slave_addr,
    input logic [7:0] ext_reg_addr,
    input logic read_write,
    input logic add_Ack,
    input logic reg_Ack,
    input logic data_Ack,

    input logic SDA_in
);
    logic scl, SDA_out;
    logic scl_counter = 1'b0;

    localparam IDLE = 4'b0000;
    localparam START = 4'b0001;
    localparam ADDRESS = 4'b0010;
    localparam r_w = 4'b0011;
    localparam ADD_ACK_NACK = 4'b0100;
    localparam slave_reg = 4'b0101;
    localparam reg_ACK_NACK = 4'b0110;
    localparam DATA = 4'b0111;
    localparam DATA_ACK_NACK = 4'b1000;
    localparam STOP = 4'b1001;

    logic [3:0] state, nextstate;
    logic [6:0] shiftreg;
    logic [7:0] shiftreg1, shiftreg2;
    logic [3:0] reg_add_counter, data_add_counter = 4'b000;
    logic [2:0] addcounter = 3'b000;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            // shiftreg = ext_slave_addr;
            // shiftreg1 = ext_reg_addr;
        end else begin
            state <= nextstate;
        end
    end

    always_ff @(posedge clk) begin
        scl_counter <= scl_counter + 1;
    end

    always_comb begin
        case (state)
            IDLE: begin
                if (enable) begin
                    scl = 1'b1;
                    SDA_out = 1'b1;
                    nextstate = START;
                    addcounter = 3'b000;
                end
            end
            START: begin
                SDA_out = 1'b0;
                shiftreg = ext_slave_addr;
                shiftreg1 = ext_reg_addr;
                shiftreg2 = data_in;
                if (scl_counter == 0) begin
                    scl = 1'b0;
                end
                addcounter = 3'b000;
                nextstate = ADDRESS;
            end
            ADDRESS: begin
                scl = scl_counter;
                if (scl_counter == 1) begin
                    addcounter = addcounter + 1;
                    SDA_out = shiftreg[7];
                    shiftreg = {shiftreg[6:0], 1'b0};
                end
                if (addcounter == 3'b111) begin
                    nextstate = r_w;
                    addcounter = 3'b000;
                end
            end
            r_w: begin
                scl = scl_counter;
                nextstate = ADD_ACK_NACK;
            end
            ADD_ACK_NACK: begin
                scl = scl_counter;
                if (add_Ack) begin
                    nextstate = slave_reg;
                end
                reg_add_counter = 3'b000;
            end
            slave_reg: begin
                scl = scl_counter;
                if (scl_counter == 0) begin
                    reg_add_counter = reg_add_counter + 1;
                    SDA_out = shiftreg1[7];
                    shiftreg1 = {shiftreg1[6:0], 1'b0};
                end
                if (reg_add_counter == 4'b1001) begin
                    nextstate = reg_ACK_NACK;
                    reg_add_counter = 3'b000;
                end
            end
            reg_ACK_NACK: begin
                scl = scl_counter;
                if (reg_Ack) begin
                    nextstate = DATA;
                end
            end
            DATA: begin
                scl = scl_counter;
                if (scl_counter == 0) begin
                    data_add_counter = data_add_counter + 1;
                    if (read_write) begin
                        SDA_out = shiftreg2[7];
                        shiftreg2 = {shiftreg2[6:0], 1'b0};
                    end
                    if (data_add_counter == 3'b111) begin
                        nextstate = DATA_ACK_NACK;
                        data_add_counter = 3'b000;
                    end
                end
            end
            DATA_ACK_NACK: begin
                scl = scl_counter;
                if (data_Ack) begin
                    nextstate = STOP;
                    scl = 1'b0;
                    SDA_out = 1'b0;
                end
            end
            STOP: begin
                scl = 1'b1;
                if (scl_counter == 0) begin
                    SDA_out = 1'b1;
                end
            end
        endcase
    end
endmodule
