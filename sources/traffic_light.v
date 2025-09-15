module traffic_light(
	input clk, reset_n, Sa, Sb,
	output Ra, Ya, Ga ,Rb, Yb, Gb
);
wire timer_done_60, timer_done_50, timer_done_10;
wire timer_reset_60, timer_reset_50, timer_reset_10;
traffic_light_controller TC (
	.clk(clk),
	.reset_n(reset_n),
	.Sa(Sa),
	.Sb(Sb),
	.Ra(Ra),
	.Ya(Ya),
	.Ga(Ga),
	.Rb(Rb),
	.Yb(Yb),
	.Gb(Gb),
	.timer_done_60(timer_done_60),
	.timer_done_50(timer_done_50),
	.timer_done_10(timer_done_10),
	.timer_reset_60(timer_reset_60),
	.timer_reset_50(timer_reset_50),
	.timer_reset_10(timer_reset_10)
);
timer_parameter#(.Final_value(999_999)) T10
(
	.clk(clk),
	.reset_n(~timer_reset_10),
	.en(1'b1),
	.done(timer_done_10)
);
timer_parameter#(.Final_value(4_999_999)) T50
(
	.clk(clk),
	.reset_n(~timer_reset_50),
	.en(1'b1),
	.done(timer_done_50)
);
timer_parameter#(.Final_value(5_999_999)) T60
(
	.clk(clk),
	.reset_n(~timer_reset_60),
	.en(1'b1),
	.done(timer_done_60)
);
endmodule