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

reg [2:0] num;
reg [4:0] sub_MaxTime;
reg [1:0] r_MaxTime;
reg [4:0] MaxTime;
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
//dicide sub_Maxtime by reletive number
always @ (*)begin
	case(cs) 
		M_G :begin
			if(m_more == 1'b1)
				sub_MaxTime = 5'd25 ;
			else if(l_zero)
				sub_MaxTime = 5'd28 ;
			else if(s_more == 1'b1)
				sub_MaxTime = 5'd15 ;
			else if(p_more == 1'b1)
				sub_MaxTime = 5'd15 ;
			else//general case
				sub_MaxTime = 5'd20 ;
		end
		M_Y : sub_MaxTime = 5'd3 ;
		M_L :begin 
			if(l_zero == 1'b1)
				sub_MaxTime = 5'd0 ;
			else//general case
				sub_MaxTime = 5'd6 ;
		end
		S_G :begin
			if(m_more == 1'b1)
				sub_MaxTime = 5'd5 ;
			else if(l_zero)
				sub_MaxTime = 5'd8 ;
			else if(s_more == 1'b1)
				sub_MaxTime = 5'd15 ;
			else if(p_more == 1'b1)
				sub_MaxTime = 5'd5 ;
			else//general case
				sub_MaxTime = 5'd10 ;
		end
		S_Y : sub_MaxTime = 5'd3 ;
		P_G :begin
			if(p_more == 1'b1)
				sub_MaxTime = 5'd20 ;
			else//general case
				sub_MaxTime = 5'd10 ;
		end 
		default : MaxTime = 5'd0 ;
	endcase
end
//dicide rate_Maxtime by absolutive number
always @ (*)begin
	case(absolutenum) 
		3'b100:begin
			if(cs==M_G || cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'b010:begin
			if(cs==S_G || cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'b001:begin
			if(cs==L_G)
				r_MaxTime = 2'd0;
			else if(cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'b110:begin
			if(cs==M_G || cs==S_G || cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'b101:begin
			if(cs==L_G)
				r_MaxTime = 2'd0;
			else if(cs==M_G || cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'b011:begin
			if(cs==L_G)
				r_MaxTime = 2'd0;
			else if(cs==S_G || cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'b111:begin
			if(cs==L_G)
				r_MaxTime = 2'd0;
			else if(cs==M_G || cs==S_G || cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		3'd000:begin//formal case
			if(cs==P_G)
				r_MaxTime = 2'd2;
			else
				r_MaxTime = 2'd1;
		end
		default : r_MaxTime = 2'd0 ;
	endcase
end
always@(*) begin
	case(cs)
		M_G : num = main_num ;
		M_L : num = left_num ;
		S_G : num = sec_num ;
		P_G : num = p_num ;
		default : num = 3'd0 ;//yellow
	endcase
end
always@(*)begin
	MaxTime = sub_MaxTime + num<<r_MaxTime ;
end
endmodule
