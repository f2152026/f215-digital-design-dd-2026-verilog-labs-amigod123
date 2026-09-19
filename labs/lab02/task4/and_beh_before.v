// and_beh_before.v -- behavioral: delay BEFORE the assignment
module and_beh_before (input a, b, output reg y);
  always @(a or b) begin
    #5;
    y = a & b;      // reads a, b AFTER the delay
  end
endmodule