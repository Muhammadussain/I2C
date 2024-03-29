module I2C_master1 (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    input wire [6:0] ext_slave_addr,
    input wire [7:0] ext_reg_addr,
    input wire read_write,
    
    //  output wire  scl,
    //  output wire SDA_out,
     input wire SDA_in                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
);
     reg scl,SDA_out =1'b1;
     reg scl_counter=1'b0;


    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam ADDRESS = 3'b010;
    localparam r_w = 3'b011;
    localparam ADD_ACK_NACK =3'B100;
    localparam DATA =3'b101 ;
    localparam DATA_ACK_NACK=3'b110 ;
    localparam STOP = 3'b111;      

    reg [2:0] state, nextstate;
    reg [6:0] shiftreg = 7'b0;
    always @(negedge clk ) begin
        scl_counter <= scl_counter + 1;
    end
    always @(posedge clk) begin
        
        if (reset) begin
            state <= IDLE;
            
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
                    shiftreg =ext_slave_addr;
                end
            end
            START: begin
                SDA_out <= 1'b0;
                if(scl_counter==0)begin
                    scl <= 1'b0;
                    
                end
               
                nextstate = ADDRESS;
                
            end
            
            ADDRESS: begin

                 SDA_out <= shiftreg[7];
                    shiftreg = {shiftreg[6:0], 1'b0};
                nextstate = IDLE;
            end
        endcase
    end                                                                                                                                                                                                                                                                                                                                       
    
endmodule
