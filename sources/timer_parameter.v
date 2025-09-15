module timer_parameter
#(parameter Final_value = 20)
(
	input clk, reset_n, en,
//	output [$clog2(Final_value)-1:0] Q, 
	output done
);
reg [$clog2(Final_value)-1:0] Q_reg = 'b0, Q_next;
always @(posedge clk, negedge reset_n)
begin
	if(!reset_n)
		Q_reg <= 'b0;
	else if(en)
		Q_reg <= Q_next;
	else
		Q_reg <= Q_reg;		
end
assign done = Q_reg == Final_value;
always @(*)
begin
	if(done)
		Q_next = 'b0;
	else
		Q_next = Q_reg + 1;
end
endmodule
