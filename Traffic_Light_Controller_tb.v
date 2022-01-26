`timescale 1s / 1ms

module Traffic_Light_Controller_tb;
	//inputs
	reg clk;
	reg walk_button;
	reg sensor;
	
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
		.main_green(main_green),
		.main_yellow(main_yellow),
		.main_red(main_red),
		.side_green(side_green),
		.side_yellow(side_yellow),
		.side_red(side_red),
		.walk_lamp(walk_lamp)
	);

	always #0.5 clk = ~clk;

	initial begin
		//let run for regular cycle with initial inputs
		walk_button = 0;
		sensor = 0;
		#33

		//introduce inputs
		walk_button = 1;
		sensor = 1;
		#2
		
		//set back to normal
		walk_button = 0;
		sensor = 0;
		#9

		//set sensor = 1
		sensor = 1;
		#2

		//set sensor = 0
		sensor = 0;
		#5

		//set walk_button = 1
		walk_button = 1;
		#2

		//back to normal
		walk_button = 0;
		#5
	end
endmodule