`timescale 1ns/10ps
`include "f_sub.v"
`define period 10
module f_sub_tb;

// ----------------------   reg  ---------------------- //
reg  clk;
reg  rst;
reg  [1599:0] absorb_outcome ;
// ----------------------  wire  ---------------------- //
wire [1599:0] s_out;

integer i, fp_r;
integer j, fp_ri;

reg [1599:0] inp [x:0];
reg [1599:0] exp [x:0];


f_sub f_sub1(
	.clk(clk),
	.rst(rst),
	.absorb_outcome (absorb_outcome ),
	.s_out(s_out)
);

//clock generator
always #(`period/2) clk = ~clk;

initial begin
		fp_ri = $fopen("input.txt", "r");
		j=0;
		while(!$feof(fp_ri))begin
			$fscanf(fp_ri, "%h\n", inp[j]);
			j = j+1;
		end
		$fclose(fp_ri);
		for(j=0; j<x; j=j+1)begin
			@(posedge clk)
				absorb_outcome=inp[j];
		end
		

		fp_r = $fopen("golden.txt", "r");
		i=0;
		while(!$feof(fp_r))begin
			$fscanf(fp_r, "%h\n", exp[i]);
			i = i+1;
		end
		$fclose(fp_r);
		#10
		for(i=0; i<x; i=i+1)begin
			#10 
			if(exp[i]!==s_out)begin
				show_err(1);
				$finish;
			end
		end
		show_err(0);
		$finish;
end

initial begin
	$monitor($time, " output = %d, expect = %d", s_out, exp[i]);
end

initial begin
	#0	clk=1; rst=1; absorb_outcome=0; 
	#10 rst=0;
	

end

task show_err;
	input integer check;
	begin
		if(check === 0)begin
			$display("\n");
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  Congratulations !!    **      / O.O  | ");
			$display("        **                        **    /_____   | ");
			$display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
		else begin
			$display("\n");
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  OOPS!!                **      / X,X  | ");
			$display("        **                        **    /_____   | ");
			$display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
	end
endtask

initial begin
  `ifdef FSDB
    $fsdbDumpfile("f_sub.fsdb");
    $fsdbDumpvars("+mda");
  `endif
end
endmodule
