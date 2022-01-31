`timescale 1ms / 1ms

module Traffic_Light_Controller_tb;
	//inputs
	reg clk;
	reg walk_button;
	reg sensor;
	reg rst;
	
	//outputs
	wire main_green;
	wire main_yellow;
	wire main_red;
	wire side_green;
	wire side_yellow;
	wire side_red;
	wire walk_lamp;

	Traffic_Light_Controller uut1(
		.clk(clk),
		.walk_button(walk_button),
		.sensor(sensor),
		.rst(rst),
		.main_green(main_green),
		.main_yellow(main_yellow),
		.main_red(main_red),
		.side_green(side_green),
		.side_yellow(side_yellow),
		.side_red(side_red),
		.walk_lamp(walk_lamp)
	);

	always #500 clk = ~clk;

	initial begin
		//let run for regular cycle with initial inputs
		clk = 0;
		walk_button = 0;
		sensor = 0;
		#27000

		//introduce inputs
		walk_button = 1;
		sensor = 1;
		#2000
		
		//set back to normal
		walk_button = 0;
		sensor = 0;
		#12000

		//set sensor = 1
		sensor = 1;
		#2000

		//set sensor = 0
		sensor = 0;
		#5000

		//set walk_button = 1
		walk_button = 1;
		#2000

		//back to normal
		walk_button = 0;
		#15000
		rst = 1;
		#1000
		rst = 0;
	end
endmodule