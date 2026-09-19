// and_beh_intra.v -- behavioral: intra-assignment delay
module and_beh_intra (input a, b, output reg y);
  always @(a or b)
    y = #5 a & b;   // reads a, b NOW, updates y after 5
endmodule