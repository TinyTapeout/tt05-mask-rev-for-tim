`default_nettype none `timescale 1ns / 1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // wire up the inputs and outputs
  reg clk;
  reg rst_n;
  reg ena;
  reg [2:0] index;
  reg [31:0] mask_rev;
  
  wire [7:0] ui_in;
  wire [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  assign ui_in  = {5'b0, index};
  assign uio_in = 8'b0;

  tt_um_openframe_mask_rev dut (
      // include power ports for the Gate Level test
`ifdef GL_TEST
      .VPWR    (1'b1),
      .VGND    (1'b0),
`endif
      .mask_rev(mask_rev),  // Openframe mask revision number
      .ui_in   (ui_in),     // Dedicated inputs
      .uo_out  (uo_out),    // Dedicated outputs
      .uio_in  (uio_in),    // IOs: Input path
      .uio_out (uio_out),   // IOs: Output path
      .uio_oe  (uio_oe),    // IOs: Enable path (active high: 0=input, 1=output)
      .ena     (ena),       // enable - goes high when design is selected
      .clk     (clk),       // clock
      .rst_n   (rst_n)      // not reset
  );

endmodule