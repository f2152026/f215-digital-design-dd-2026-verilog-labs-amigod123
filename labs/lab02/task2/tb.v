// tb.v
module tb;

  localparam WIDTH = 8;
  localparam DEPTH = 4;

  // Inputs and outputs
  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;

  integer i;
  integer errors;

  // Instantiate DUT (instance name must stay DUT for the dump below)
  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .sel (t_sel),
    .dout(t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    t_sel  = 0;
    #1;  // let the DUT's initial block fill the ROM before we read it

    // Sweep forward through every address
    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel = i;
      #10;
      if (t_dout !== i * i) begin
        $display("ERROR: sel=%0d dout=%0d expected=%0d", t_sel, t_dout, i * i);
        errors = errors + 1;
      end
    end

    // Sweep backward to check dout tracks sel in both directions
    for (i = DEPTH - 1; i >= 0; i = i - 1) begin
      t_sel = i;
      #10;
      if (t_dout !== i * i) begin
        $display("ERROR: sel=%0d dout=%0d expected=%0d", t_sel, t_dout, i * i);
        errors = errors + 1;
      end
    end

    if (errors == 0) $display("PASS: all lookups correct");
    else             $display("FAIL: %0d errors", errors);

    #10 $finish;
  end

  initial
    $monitor($time, " SEL=%0d | DOUT=%0d (%b)", t_sel, t_dout, t_dout);

endmodule