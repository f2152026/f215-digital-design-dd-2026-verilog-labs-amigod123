// and_df.v -- dataflow: continuous assignment with a #5 delay
module and_df (input a, b, output y);
  assign #5 y = a & b;
endmodule