module I2C_master1 (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    input wire [6:0] ext_slave_addr,
    input wire [7:0] ext_reg_addr,
    input wire read_write,
    input wire add_Ack,
    input wire reg_Ack,
    input wire data_Ack,

    //  output wire  scl,
    //  output wire SDA_out,
     input wire SDA_in                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
);
     reg scl,SDA_out =1'b1;
     reg scl_counter=1'b0;


    localparam IDLE = 4'b0000;
    localparam START = 4'b0001;
    localparam ADDRESS = 4'b0010;
    localparam r_w = 4'b0011;
    localparam ADD_ACK_NACK =4'B0100;
    localparam slave_reg =4'b0101 ;
    localparam reg_ACK_NACK=4'b0110 ;
    localparam DATA=4'b0111 ;
    localparam DATA_ACK_NACK=4'b1000 ;
    localparam STOP = 4'b1001;      

    reg [3:0] state, nextstate;
    reg [6:0] shiftreg/*shiftreg1,*/ ;
    reg [7:0] shiftreg1,shiftreg2 ;
    reg [3:0] reg_add_counter,data_add_counter=4'b000;
    reg [2:0] addcounter/*,data_add_counter*/ = 3'b000;

    always @(negedge clk ) begin
        scl_counter <= scl_counter + 1;
    end
    always @(posedge clk) begin
    
        if (reset) begin
            state <= IDLE;
            //  shiftreg =ext_slave_addr;
            //  shiftreg1=ext_reg_addr;
        end
        else begin
            state <= nextstate;


        end
    end    
    always @(*)begin
        case (state)
            IDLE: begin
                if (enable) begin
                    scl=1'b1;
                    SDA_out=1'b1;
                    nextstate = START;
                   addcounter = 3'b000;

                end
                
                 
            end
            START: begin
                SDA_out <= 1'b0;
                  shiftreg =ext_slave_addr;
                  shiftreg1=ext_reg_addr;
                  shiftreg2=data_in;
                if(scl_counter==0)begin
                    scl <= 1'b0;
                    
                end
               addcounter=3'b000;
                nextstate = ADDRESS;
                
            end
            
            ADDRESS: begin
                scl =scl_counter;
                if(scl_counter==1) begin
                    addcounter = addcounter + 1;
                    SDA_out <= shiftreg[7];
                    shiftreg = {shiftreg[6:0], 1'b0};
                end

                //  SDA_out <= shiftreg[7];
                //     shiftreg = {shiftreg[6:0], 1'b0};
                // nextstate = IDLE;

                 if (addcounter == 3'b111) begin
                    // nextstate = r_w;
                    nextstate = r_w;
                    addcounter = 3'b000;
                end
                
            end
            r_w: begin
                 scl =scl_counter;
                //if (read_write) begin
                   nextstate=ADD_ACK_NACK; 
                end
            
    
             

            ADD_ACK_NACK: begin
                 scl =scl_counter;
                if (add_Ack) begin
                    nextstate = slave_reg;
                   
                end
                else begin
                    nextstate = ADDRESS;
                end
                reg_add_counter = 3'b000;
            end


            slave_reg:begin
                 scl =scl_counter;
              if(scl_counter==0) begin
                    reg_add_counter = reg_add_counter + 1;

                    SDA_out <= shiftreg1[7];
                    shiftreg1 = {shiftreg1[6:0], 1'b0};
                end

                //  SDA_out <= shiftreg1[7];
                //     shiftreg1 = {shiftreg1[6:0], 1'b0};

                 if (reg_add_counter == 4'b1001) begin
                    nextstate = reg_ACK_NACK;
                    reg_add_counter = 3'b000;
                end
            end
             reg_ACK_NACK: begin
                 scl =scl_counter;
                if (reg_Ack) begin
                    nextstate = DATA;
                   
                end
             end
            DATA: begin
                 scl =scl_counter;
                if(scl_counter==0) begin
                    data_add_counter = data_add_counter + 1;
                    if (read_write) begin
                    SDA_out <= shiftreg2[7];
                    shiftreg2 = {shiftreg2[6:0], 1'b0};
                end
                // SDA_out <= shiftreg2[7];
                //     shiftreg2 = {shiftreg2[6:0], 1'b0};
             
                 if (data_add_counter == 3'b111) begin
                    nextstate = DATA_ACK_NACK;
                    data_add_counter = 3'b000;
                end
                
            end
            end
            DATA_ACK_NACK: begin
                 scl =scl_counter;
                if (data_Ack) begin
                    nextstate = STOP;
                   scl=1'b0;
                   SDA_out=1'b0;
                end
            end
             STOP: begin    
                scl <= 1'b1;
                 
                if(scl_counter==0)begin
                    SDA_out <= 1'b1;
                    
                end
             end
        endcase
    end                                                                                                                                                                                                                                                                                                                                       
    
endmodule

// iverilog -o I2C_master1.out I2C_master1.v I2C_master1_tb.v
// vvp I2C_master1.out
// gtkwave I2C_master1.vcd