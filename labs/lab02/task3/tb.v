// tb.v
module tb;

  // Inputs and outputs
  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer a, b;
  integer errors;

  reg exp_gt, exp_lt, exp_eq;

  // Instantiate DUT (instance name must stay DUT for the dump below)
  comp2 DUT (
    .A (t_a),
    .B (t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
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

    // Exhaustive: all 16 combinations of A and B
    for (a = 0; a < 4; a = a + 1) begin
      for (b = 0; b < 4; b = b + 1) begin
        t_a = a;
        t_b = b;
        #10;

        // Reference model, computed independently of the DUT
        exp_gt = (a > b);
        exp_lt = (a < b);
        exp_eq = (a == b);

        // Check each output against the expected value (!== catches x/z)
        if (t_gt !== exp_gt || t_lt !== exp_lt || t_eq !== exp_eq) begin
          $display("ERROR: A=%0d B=%0d | GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
                   t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end

        // Independent property check: exactly one output must be high
        if ((t_gt + t_lt + t_eq) !== 1) begin
          $display("ERROR: A=%0d B=%0d | outputs not one-hot (GT=%b LT=%b EQ=%b)",
                   t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
        end
      end
    end

    if (errors == 0) $display("PASS: all 16 combinations correct");
    else             $display("FAIL: %0d errors", errors);

    $finish;
  end

  initial
    $monitor($time, " A=%0d B=%0d | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule