module compare (
	input [2:0] main_num,
	input [2:0] left_num,
	input [2:0] sec_num,
	input [2:0] p_num, 
	output [2:0] absolute_num,
	output m_more,
	output l_zero,
	output s_more,
	output p_more,
);

	assign m_more = (main_num > left_num);
	assign l_zero = (left_num == 0);
	assign s_more = (sec_num > main_num);
	assign p_more = (p_num > sec_num);
	assign absolute_num = (m_more) ? (main_num - left_num) : (left_num - main_num);
	
endmodule
