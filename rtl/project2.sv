typedef enum logic [1:0] {RED = 2'b00, GREEN, YELLOW} lightState;
typedef enum bit {READ, WRITE} mem_op;

interface system_bus (
		      input logic clk,
		      input logic [2:0] main_traffic,
		      input logic [2:0] country_traffic,
		      output logic [1:0] countryLight,
		      output logic [1:0] mainLight
		      );

   logic 				 country_pulse = 0;
   logic [1:0] 				 main_light;
   logic [2:0] 				 current_traffic_amount;
   logic [2:0] 				 country_car_num;
   bit [4:0] 				 hour, light_rank;
   bit [5:0] 				 minute, second;
   bit	 [14:0] 			 accum_data1, accum_data2;
   bit	 [9:0] 				 traffic_ranked_data [23:0];
   bit	 [14:0] 				 traffic_data [23:0];
   mem_op op1;
   mem_op op2;

   modport clock (
		  input clk,
		  output hour, minute, second
		  );

   modport controller (
		       input main_light, current_traffic_amount, country_car_num, accum_data2, hour, clk, op2,
		       output country_pulse, light_rank, accum_data1, op1
		       );

   modport traffic_light (
			  input country_pulse, light_rank, main_traffic, country_traffic, clk,
			  output mainLight, main_light, countryLight, current_traffic_amount, country_car_num
			  );

   modport mem (
		 input hour, accum_data1, traffic_ranked_data, clk, op1, op2,
		 output traffic_data, accum_data2
		 );

   modport rank_cal (
		 input traffic_data, hour, minute, second, clk, op1,
		 output traffic_ranked_data, op2
		 );

endinterface // system_bus

module top (
	    input logic clk,
	    input logic [2:0] main_traffic, country_traffic,
	    output logic [1:0] countryLight, mainLight
	    );

   system_bus sb_intf(
		      .clk(clk),
		      .main_traffic(main_traffic),
		      .country_traffic(country_traffic),
		      .countryLight(countryLight),
		      .mainLight(mainLight)
		      );

   clock clock (.i0(sb_intf));
   controller controller (.i1(sb_intf));
   trafficLight trafficLight (.i2(sb_intf));
   memory memory (.i3(sb_intf));
   rank_calculator rank_calculator (.i4(sb_intf));

endmodule // top

module clock (system_bus.clock i0);

   logic s_clk = 1;
   logic m_clk = 1;

   always_ff @(posedge i0.clk) begin
      if (i0.second == 29) begin
	 s_clk <= ~s_clk;
	 i0.second <= i0.second + 1;
      end
      else if (i0.second == 59) begin
	 i0.second <= 0;
	 s_clk <= ~s_clk;
      end
      else begin
	 i0.second <= i0.second + 1;
      end
   end // always_ff @ (posedge i0.clk or negedge rstn)

   always_ff @(posedge s_clk) begin
      if (i0.minute == 29) begin
	 m_clk <= ~m_clk;
	 i0.minute <= i0.minute + 1;
      end
      else if (i0.minute == 59) begin
	 i0.minute <= 0;
	 m_clk <= ~m_clk;
      end
      else begin
	 i0.minute <= i0.minute + 1;
      end
   end // always_ff @ (posedge s_clk or negedge i0.rstn)

   always_ff @(posedge m_clk) begin
      if (i0.hour == 23) begin
	 i0.hour <= 0;
      end
      else begin
	 i0.hour <= i0.hour + 1;
      end
   end // always_ff @ (posedge m_clk or negedge i0.rstn)
   
endmodule // clock

module controller (system_bus.controller i1);

   logic [6:0] country_car_number = 0;
   bit [2:0] prev_country_car_num, prev_current_traffic_amount;
   mem_op op;

   always_ff @(posedge i1.clk) begin
      prev_country_car_num <= i1.country_car_num;
      prev_current_traffic_amount <= i1.current_traffic_amount;
   end

   always_ff @(posedge i1.clk) begin
      if (i1.country_car_num != prev_country_car_num) begin
	 if (i1.main_light[0] == 1) begin
	    country_car_number <= country_car_number + i1.country_car_num;
	    if (country_car_number > 30) begin
	       i1.country_pulse <= 1;
	       country_car_number <= 0;
	    end
	    else begin
	       i1.country_pulse <= 0;
	    end
	 end
	 else if (i1.main_light[0] == 0) begin
	    country_car_number <= 0;
	    i1.country_pulse <= 0;
	 end
      end // if (i1.country_car_num != prev_country_car_num)
      else begin
	 i1.country_pulse <= 0;
      end // else: !if(i1.country_car_num != prev_country_car_num)
   end // always_ff @ (posedge i1.clk)

   always_ff @(posedge i1.clk) begin
      if (i1.current_traffic_amount != prev_current_traffic_amount) begin
	 i1.op1 <= WRITE;
	 i1.accum_data1[14:10] <= i1.hour;
	 i1.accum_data1[9:0] <= i1.current_traffic_amount + i1.accum_data2[14:5];
      end
      else if (i1.op2 == WRITE)
	 i1.light_rank[4:0] <= i1.accum_data2[4:0];
      else
	i1.op1 <= READ;
   end // always_ff @ (posedge i1.clk)

   always @(posedge i1.clk) begin
      automatic time current_time = $time;
      if (i1.main_light[0] == 1) begin
	 CHECK_COUNTRY_CAR_NUM : begin
	    assert (country_car_number != 0) begin
	       $display("CHECK_COUNTRY_CAR_NUM PASS %0t", $time);
	    end
	    else begin
	       #1 $error("CHECK_COUNTRY_CAR_NUM FAIL %0t\n", current_time);
	    end
	 end
      end // if (i1.main_light[0] == 1)
      if (country_car_number > 30) begin
	 CHECK_PULSE : begin
	    assert (i1.country_pulse == 1) begin
	       $display("CHECK_PULSE PASS %0t", $time);
	    end
	    else begin
	       #1 $error("CHECK_PULSE FAIL %0t\n", current_time);
	    end
	 end
      end
      if (i1.current_traffic_amount != prev_current_traffic_amount) begin
	 CHECK_WRITE : begin
	    assert (i1.op1 == 1) begin
	       $display("CHECK_WRITE PASS %0t", $time);
	    end
	    else begin
	       #1 $error("CHECK_WRITE FAIL %0t\n", current_time);
	    end
	 end
      end
   end // always @ (posedge i1.clk)
   
endmodule // controller

module trafficLight(system_bus.traffic_light i2);

   enum logic [1:0] {S0 = 2'b00, S1, S2, S3} state;
   logic prevPulse, finalPulse, mainCntEnable, cntryCntEnable = 1'b0;
   logic [8:0] cnt = 0;

   lightState mainLight = GREEN;
   lightState cntryLight = RED;

   always_ff @(posedge i2.clk) begin
      i2.current_traffic_amount <= i2.main_traffic;
      i2.country_car_num <= i2.country_traffic;
      i2.main_light <= mainLight;
      i2.mainLight <= mainLight;
      i2.countryLight <= cntryLight;
      
      if (mainCntEnable == 1'b1) begin
	 if (i2.light_rank[4:0] inside {5'b00001, 5'b01000}) begin
	    if (cnt >= (750 - (5'd40 * i2.light_rank[4:0]))) begin
	       state <= S1;
	       mainCntEnable <= 1'b0;
	       cnt <= 0;
	    end
	    else
	      cnt <= cnt + 1;
	 end
	 else begin
	    if (cnt >= 360) begin
	       state <= S1;
	       mainCntEnable <= 1'b0;
	       cnt <= 0;
	    end
	    else
	      cnt <= cnt + 1;
	 end // else: !if(i2.light_rank inside {5'b00001, 5'b01010})
      end // if (mainCntEnable == 1'b1)
      else if (cntryCntEnable == 1'b1) begin
	 if (finalPulse == 1'b1) begin
	    if (cnt >= 240) begin
	       state <= S3;
	       cntryCntEnable <= 1'b0;
	       finalPulse <= 1'b0;
	       cnt <= 0;
	    end
	    else
	      cnt <= cnt + 1;
	 end
	 else begin
	    if (cnt >= 120) begin
	       state <= S3;
	       cntryCntEnable <= 1'b0;
	       cnt <= 0;
	    end
	    else
	      cnt <= cnt + 1;
	 end // else: !if(finalPulse == 1'b1)
      end // if (cntryCntEnable == 1'b1)
      else
	cnt <= 0;
   end // always_ff @ (posedge i2.clk)

   always_ff @(posedge i2.clk) begin
      prevPulse <= i2.country_pulse;
      if ((i2.country_pulse == 1'b0) && (prevPulse == 1'b1))
	finalPulse <= 1'b1;
      else begin
	 case (state)
	   S0 : begin
	      if (finalPulse == 1'b1)
		state <= S1;
	      else
		mainCntEnable <= 1'b1;
	   end
	   S1 : begin
	      mainCntEnable <= 1'b0;
	      state <= S2;
	   end
	   S2 : cntryCntEnable <= 1'b1;
	   S3 : begin
	      cntryCntEnable <= 1'b0;
	      state <= S0;
	   end
	   default : state <= S0;
	 endcase // case (state)
      end // else: !if((i2.country_pulse == 1'b0) && (prevPulse == 1'b1))
   end // always_ff @ (posedge i2.clk)

   always @(*) begin
      case (state)
	S0 : mainLight = GREEN;
	S1 : mainLight = YELLOW;
	S2 : mainLight = RED;
	S3 : mainLight = RED;
	default : mainLight = GREEN;
      endcase // case (state)
   end

   always @(*) begin
      case (state)
	S0 : cntryLight = RED;
	S1 : cntryLight = RED;
	S2 : cntryLight = GREEN;
	S3 : cntryLight = YELLOW;
	default : cntryLight = RED;
      endcase // case (state)
   end

   always @(posedge i2.clk) begin
      automatic time current_time;
      if (i2.country_pulse == 1) begin
	 CHECK_FINAL_PULSE : begin
	    assert (finalPulse == 1) begin
	       $display ("CHECK_FINAL_PULSE PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CHECK_FINAL_PULSE FAIL %0t\n", current_time);
	    end
	 end
      end
      if (i2.light_rank inside {5'b00001, 5'b01000}) begin
	 CHECK_CNT : begin
	    assert (cnt > 361) begin
	       $display ("CHECK_CNT PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CHECK_CNT FAIL %0t\n", current_time);
	    end
	 end
      end
   end // always @ (posedge i2.clk)

endmodule // trafficLight

module memory (system_bus.mem i3);

   bit [19:0] memory[23:0];
   bit [4:0]		i;

   always_ff @(posedge i3.clk) begin
      if (i3.op1 == WRITE) begin
	 memory[i3.hour][19:5] <= i3.accum_data1[14:0];
	 for (i = 0; i < 24; i ++) begin
	    i3.traffic_data[i][14:0] <= memory[i][19:5];
	 end
      end
      else if (i3.op2 == WRITE) begin
	 for (i = 0; i < 24; i ++) begin
	    memory[i][4:0] <= i3.traffic_ranked_data[i][4:0];
	 end
	 i3.accum_data2[14:0] <= memory[i3.hour][14:0];
      end
      else begin
	 memory[i3.hour][19:5] <= i3.accum_data1[14:0];
	 i3.accum_data2[14:0] <= memory[i3.hour][14:0];
      end
   end // always_ff @ (posedge i3.clk)

   always @(posedge i3.clk) begin
      automatic time current_time;
      if (i3.op2 == WRITE) begin
	 CHECK_ACCUM_DATA : begin
	    assert (i3.accum_data1[9:0] == i3.accum_data2[14:5]) begin
	       $display ("CEHCK_ACCUM_DATA PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CHECK_ACCUM_DATA FAIL %0t\n", current_time);
	    end
	 end
      end // if (i3.op2 == WRITE)
   end // always @ (posedge i3.clk)
   
endmodule // memory

module rank_calculator (system_bus.rank_cal i4);

   bit [9:0] 	today_traffic[24];
   bit [5:0] 	i;
   bit [2:0] 	day;

   always_ff @(posedge i4.clk) begin
      if ((i4.hour == 5'd23) && (i4.minute == 6'd59) && (i4.second == 6'd59)) begin
	 if (day > 4)
	   day <= 0;
	 else
	   day <= day + 1;
      end
      else if (i4.op1 == READ) begin
	 for (i = 0; i < 24; i ++) begin
	    today_traffic[i][9:0] <= i4.traffic_data[i][9:0];
	 end
	 case (day)
	   3'd0 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (today_traffic[i])
		   10'b00000_00001 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd7};
		   10'b00000_00010 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd5};
		   10'b00000_00011 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd3};
		   10'b00000_00100 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd1};
		   default : i4.traffic_ranked_data[i] <= {i4.hour, 5'd0};
		 endcase // case (today_traffic[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd0
	   
	   3'd1 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (today_traffic[i]) 
		   10'b00000_00001 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd8};
		   10'b00000_00010 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd7};
		   10'b00000_00011 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd6};
		   10'b00000_00100 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd5};
		   10'b00000_00101 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd4};
		   10'b00000_00110 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd3};
		   10'b00000_00111 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd2};
		   10'b00000_01000 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd1};
		   default : i4.traffic_ranked_data[i] <= {i4.hour, 5'd0};
		 endcase // case (today_traffic[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd1
	   
	   3'd2 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (today_traffic[i]) inside
		   [10'd1 : 10'd2] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd8};
		   10'd3 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd7};
		   10'd4 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd6};
		   [10'd5 : 10'd6] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd5};
		   [10'd7 : 10'd8] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd4};
		   10'd9 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd3};
		   10'd10 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd2};
		   [10'd11 : 10'd12] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd1};
		   default : i4.traffic_ranked_data[i] <= {i4.hour, 5'd0};
		 endcase // case (today_traffic[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd2
	   
	   3'd3 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (today_traffic[i]) inside
		   [10'd1 : 10'd2] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd8};
		   [10'd3 : 10'd4] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd7};
		   [10'd5 : 10'd6] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd6};
		   [10'd7 : 10'd8] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd5};
		   [10'd9 : 10'd10] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd4};
		   [10'd11 : 10'd12] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd3};
		   [10'd13 : 10'd14] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd2};
		   [10'd15 : 10'd16] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd1};
		   default : i4.traffic_ranked_data[i] <= {i4.hour, 5'd0};
		 endcase // case (today_traffic[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd3
	   
	   3'd4 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (today_traffic[i]) inside
		   10'd1 : i4.traffic_ranked_data[i] <= {i4.hour, 5'd8};
		   [10'd2 : 10'd4] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd7};
		   [10'd5 : 10'd7] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd6};
		   [10'd8 : 10'd10] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd5};
		   [10'd11 : 10'd13] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd4};
		   [10'd14 : 10'd16] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd3};
		   [10'd17 : 10'd18] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd2};
		   [10'd19 : 10'd20] : i4.traffic_ranked_data[i] <= {i4.hour, 5'd1};
		   default : i4.traffic_ranked_data[i] <= {i4.hour, 5'd0};
		 endcase // case (today_traffic[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd4
	   default : day <= day;
	 endcase // case (day)
	 i4.op2 <= WRITE;
      end // if (i4.op1 == READ)
      else
	i4.op2 <= READ;
   end // always_ff @ (posedge i4.clk)

   always @(posedge i4.clk) begin
      automatic time current_time;
      if (i4.op1 == READ) begin
	 CHECK_RANK : begin
	    assert (i4.traffic_ranked_data[i4.hour][4:0] inside {5'd1, 5'd8}) begin
	       $display ("CHECK_RANK PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CEHCK_RANK FAIL %0t\n", current_time);
	    end
	 end
      end // if (i4.op1 == READ)
   end // always @ (posedge i4.clk)
   
endmodule // rank_calculator
