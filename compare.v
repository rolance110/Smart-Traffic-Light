module compare (
	input [2:0] main_num,
	input [2:0] left_num,
	input [2:0] sec_num,
	input [2:0] p_num, 
	output wire [2:0] absolute_num,
	output wire m_more,
	output wire l_zero,
	output wire s_more,
	output wire p_more,
);

assign m_more = (main_num > (left_num<<1))? 1'b1 : 1'b0;
assign l_zero = (left_num == 0)? 1'b1 : 1'b0;
assign s_more = (sec_num == main_num)? 1'b1: 1'b0;
assign p_more = (p_num>(main_num+sec_num))? 1'b1: 1'b0;
assign absolute_num[2] = (main_num[2]==1)? 1'b1: 1'b0;
assign absolute_num[1] = (sec_num==main_num)? 1'b1: 1'b0;
assign absolute_num[0] = (left_num == 0)? 1'b1 : 1'b0;
	
endmodule
