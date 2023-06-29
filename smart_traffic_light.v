` include "counter.v"
` include "controler.v"
module smart_traffic_light(RYG, LRYG, L, H, clk, reset,count_out);

input clk, reset;
input [2:0] L, H;
output [2:0] RYG;
output [3:0] LRYG;
output  [4:0] count_out;
wire fout, count_reset;

CreateSecond S(.clk(clk), .reset(reset), .Q(fout));

counter C1(.clk(fout),.count(count_out), .reset(count_reset)); 
	
controler C0(.RYG(RYG), .LRYG(LRYG), .L(L), .H(H), .clk(clk), .reset(reset), .count_in(count_out), .count_reset(count_reset));
	
endmodule
