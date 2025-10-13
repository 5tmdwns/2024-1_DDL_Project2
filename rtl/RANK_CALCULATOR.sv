module RANK_CALCULATOR (SYSTEM_BUS.RANK_CAL i4);

   bit [9:0] 	TODAY_TRAFFIC[24];
   bit [5:0] 	i;
   bit [2:0] 	DAY;

   always_ff @(posedge i4.CLK) begin
      if ((i4.HOUR == 5'd23) && (i4.MINUTE == 6'd59) && (i4.SECOND == 6'd59)) begin
	 if (DAY > 4)
	   DAY <= 0;
	 else
	   DAY <= DAY + 1;
      end
      else if (i4.OP1 == READ) begin
	 for (i = 0; i < 24; i ++) begin
	    TODAY_TRAFFIC[i][9:0] <= i4.TRAFFIC_DATA[i][9:0];
	 end
	 case (DAY)
	   3'd0 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (TODAY_TRAFFIC[i])
		   10'b00000_00001 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd7};
		   10'b00000_00010 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd5};
		   10'b00000_00011 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd3};
		   10'b00000_00100 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd1};
		   default : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd0};
		 endcase // case (TODAY_TRAFFIC[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd0
	   
	   3'd1 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (TODAY_TRAFFIC[i]) 
		   10'b00000_00001 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd8};
		   10'b00000_00010 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd7};
		   10'b00000_00011 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd6};
		   10'b00000_00100 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd5};
		   10'b00000_00101 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd4};
		   10'b00000_00110 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd3};
		   10'b00000_00111 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd2};
		   10'b00000_01000 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd1};
		   default : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd0};
		 endcase // case (TODAY_TRAFFIC[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd1
	   
	   3'd2 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (TODAY_TRAFFIC[i]) inside
		   [10'd1 : 10'd2] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd8};
		   10'd3 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd7};
		   10'd4 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd6};
		   [10'd5 : 10'd6] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd5};
		   [10'd7 : 10'd8] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd4};
		   10'd9 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd3};
		   10'd10 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd2};
		   [10'd11 : 10'd12] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd1};
		   default : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd0};
		 endcase // case (TODAY_TRAFFIC[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd2
	   
	   3'd3 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (TODAY_TRAFFIC[i]) inside
		   [10'd1 : 10'd2] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd8};
		   [10'd3 : 10'd4] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd7};
		   [10'd5 : 10'd6] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd6};
		   [10'd7 : 10'd8] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd5};
		   [10'd9 : 10'd10] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd4};
		   [10'd11 : 10'd12] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd3};
		   [10'd13 : 10'd14] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd2};
		   [10'd15 : 10'd16] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd1};
		   default : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd0};
		 endcase // case (TODAY_TRAFFIC[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd3
	   
	   3'd4 : begin
	      for (i = 0; i < 24; i ++) begin
		 case (TODAY_TRAFFIC[i]) inside
		   10'd1 : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd8};
		   [10'd2 : 10'd4] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd7};
		   [10'd5 : 10'd7] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd6};
		   [10'd8 : 10'd10] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd5};
		   [10'd11 : 10'd13] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd4};
		   [10'd14 : 10'd16] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd3};
		   [10'd17 : 10'd18] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd2};
		   [10'd19 : 10'd20] : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd1};
		   default : i4.TRAFFIC_RANKED_DATA[i] <= {i4.HOUR, 5'd0};
		 endcase // case (TODAY_TRAFFIC[i])
	      end // for (i = 0; i < 24; i ++)
	   end // case: 3'd4
	   default : DAY <= DAY;
	 endcase // case (DAY)
	 i4.OP2 <= WRITE;
      end // if (i4.OP1 == READ)
      else
	i4.OP2 <= READ;
   end // always_ff @ (posedge i4.CLK)

   always @(posedge i4.CLK) begin
      automatic time current_time;
      if (i4.OP1 == READ) begin
	 CHECK_RANK : begin
	    assert (i4.TRAFFIC_RANKED_DATA[i4.HOUR][4:0] inside {5'd1, 5'd8}) begin
	       $display ("CHECK_RANK PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CEHCK_RANK FAIL %0t\n", current_time);
	    end
	 end
      end // if (i4.OP1 == READ)
   end // always @ (posedge i4.CLK)
   
endmodule // RANK_CALCULATOR
