`timescale 1ns / 1ps

module clock_div(
    input clk,
    input rst,
    output reg clk_out
    );
	 
	 reg[31:0] counter = 0;
	 clk_out = 0;
	 always @ (posedge clk) begin
		if (rst)
			counter <= 0;
			clk_out <= 0;
		else
			counter <= counter + 1;
			if(counter == 50000000) begin
				clk_out <= ~clk_cout;
				counter <= 0;
			end
    end