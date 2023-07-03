` include "compare.v"
` include "controller.v"
module smart_traffic_light(
    input clk,
    input rst,
    input [2:0] main_num,
    input [2:0] left_num,
    input [2:0] sec_num,
    input [2:0] p_num,
    input s_emergency,
    output [3:0] m_LRYG,
    output [2:0] s_RYG,
    output [2:0] p,
);


compare compare(
    .main_num(main_num),
    .left_num(left_num),
    .sec_num(sec_num),
    .p_num(p_num),
    .absolute_num(absolute_num),
    .m_more(m_more),
    .l_zero(l_zero),
    .s_more(s_more),
    .p_more(p_more), 
 ); 

controller controller(
    .clk(clk), 
    .rst(rst),
    .s_emergency(s_emergency),
    .absolute_num(absolute_num),
    .m_more(m_more),
    .l_zero(l_zero),
    .s_more(s_more),
    .p_more(p_more),
    .s_RYG(s_RYG),
    .m_LRYG(m_LRYG),
    .p(p),
    );
endmodule
