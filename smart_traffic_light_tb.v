`timescale	10ns/100ps
module smart_traffic_light_tb;

reg clk, reset ;
reg [2:0] L, H ;

wire [2:0] RYG ;
wire [3:0] LRYG ;
wire [4:0] count_out;

initial begin
	$fsdbDumpfile("STL.fsdb");
	$fsdbDumpvars;
end


smart_traffic_light T0 (RYG, LRYG, L, H, clk, reset,count_out) ;




initial begin
	clk <= 1'b0 ;
	reset <= 1'b0 ;
	L <= 3'b000 ;
	H <= 3'b000 ;

end

always begin
	#2 clk = ~clk ;
end

initial begin
	#10
		reset = 1'b1 ;
	#11
		reset = 1'b0 ;
	#10
		L = 3'b000 ;                         // L : 0 car waiting
		H = 3'b100 ;                         // H : 1 car waiting to turn left
	#5200
		L = 3'b100 ;                         // L : 1 car waiting
		H = 3'b000 ;                         // H : 0 car waiting to turn left
	#3700
		L = 3'b000 ;                         // L : 0 car waiting
		H = 3'b000 ;                         // H : 0 car waiting to turn left
	#300
		L = 3'b100 ;                         // L : 1 car waiting
		H = 3'b100 ;                         // H : 1 car waiting to turn left
	#5000
		L = 3'b100 ;                         // L : 1 car waiting
		H = 3'b100 ;                         // H : 1 car waiting to turn left
	#500
		L = 3'b100 ;                         // L : 1 car waiting
		H = 3'b110 ;                         // H : 2 cars waiting to turn left
	#2600
		L = 3'b000 ;                         // L : 0 car waiting
		H = 3'b000 ;                         // H : 0 car waiting to turn left
	#800
		L = 3'b110 ;                         // L : 2 cars waiting
		H = 3'b100 ;                         // H : 1 car waiting to turn left

	#3100
		L = 3'b111 ;                         // L : 3 cars waiting
		H = 3'b000 ;                         // H : 0 car waiting to turn left

	#2900
		L = 3'b000 ;                         // L : 0 car waiting
		H = 3'b110 ;                         // H : 2 cars waiting to turn left*/
	#3500
		$finish ;
end

/*
always@(posedge clk)begin
	$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	$display("      lPPPPP");
	$display("      ll");
	$display("      ll");
	$display("   oooooooo");
	$display("  oooooooooo");
	$display(" oooooooooooo");
	$display(" oooooooooooo              ,-.__.-,                           ");
	$display("  oooooooooo              (``-''-//).___..--'''`-._           ");
	$display("   oooooooo                `6_ 6  )   `-.  (     ).`-.__.`)   ");
	$display("                           (_Y_.)'  ._   )  `._ `. ``-..-'    ");
	$display("                         _..`--'_..-_/  /--'_.' ,'            ");
	$display("                        (il),-''  (li),'  ((!.-'              ");
	$display("");
	$display("Congratulations !");
	$display("Simulation Complete!!");
	$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	$display("");
	$finish;
end*/
endmodule

