// module tb_I2C_master;

//     reg clk;
//     wire SCL;

//     // Instantiate the I2C_master module
//     I2C_master u_i2c (
//         .clk(clk),
//         .SCL(SCL)
//     );

//     // Clock generation
//     initial begin
//         clk = 1;
//         forever #5 clk = ~clk;
//     end

//     // Testbench stimulus
//     initial begin
//         // Open VCD file
//         $dumpfile("tb_I2C_master.vcd");
//         $dumpvars(0, tb_I2C_master);
       
//         // Apply stimulus
//         #10; // Wait for a few cycles to observe the initial state

//         // Observe SCL toggling for some cycles
//         #200; // Observe for 200 cycles
//      $finish;
//         // End the simulation
//         $stop;
//     end

// endmodule
module tb_I2C_master;

  reg clk;
  reg rst;
  reg en;
  reg [7:0] sda_in;
  wire sda_out;
  
  // Instantiate the I2C_master module
  I2C_master u_i2c (
    .clk(clk),
    .SCL(),
    .ack(),
    .rst(rst),
    .sda_in(sda_in),
    .en(en),
    .sda_out(sda_out)
  );

  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  // Testbench stimulus
  initial begin
    // Open VCD file
    $dumpfile("tb_I2C_master.vcd");
    $dumpvars(0, tb_I2C_master);
        en=1'b1;
        sda_in = 8'b10101010;
    // Apply reset
    rst = 1;
    #10 rst = 0;

    // Wait for some time
    #20;

    // Enable I2C master
    en = 1'b0;

    // Start I2C communication
   // sda_in = 8'b10101010; // Replace with your specific data

    // Continue simulation for a while
    #200;
    $finish;
    // End the simulation
    $stop;
  end

endmodule
