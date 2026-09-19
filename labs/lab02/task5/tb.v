// tb.v
module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer a, b, op;
  integer errors;
  reg [3:0] expected;

  // Instantiate DUT (instance name must stay DUT for the dump below)
  alu DUT (
    .a     (t_a),
    .b     (t_b),
    .op    (t_op),
    .result(t_result)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply one vector, wait, and compare against the reference model
  task apply_and_check(input [3:0] va, input [3:0] vb, input vop);
    begin
      t_a  = va;
      t_b  = vb;
      t_op = vop;
      #10;
      expected = vop ? (va - vb) : (va + vb);   // 4-bit wraparound
      if (t_result !== expected) begin
        $display("ERROR: a=%0d b=%0d op=%0d | result=%0d expected=%0d",
                 va, vb, vop, t_result, expected);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    // Warm-up: make sure the DUT's always block has seen an event
    t_a = 0; t_b = 0; t_op = 0;
    #1;
    t_a = 1; t_b = 1;
    #5;

    // Pass A: op toggles 0 -> 1 with a and b held constant.
    // Exposes the sensitivity-list bug (op change alone must update result).
    for (a = 0; a < 16; a = a + 1)
      for (b = 0; b < 16; b = b + 1)
        for (op = 0; op < 2; op = op + 1)
          apply_and_check(a, b, op);

    // Pass B: op held fixed, a and b sweep.
    // Exposes the blocking/non-blocking bug (a/b change while op=1 must
    // give the right answer in the same evaluation, not a stale one).
    for (op = 0; op < 2; op = op + 1)
      for (a = 0; a < 16; a = a + 1)
        for (b = 0; b < 16; b = b + 1)
          apply_and_check(a, b, op);

    if (errors == 0) $display("PASS: all vectors correct");
    else             $display("FAIL: %0d errors", errors);

    $finish;
  end

endmodule