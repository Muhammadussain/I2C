module I2C_slave (
    
    input wire clk,
    input wire reset,
    input wire SDA,
    input wire SCL
    
);  
parameter slave_add = 7'b1001011 ;
parameter reg_add = 8'b10101011 ;

reg scl_counter=1'b0;
reg [2:0] state, nextstate;
reg [6:0] addreg;
reg [2:0] addcounter = 3'b000;

localparam IDLE = 3'b000;
localparam START =3'b001;
localparam ADDRESS = 3'b010;
    localparam r_w = 4'b0011;
    localparam ADD_ACK_NACK =4'B0100;
    localparam slave_reg =4'b0101 ;
    localparam reg_ACK_NACK=4'b0110 ;
    localparam DATA=4'b0111 ;
    localparam DATA_ACK_NACK=4'b1000 ;
    localparam STOP = 4'b1001; 


always @(posedge clk ) begin
    addcounter <= addcounter + 1;
    always @(posedge clk) begin
        scl_counter <= scl_counter + 1;
    end
    if(reset) begin
        state <= IDLE;
    end
    else begin
        state <= nextstate;
    end
end    

always @(*)begin
    case (state)
        IDLE: begin
            addcounter = 3'b000;
            if (SDA==1'b1 && SCL==1'b1) begin
                nextstate =START ;
             
        end
        end
        START: begin
                addcounter = 3'b000;
            if(SCL=0 && SDA =0 )
            nextstate = ADDRESS;
        end

        ADDRESS: begin
            addcounter=3'b000;
            if(scl_counter==1) begin
                addcounter = addcounter + 1;
                addreg = {addreg[6:0], SDA};
            end
            //addreg [0] = SDA;

            if (addcounter =3'b111) begin
                nextstate=slave_acknowledge;
            end
        end

       
        ADD_ACK_NACK:begin
            
            if(addreg ==slave_add)
        end
        DATA: begin
            if (SDA==1'b0 && SCL==1'b1) begin
                nextstate = STOP;
            end
            else begin
                nextstate = DATA;
            end
        end
        STOP: begin
            if (SDA==1'b1 && SCL==1'b0) begin
                nextstate = IDLE;
            end
            else begin
                nextstate = STOP;
            end
        end
    endcase
endmodule