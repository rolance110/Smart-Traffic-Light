` include "Dff.v"
module CreateSecond(clk, reset, Q);

input clk, reset ;
output Q ;
wire D, c_reset, _en, en;
reg [2:0] count ;

assign c_reset = reset | en;
assign D = ~Q ;
assign en = count[2] & count[0];//when count arrive  5

always @ (posedge clk)
	if (c_reset) 
		count <= 0;
	else 
		count <= count + 1;	
//using D flip flop
Dff D0(D, Q, en, reset, clk);
//test
endmodule
