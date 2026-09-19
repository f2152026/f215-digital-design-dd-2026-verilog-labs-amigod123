// tb.v
// Starter testbench template -- YOU complete this file.

module tb;

  // Testbench drives DUT inputs, so they are variables.
  reg t_i0, t_i1, t_s;

  // DUT drives its output, so it is a net.
  wire t_y;


  // DUT instantiation
  mux_df DUT (
    .I0(t_i0),
    .I1(t_i1),
    .S (t_s),
    .Y (t_y)
  );


  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end


  initial begin
    // Apply all 8 combinations, 5 time units apart.
    t_i0 = 0; t_i1 = 0; t_s = 0;
    #5  t_i0 = 0; t_i1 = 0; t_s = 1;
    #5  t_i0 = 0; t_i1 = 1; t_s = 0;
    #5  t_i0 = 0; t_i1 = 1; t_s = 1;
    #5  t_i0 = 1; t_i1 = 0; t_s = 0;
    #5  t_i0 = 1; t_i1 = 0; t_s = 1;
    #5  t_i0 = 1; t_i1 = 1; t_s = 0;
    #5  t_i0 = 1; t_i1 = 1; t_s = 1;

    $finish;
  end


  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule