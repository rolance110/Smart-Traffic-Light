module controller (
	input clk, 
	input reset,
	input [2:0] L,
	input [2:0] H,

	output reg [2:0] RYG, 
	output reg [3:0] LRYG,
	output reg  P,
	
	input count_in, 
	output count_reset,
	);

//finit state machine
reg [2:0] ns,cs;// ns:nextstate  cs:currentstate
parameter INIT =3'd0;//initial
parameter M=3'd1;
parameter M_L=3'd2;
parameter S=3'd3;
parameter PEDESTRIAN=3'd4;
parameter M_Y=3'd5;
parameter S_Y=3'd6;
//set currentstate
always@(posedge clk or posedge reset)
begin
	if(reset)
		cs <= INIT ;
	else
		cs <= ns ;
end

//set nextstate from currentstate
always@(*)
begin
	case(cs)
		INIT:
			ns=M;             
		M:
			if()
				ns=M_Y;
			else
				ns=M;
		M_Y:
			if()
				ns=M_L;
			else if()
				ns=S;//有可能沒亮左轉燈
			else
				ns=M_Y;
		M_L:
			if()
				ns=M_Y;
			else
				ns=M_L;
		S:
			if()
				ns=S_Y;
			else
				ns=S;
		S_Y:
			if()
				ns=PEDESTRIAN;
			else if()
				ns=M;
			else
				ns=S_Y;
		default:
			ns=INIT ;

	endcase
end
reg [4:0] MaxTime ;

wire in_reset,ToEnd ;

assign ToEnd = (MaxTime == count_in) ;//if run to max time

assign in_reset = reset || (RYG[1] && LRYG[2]&& ToEnd);//

assign count_reset = in_reset || ToEnd ;

///////////output light(from current state)///////////////////
always @ (posedge clk or posedge rst)
	case(cs)
		3'd0 : begin 
			LRYG <= 4'b0001 ;//Master road:G
			RYG <= 3'b100 ;  //Branch road:R
		end 
		3'd1 : begin 
			LRYG <= 4'b0010 ;//Master road:Y
			RYG <= 3'b100 ;  //Branch road:R
		end 	
		3'd2 : begin 
			LRYG <= 4'b1100 ;//Master road:L&R
			RYG <= 3'b100 ;  //Branch road:R
		end
		3'd3 : begin 
			LRYG <= 4'b0010 ;//Master road:Y
			RYG <= 3'b100 ;  //Branch road:R
		end
		3'd4 : begin 
			LRYG <= 4'b0100 ;//Master road:R
			RYG <= 3'b001 ;  //Branch road:G
		end
		3'd5 : begin 
			LRYG <= 4'b0100 ;//Master road:R
			RYG <= 3'b010 ;  //Branch road:Y
		end
		3'd6 : begin 
			LRYG <= 4'b0001 ;//Master road:G
			RYG <= 3'b100 ;  //Branch road:R                      
		end
		3'd7 : begin 
			LRYG <= 4'b0001 ;//Master road:G
			RYG <= 3'b100 ;  //Branch road:R                        
		end
	endcase

always @ (cs)
	case(cs) 
		3'd0 : MaxTime <= 20;
		3'd1 : MaxTime <= 3 ;
		3'd2 : MaxTime <= 10;
		3'd3 : MaxTime <= 3 ;
		3'd4 : MaxTime <= 15;
		3'd5 : MaxTime <= 3 ;
		3'd6 : MaxTime <= 20;
		3'd7 : MaxTime <= 20;
	endcase
//////////////////////////////////////////////////////////////


////////set intitial state (from how many car on road)////////////
always @ (H, L) 
	case ({((L[0] && !H[0]) || (L[1] && !H[1]) || H[1]), H[0]})
		3'd0 : cs0 <= (L[2] || H[2]) ? 3'd7 : 3'd0 ;
		3'd1 : cs0 <= 3'd1 ;
		3'd2 : cs0 <= 3'd6 ;
		default : cs0 <= 3'd0 ;
	endcase
//////////////////////////////////////////////////////////////

///////////set next state(decided by current state)///////////////
always @ (posedge count_reset or posedge in_reset)
   begin 
	if (in_reset)
		ns <= 0 ;
	
	else begin 
		case(cs)
			3'd0 : ns <= cs0 ;
			3'd1 : ns <= (|H) ? 3'd2 : 3'd4 ;
			3'd2 : ns <= 3'd3 ;
			3'd3 : ns <= 3'd4 ;
			3'd4 : ns <= 3'd5 ;
			3'd5 : ns <= 3'd0 ;
			3'd6 : ns <= 4'd1 ;
			3'd7 : ns <= (H[1] || L[1]) ? 3'd1 : 3'd6 ;
		endcase
    end
  end 
//////////////////////////////////////////////////////////////

//////////////////set current state///////////////////////////
always @ (posedge clk or posedge in_reset) 
  begin 
	if (in_reset)
		cs <= 0 ;
		
	else
		cs <= ns ;
  end 
//////////////////////////////////////////////////////////////
endmodule
