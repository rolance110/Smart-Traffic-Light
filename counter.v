module counter (clk, count, reset) ;

input reset, clk ;
output reg [4:0] count ;

always @ (posedge clk or posedge reset)
	if (reset)
		count <= 0 ;
		
	else 
		count <= count + 1 ;
	
endmodule
