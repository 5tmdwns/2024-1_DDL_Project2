module CONTROLLER (SYSTEM_BUS.CONTROLLER i1);

   logic [6:0] COUNTRY_CAR_NUMBER = 0;
   bit [2:0] PREV_COUNTRY_CAR_NUM, PREV_CURRENT_TRAFFIC_AMOUNT;
   MEM_OP OP;

   always_ff @(posedge i1.CLK) begin
      PREV_COUNTRY_CAR_NUM <= i1.COUNTRY_CAR_NUM;
      PREV_CURRENT_TRAFFIC_AMOUNT <= i1.CURRENT_TRAFFIC_AMOUNT;
   end

   always_ff @(posedge i1.CLK) begin
      if (i1.COUNTRY_CAR_NUM != PREV_COUNTRY_CAR_NUM) begin
	 if (i1.MAIN_LIGHT[0] == 1) begin
	    COUNTRY_CAR_NUMBER <= COUNTRY_CAR_NUMBER + i1.COUNTRY_CAR_NUM;
	    if (COUNTRY_CAR_NUMBER > 30) begin
	       i1.COUNTRY_PULSE <= 1;
	       COUNTRY_CAR_NUMBER <= 0;
	    end
	    else begin
	       i1.COUNTRY_PULSE <= 0;
	    end
	 end
	 else if (i1.MAIN_LIGHT[0] == 0) begin
	    COUNTRY_CAR_NUMBER <= 0;
	    i1.COUNTRY_PULSE <= 0;
	 end
      end // if (i1.COUNTRY_CAR_NUM != PREV_COUNTRY_CAR_NUM)
      else begin
	 i1.COUNTRY_PULSE <= 0;
      end // else: !if(i1.COUNTRY_CAR_NUM != PREV_COUNTRY_CAR_NUM)
   end // always_ff @ (posedge i1.CLK)

   always_ff @(posedge i1.CLK) begin
      if (i1.CURRENT_TRAFFIC_AMOUNT != PREV_CURRENT_TRAFFIC_AMOUNT) begin
	 i1.OP1 <= WRITE;
	 i1.ACCUM_DATA1[14:10] <= i1.HOUR;
	 i1.ACCUM_DATA1[9:0] <= i1.CURRENT_TRAFFIC_AMOUNT + i1.ACCUM_DATA2[14:5];
      end
      else if (i1.OP2 == WRITE)
	 i1.LIGHT_RANK[4:0] <= i1.ACCUM_DATA2[4:0];
      else
	i1.OP1 <= READ;
   end // always_ff @ (posedge i1.CLK)

   always @(posedge i1.CLK) begin
      automatic time current_time = $time;
      if (i1.MAIN_LIGHT[0] == 1) begin
	 CHECK_COUNTRY_CAR_NUM : begin
	    assert (COUNTRY_CAR_NUMBER != 0) begin
	       $display("CHECK_COUNTRY_CAR_NUM PASS %0t", $time);
	    end
	    else begin
	       #1 $error("CHECK_COUNTRY_CAR_NUM FAIL %0t\n", current_time);
	    end
	 end
      end // if (i1.MAIN_LIGHT[0] == 1)
      if (COUNTRY_CAR_NUMBER > 30) begin
	 CHECK_PULSE : begin
	    assert (i1.COUNTRY_PULSE == 1) begin
	       $display("CHECK_PULSE PASS %0t", $time);
	    end
	    else begin
	       #1 $error("CHECK_PULSE FAIL %0t\n", current_time);
	    end
	 end
      end
      if (i1.CURRENT_TRAFFIC_AMOUNT != PREV_CURRENT_TRAFFIC_AMOUNT) begin
	 CHECK_WRITE : begin
	    assert (i1.OP1 == 1) begin
	       $display("CHECK_WRITE PASS %0t", $time);
	    end
	    else begin
	       #1 $error("CHECK_WRITE FAIL %0t\n", current_time);
	    end
	 end
      end
   end // always @ (posedge i1.CLK)
   
endmodule // CONTROLLER
