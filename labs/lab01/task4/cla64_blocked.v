// cla64_blocked.v
// A practical 64-bit adder: sixteen 4-bit CLA blocks (cla4.v), chained by
// feeding block k's carry-out into block (k+1)'s carry-in. Instantiated
// with a generate-for loop since every block is structurally identical --
// only the bit-slice and which carry wire feeds in/out changes.

module cla64_blocked(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [16:0] c;   // c[0] = cin, c[1]..c[15] = inter-block carries, c[16] = cout
  assign c[0] = cin;

  genvar k;
  generate
    for (k = 0; k < 16; k = k + 1) begin : gen_block
      cla4 block (
        .a    (a[k*4+3 : k*4]),
        .b    (b[k*4+3 : k*4]),
        .cin  (c[k]),
        .sum  (sum[k*4+3 : k*4]),
        .cout (c[k+1])
      );
    end
  endgenerate

  assign cout = c[16];

endmodule