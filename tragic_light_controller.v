`timescale 1ms / 1ms

module Traffic_Light_Controller(
    input clk,
    input walk_button,
    input sensor,
	input rst,
    output reg main_green,
    output reg main_yellow,
    output reg main_red,
    output reg side_green,
    output reg side_yellow,
    output reg side_red,
    output reg walk_lamp
);

// States Declaration: 7 States Total
parameter MAIN_GREEN = 3'b000;
parameter MAIN_STAY_GREEN = 3'b001;
parameter MAIN_YELLOW = 3'b010;
parameter WALK = 3'b011;
parameter SIDE_GREEN = 3'b100;
parameter SIDE_STAY_GREEN = 3'b101;
parameter SIDE_YELLOW = 3'b110;

reg [2:0] curr_state = MAIN_GREEN;
reg [2:0] next_state;
reg [3:0] counter = 0;
reg walk_reg = 0;
wire new_clock;

clock_div clk_div(clk, rst, new_clk);

// Counter: For now assume one cycle of clk is 1 second
always @(posedge new_clk or rst) begin
	if (rst) begin
		curr_state <= MAIN_GREEN;
		counter <= 0;
	end
	else begin
		counter <= counter + 1;
		if (curr_state != next_state) begin
			curr_state <= next_state;
			counter <= 0;
		end
	end
end

always @(walk_button) begin
    // Set walk register
    if (~walk_reg) begin
       walk_reg <= walk_button;
    end
end

// Next State
always @(*) begin
    case (curr_state)
        MAIN_GREEN: begin
            if (counter == 5 && sensor) 
                next_state <= MAIN_STAY_GREEN;
            else if (counter == 11)
                next_state <= MAIN_YELLOW;
            else 
                next_state <= MAIN_GREEN;
        end
        MAIN_STAY_GREEN: begin
            if (counter == 2)
                next_state <= MAIN_YELLOW;
            else 
                next_state <= MAIN_STAY_GREEN;
        end
        MAIN_YELLOW: begin
            if (counter == 1 && walk_reg) begin
                next_state <= WALK;
            end
            else if (counter == 1 && ~walk_reg)
                next_state <= SIDE_GREEN;
            else
                next_state <= MAIN_YELLOW;
        end
        WALK: begin
		      walk_reg <= 0;
            if (counter == 2)
                next_state <= SIDE_GREEN;
            else
                next_state <= WALK;
        end
        SIDE_GREEN: begin
            if (counter == 5 && sensor)
                next_state <= SIDE_STAY_GREEN;
            else if (counter == 5 && ~sensor)
                next_state <= SIDE_YELLOW;
            else
                next_state <= SIDE_GREEN;
        end
        SIDE_STAY_GREEN: begin
            if (counter == 2)
                next_state <= SIDE_YELLOW;
            else
                next_state <= SIDE_STAY_GREEN;
        end
        SIDE_YELLOW: begin
            if (counter == 1)
                next_state <= MAIN_GREEN;
            else 
                next_state <= SIDE_YELLOW; 
        end
    endcase
end

// Output Logic
always @(posedge new_clk) begin
    case(curr_state)
        MAIN_GREEN, MAIN_STAY_GREEN: begin
            main_green <= 1;
            main_yellow <= 0;
            main_red <= 0;
            side_green <= 0;
            side_yellow <= 0;
            side_red <= 1;
            walk_lamp <= 0;
        end
        MAIN_YELLOW: begin
            main_green <= 0;
            main_yellow <= 1;
            main_red <= 0;
            side_green <= 0;
            side_yellow <= 0;
            side_red <= 1;
            walk_lamp <= 0;
        end
        WALK: begin
            main_green <= 0;
            main_yellow <= 0;
            main_red <= 1;
            side_green <= 0;
            side_yellow <= 0;
            side_red <= 1;
            walk_lamp <= 1;
        end
        SIDE_GREEN, SIDE_STAY_GREEN: begin
            main_green <= 0;
            main_yellow <= 0;
            main_red <= 1;
            side_green <= 1;
            side_yellow <= 0;
            side_red <= 0;
            walk_lamp <= 0;
        end
        SIDE_YELLOW: begin
            main_green <= 0;
            main_yellow <= 0;
            main_red <= 1;
            side_green <= 0;
            side_yellow <= 1;
            side_red <= 0;
            walk_lamp <= 0;
        end
    endcase
end
endmodule