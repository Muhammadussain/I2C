// module I2C_master (
//     input wire clk,
//     output reg SCL,
  
//   input wire ack,
//   input wire rst,
//   input wire [7:0] sda_in,
//   input wire en, 
//   output reg sda_out
// );
//     reg [1:0] SCL_counter = 2'b00;

//   localparam IDLE = 2'b00;
//   localparam START = 2'b01;
//   localparam ADDRESS = 2'b10;
//   localparam STOP = 2'b11;

//   reg [1:0] state;
//   reg [1:0] nextstate;
//   reg [7:0] shiftreg = 8'd0;

// reg [3:0] datacounter= 4'b0;



//     always @(posedge clk) begin
        
//         SCL=1'B1;
//         SCL_counter = SCL_counter + 1'b1;

//         if (SCL_counter == 2'b01) begin
//             SCL <= 1'b0;
//         end
//         else 
//             SCL_counter <= 1'b0;
//         end





// always @(posedge clk) begin
//     if (rst) begin
//       state <= IDLE;
//     end
//     else begin
//      state <= nextstate;
    
//      if(SCL)begin
//    datacounter <= datacounter + 1;

//     end
//     end
// end

//  always @(*) begin

//     case (state)
//       IDLE: begin
//         datacounter =1'b0;
//         if (en) begin
//           nextstate = START;
//         end
//       end

//       START: begin
//            sda_out=1'b0;
//            datacounter =1'b0;
         
//            shiftreg=sda_in;
//           nextstate = ADDRESS;

//       end   

//       ADDRESS: begin
//        if (datacounter) begin
//          sda_out <= shiftreg[7];
//          shiftreg = {shiftreg[6:0],1'b0};
//        end
//          if (datacounter == 4'b1000) begin
//           nextstate = STOP;
//           datacounter =0;
//         end
//       end

//       STOP: begin
        
//           nextstate = IDLE;
        
//   end
 
//     endcase
//  end
// endmodule
module I2C_master (
    input wire clk,
    output reg SCL,
  
    input wire ack,
    input wire rst,
    input wire [7:0] sda_in,
    input wire en, 
    output reg sda_out
);

    reg [1:0] SCL_counter = 2'b00;
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam ADDRESS = 2'b10;
    localparam STOP = 2'b11;

    reg [1:0] state;
    reg [1:0] nextstate;
    reg [7:0] shiftreg = 8'd0;
    reg [3:0] datacounter = 4'b0;

    always @(posedge clk) begin
        SCL = 1'B1;
        SCL_counter = SCL_counter + 1'b1;

        if (SCL_counter == 2'b01) begin
            SCL <= 1'b0;
        end
        else 
            SCL_counter <= 1'b0;
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end
        else begin
            state <= nextstate;
         

        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                datacounter = 4'b0;
                if (en) begin
                    nextstate = START;
                end
            end

            START: begin
                sda_out = 1'b0;
                datacounter = 4'b0;
                shiftreg = sda_in;
                nextstate = ADDRESS;
            end   

            ADDRESS: begin
                // if (SCL==1) begin
                //     datacounter = datacounter + 1;
                // end
                if ( SCL == 0 ) begin
                    sda_out <= shiftreg[7];
                    shiftreg = {shiftreg[6:0], 1'b0};
                    datacounter= datacounter+1;
                
                if (datacounter == 4'b1001) begin
                    nextstate = STOP;
                    datacounter = 4'b0;
                end
            end
            end

            STOP: begin
                nextstate = IDLE;
            end
        endcase
    end
endmodule
