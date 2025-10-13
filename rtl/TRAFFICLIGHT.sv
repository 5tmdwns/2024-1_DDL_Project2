module TRAFFICLIGHT(SYSTEM_BUS.TRAFFIC_LIGHT i2);

   enum logic [1:0] {S0 = 2'b00, S1, S2, S3} STATE;
	typedef enum logic [1:0] {RED = 2'b00, GREEN, YELLOW} LIGHTSTATE;
   logic PREV_PULSE, FINAL_PULSE, MAIN_CNT_ENABLE, CNTRY_CNT_ENABLE = 1'b0;
   logic [8:0] CNT = 0;

   LIGHTSTATE MAINLIGHT = GREEN;
   LIGHTSTATE CNTRYLIGHT = RED;

   always_ff @(posedge i2.CLK) begin
      i2.CURRENT_TRAFFIC_AMOUNT <= i2.MAIN_TRAFFIC;
      i2.COUNTRY_CAR_NUM <= i2.COUNTRY_TRAFFIC;
      i2.MAIN_LIGHT <= MAINLIGHT;
      i2.MAINLIGHT <= MAINLIGHT;
      i2.COUNTRYLIGHT <= CNTRYLIGHT;
      
      if (MAIN_CNT_ENABLE == 1'b1) begin
	 if (i2.LIGHT_RANK[4:0] inside {5'b00001, 5'b01000}) begin
	    if (CNT >= (750 - (5'd40 * i2.LIGHT_RANK[4:0]))) begin
	       STATE <= S1;
	       MAIN_CNT_ENABLE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end
	 else begin
	    if (CNT >= 360) begin
	       STATE <= S1;
	       MAIN_CNT_ENABLE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end // else: !if(i2.LIGHT_RANK inside {5'b00001, 5'b01010})
      end // if (MAIN_CNT_ENABLE == 1'b1)
      else if (CNTRY_CNT_ENABLE == 1'b1) begin
	 if (FINAL_PULSE == 1'b1) begin
	    if (CNT >= 240) begin
	       STATE <= S3;
	       CNTRY_CNT_ENABLE <= 1'b0;
	       FINAL_PULSE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end
	 else begin
	    if (CNT >= 120) begin
	       STATE <= S3;
	       CNTRY_CNT_ENABLE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end // else: !if(FINAL_PULSE == 1'b1)
      end // if (CNTRY_CNT_ENABLE == 1'b1)
      else
	CNT <= 0;
   end // always_ff @ (posedge i2.CLK)

   always_ff @(posedge i2.CLK) begin
      PREV_PULSE <= i2.COUNTRY_PULSE;
      if ((i2.COUNTRY_PULSE == 1'b0) && (PREV_PULSE == 1'b1))
	FINAL_PULSE <= 1'b1;
      else begin
	 case (STATE)
	   S0 : begin
	      if (FINAL_PULSE == 1'b1)
		STATE <= S1;
	      else
		MAIN_CNT_ENABLE <= 1'b1;
	   end
	   S1 : begin
	      MAIN_CNT_ENABLE <= 1'b0;
	      STATE <= S2;
	   end
	   S2 : CNTRY_CNT_ENABLE <= 1'b1;
	   S3 : begin
	      CNTRY_CNT_ENABLE <= 1'b0;
	      STATE <= S0;
	   end
	   default : STATE <= S0;
	 endcase // case (STATE)
      end // else: !if((i2.COUNTRY_PULSE == 1'b0) && (PREV_PULSE == 1'b1))
   end // always_ff @ (posedge i2.CLK)

   always @(*) begin
      case (STATE)
	S0 : MAINLIGHT = GREEN;
	S1 : MAINLIGHT = YELLOW;
	S2 : MAINLIGHT = RED;
	S3 : MAINLIGHT = RED;
	default : MAINLIGHT = GREEN;
      endcase // case (STATE)
   end

   always @(*) begin
      case (STATE)
	S0 : CNTRYLIGHT = RED;
	S1 : CNTRYLIGHT = RED;
	S2 : CNTRYLIGHT = GREEN;
	S3 : CNTRYLIGHT = YELLOW;
	default : CNTRYLIGHT = RED;
      endcase // case (STATE)
   end

   always @(posedge i2.CLK) begin
      automatic time current_time;
      if (i2.COUNTRY_PULSE == 1) begin
	 CHECK_FINAL_PULSE : begin
	    assert (FINAL_PULSE == 1) begin
	       $display ("CHECK_FINAL_PULSE PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CHECK_FINAL_PULSE FAIL %0t\n", current_time);
	    end
	 end
      end
      if (i2.LIGHT_RANK inside {5'b00001, 5'b01000}) begin
	 CHECK_CNT : begin
	    assert (CNT > 361) begin
	       $display ("CHECK_CNT PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CHECK_CNT FAIL %0t\n", current_time);
	    end
	 end
      end
   end // always @ (posedge i2.CLK)

endmodule // TRAFFICLIGHT
