module controller (
	input clk, 
	input rst,
	input [2:0] main_num,
	input [2:0] left_num,
	input [2:0] sec_num,
	input [2:0] p_num,
	input m_emergency,
	input s_emergency,
	output reg [2:0] s_RYG, 
	output reg [3:0] m_LRYG,
	output reg  ped,
	);

reg [4:0] MaxTime ;
reg [4:0] sec_count ;






//finit state machine
reg [2:0] ns,cs;// ns:nextstate  cs:currentstate
parameter INIT =3'd0;//initial
parameter M_G=3'd1;
parameter M_L=3'd2;
parameter S_G=3'd3;
parameter P_G=3'd4;
parameter M_Y=3'd5;
parameter S_Y=3'd6;
//set currentstate
always@(posedge clk or posedge rst)
begin
	if(rst)
		cs <= INIT ;
	else
		cs <= ns ;
end

//set nextstate from currentstate
always@(*)
begin
	case(cs)
		INIT:
			ns=M_G;             
		M_G:
			if(sec_count == MaxTime)
				ns=M_Y;
			else
				ns=M;
		M_Y:
			if( sec_count == MaxTime)
				ns=M_L;
			else if( left_num == 3'd0)
				ns=S_G;//有可能沒亮左轉燈
			else
				ns=M_Y;
		M_L:
			if(sec_count == MaxTime)
				ns=M_Y;
			else
				ns=M_L;
		S_G:
			if(sec_count == MaxTime)
				ns=S_Y;
			else
				ns=S;
		S_Y:
			if(sec_count == MaxTime)
				ns=P_G;
			else if(p_num == 3'd0)
				ns=M_G;
			else
				ns=S_Y;
		P_G:
			if(sec_count == MaxTime)
				ns=P_Y;
			else
				ns=P;
		default:
			ns=INIT ;

	endcase
end

//output light
always @ (posedge clk or posedge rst)
	case(cs)
		M_G : begin 
			m_LRYG <= 4'b0001 ;//Master road:G
			s_RYG <= 3'b100 ;  //Secondary road:R
			ped <= 1'b0 ;      //pedestrian:off
		end 
		M_Y : begin 
			m_LRYG <= 4'b0010 ;//Master road:Y
			s_RYG <= 3'b100 ;  //Secondary road:R
			ped <= 1'b0 ;      //pedestrian:off
		end 	
		M_L : begin 
			m_LRYG <= 4'b1100 ;//Master road:L&R
			s_RYG <= 3'b100 ;  //Secondary road:R
			ped <= 1'b0 ;      //pedestrian:off
		end
		S_G : begin 
			m_LRYG <= 4'b0100 ;//Master road:R
			s_RYG <= 3'b001 ;  //Secondary road:G
			ped <= 1'b0 ;      //pedestrian:off
		end
		S_Y : begin 
			m_LRYG <= 4'b0100 ;//Master road:R
			s_RYG <= 3'b010 ;  //Secondary road:Y
			ped <= 1'b0 ;      //pedestrian:off
		end
		P_G : begin 
			m_LRYG <= 4'b0001 ;//Master road:G
			s_RYG <= 3'b100 ;  //Secondary road:R
			ped <= 1'b1 ;      //pedestrian:on                      
		end
		default : begin 
			m_LRYG <= 4'b1111 ;//Master road: error test
			s_RYG <= 3'b100 ;  //Branch road:R
			ped <= 1'b0 ;      //pedestrian:off
		end
	endcase
//second counter
always@(posedge rst or posedge clk) begin
	if (rst)begin
		sec_count <= 5'd0 ;
	end
	else if (sec_count == MaxTime)begin
		sec_count <= 5'd0 ;
	end
	else begin
		sec_count <= sec_count + 5'd1 ;
	end
end
//max time
always @ (*)begin
	case(cs) 
		M_G : MaxTime = 5'd30 ;
		M_Y : MaxTime = 5'd3 ;
		M_L : MaxTime = 5'd12 ;
		S_G : MaxTime = 5'd18 ;
		S_Y : MaxTime = 5'd3 ;
		P_G : MaxTime = 5'd18 ;
		default : MaxTime = 5'd0 ;
	endcase
end




endmodule
