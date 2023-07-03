`timescale	1ns/10ps
module smart_traffic_light_tb;

reg clk, rst ;
reg [2:0] main_num, left_num, sec_num, p_num;
reg s_emergency;
wire [2:0] s_RYG;
wire [3:0] m_LRYG;
wire p;

initial begin
	$monitor($time, " main_num=%d, left_num=%d, sec_num=%d, p_num=%d, s_emergency=%b, m_LRYG=%b, s_RYG=%b, p=%b", main_num, left_num, sec_num, p_num, s_emergency, m_LRYG, s_RYG, p);
end

initial begin
	`ifdef FSDB
		$fsdbDumpfile("Smart_Traffic_Light.fsdb");
		$fsdbDumpvars;
	`endif
end
smart_traffic_light STL (
	.clk(clk),
	.rst(rst),
	.main_num(main_num),
	.left_num(left_num),
	.sec_num(sec_num),
	.p_num(p_num),
	.s_emergency(s_emergency),
	.m_LRYG(m_LRYG),
	.s_RYG(s_RYG),
	.p(p)
);

initial begin
	clk <= 1'b0 ;
	rst <= 1'b0 ;
	main_num <= 3'b0 ;
	left_num <= 3'b0 ;
	sec_num <= 3'b0 ;
	p_num <= 3'b0 ;

end

always begin
	#2 clk = ~clk ;
end

initial begin
	#10
		rst = 1'b1 ;
	#11
		rst = 1'b0 ;
	#100
		main_num = 3'b000 ;
		left_num = 3'b000 ;
		sec_num = 3'b000 ;
		p_num = 3'b000 ;
		s_emergency = 1'b0 ;
	#100
		main_num = 3'b001 ;
		left_num = 3'b000 ;
		sec_num = 3'b000 ;
		p_num = 3'b000 ;
		s_emergency = 1'b0 ;
	#100
		main_num = 3'b010 ;
		left_num = 3'b010 ;
		sec_num = 3'b100 ;
		p_num = 3'b010 ;
		s_emergency = 1'b0 ;
	#100
		main_num = 3'b011 ;
		left_num = 3'b010 ;
		sec_num = 3'b100 ;
		p_num = 3'b010 ;
		s_emergency = 1'b0 ;
	#100
		main_num = 3'b100 ;
		left_num = 3'b100 ;
		sec_num = 3'b010 ;
		p_num = 3'b100 ;
		s_emergency = 1'b0 ;	
	#1000
		$finish ;
end

endmodule

