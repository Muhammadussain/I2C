`timescale 1ns/1ns

module I2C_master1_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    reg [7:0] data_in;
    reg [6:0] ext_slave_addr;
    reg [7:0] ext_reg_addr;
    reg add_Ack;
    reg reg_Ack;
    reg data_Ack;
    reg read_write;
    reg SDA_in;
    
    // Outputs
    wire SDA_out;
    wire scl;

    // Instantiate the I2c_master1 module
    I2C_master1 u_I2C_master1 (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .data_in(data_in),
        .ext_slave_addr(ext_slave_addr),
        .ext_reg_addr(ext_reg_addr),
    //    .ext_data(ext_data),   
        .read_write(read_write),
        .add_Ack(add_Ack),
        .reg_Ack(reg_Ack),
        .data_Ack(data_Ack),
        //.SDA_out(SDA_out), // commented out to prevent redeclaration error
        //.scl(scl),         // commented out to prevent redeclaration error
        .SDA_in(SDA_in)
    );

   initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end
    // Dumping waveform
    initial begin
        $dumpfile("I2C_master1.vcd");
        $dumpvars(0, I2C_master1_tb);
        
        // Stimulus generation
        // Initialize inputs
        clk = 1;
        ext_slave_addr=7'b1101001;
        reset = 1'b1;
        enable = 1'b1;
        add_Ack = 1'b1;
        reg_Ack = 1'b1;
        data_Ack = 1'b1;
        data_in = 8'b0;
        ext_slave_addr = 7'b0;
        ext_reg_addr = 8'b0;
        read_write = 1'b0;
        SDA_in = 1'b0;

        // Reset
        #10 reset = 1'b0;

        // Enable
       // #10 enable = 1'b1;

        // Test scenario
        // You can modify this part to simulate different test scenarios
        // Here, we are just asserting enable and observing the output
        // You should expand this to cover various scenarios of your design

        // Scenario 1: Enable asserted
        #100;
        $display("Scenario 1: Enable asserted");
        //enable = 1'b0;
        // Add more test scenarios here...

        // End simulation
        #100;
        $finish;
    end

endmodule
