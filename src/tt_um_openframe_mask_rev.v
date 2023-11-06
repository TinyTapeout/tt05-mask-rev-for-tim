`default_nettype none

module tt_um_openframe_mask_rev (
    input  wire [31:0]mask_rev, // Openframe mask revision number
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [6:0] led_out;
    assign uo_out = {1'b0, led_out};

    // put bottom 8 bits of mask revision out on the bidirectional gpio
    assign uio_oe = 8'b11111111;
    assign uio_out = mask_rev[7:0];
    
    wire [2:0] index = ui_in[2:0];
    wire [4:0] bit_index = {index, 2'b00};
    wire [3:0] digit = mask_rev[bit_index+:4];

    // instantiate segment display
    seg7 seg7(
      .counter(digit), 
      .segments(led_out)
    );

endmodule
