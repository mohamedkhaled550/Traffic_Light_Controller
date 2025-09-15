module traffic_light_controller
(
	input clk, reset_n,
	input Sa,Sb, 
	input timer_done_60, timer_done_50, timer_done_10,
	output reg Ra, Ya, Ga ,Rb, Yb, Gb,
	output reg timer_reset_60, timer_reset_50, timer_reset_10
);
reg [3:0] state_reg, state_next;
localparam [3:0] s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,
		 s8=8,s9=9,s10=10,s11=11;
always@(posedge clk, negedge reset_n)
begin
	if(!reset_n)
		state_reg <= s0;
	else
		state_reg <= state_next;
end
always @(*)
begin
	case(state_reg)
		s0: if(timer_done_60)
			state_next = s1;
		else
			state_next = s0;
		s1: if(~Sb)
			state_next = s2;
		else
			state_next = s4;
		s2: if(Sb)
			state_next = s1;
		else if(~Sb & timer_done_10)
			state_next = s3;
		else if(~timer_done_10)
			state_next = s2;
		s3: if(~Sb)
			state_next = s2;
		else
			state_next = s4;
		s4: if(~timer_done_10)
			state_next = s4;
		else
			state_next = s5;
		s5: state_next = s6;
		s6: if(~timer_done_50)
			state_next = s6;
		else 
			state_next = s7;
		s7: if(Sa | ~Sb)
			state_next = s10;
		else
			state_next = s8;
		s8: if(Sa | ~Sb)
			state_next = s7;
		else if(Sb & ~Sa & timer_done_10)
			state_next = s9;
		else if(~timer_done_10)
			state_next = s8;
		s9: if(Sb & ~Sa)
			state_next = s8;
		else if(Sa | ~Sb)
			state_next = s10;
		s10: if(~timer_done_10)
			state_next = s10;
		else
			state_next = s11;
		s11: state_next = s0;
		default: state_next = s0;
	endcase
end
always@(*)
begin
	Ra = 0;
	Ya = 0;
	Ga = 0;
	Rb = 0;
	Yb = 0;
	Gb = 0;
	timer_reset_10 = 0;
	timer_reset_50 = 0;
	timer_reset_60 = 0;
	case(state_reg)
		s0: begin
			Ga = 1;
			Rb = 1;
		end
		s1: begin
			Ga = 1;
			Rb = 1;
			timer_reset_10 = 1;
		end
		s2: begin
			Ga = 1;
			Rb = 1;
		end
		s3:begin
			Ga = 1;
			Rb = 1;
			timer_reset_10 = 1;
		end
		s4:begin
			Rb = 1;
			Ya = 1;
		end
		s5:begin
			Gb = 1;
			Ra = 1;
			timer_reset_50 = 1;
		end
		s6:begin
			Gb = 1;
			Ra = 1;
		end
		s7:begin
			Gb = 1;
			Ra = 1;
			timer_reset_10 = 1;
		end
		s8:begin
			Gb = 1;
			Ra = 1;
		end
		s9:begin
			Gb = 1;
			Ra = 1;
			timer_reset_10 = 1;
		end
		s10:begin
			Yb = 1;
			Ra = 1;
		end
		s11:begin
			Ga = 1;
			Rb = 1;
			timer_reset_60 = 1;
		end
		default;
	endcase
end
endmodule