module MEMORY (SYSTEM_BUS.MEM i3);

   bit [19:0] MEMORY[23:0];
   bit [4:0]		i;

   always_ff @(posedge i3.CLK) begin
      if (i3.OP1 == WRITE) begin
	 MEMORY[i3.HOUR][19:5] <= i3.ACCUM_DATA1[14:0];
	 for (i = 0; i < 24; i ++) begin
	    i3.TRAFFIC_DATA[i][14:0] <= MEMORY[i][19:5];
	 end
      end
      else if (i3.OP2 == WRITE) begin
	 for (i = 0; i < 24; i ++) begin
	    MEMORY[i][4:0] <= i3.TRAFFIC_RANKED_DATA[i][4:0];
	 end
	 i3.ACCUM_DATA2[14:0] <= MEMORY[i3.HOUR][14:0];
      end
      else begin
	 MEMORY[i3.HOUR][19:5] <= i3.ACCUM_DATA1[14:0];
	 i3.ACCUM_DATA2[14:0] <= MEMORY[i3.HOUR][14:0];
      end
   end // always_ff @ (posedge i3.CLK)

   always @(posedge i3.CLK) begin
      automatic time current_time;
      if (i3.OP2 == WRITE) begin
	 CHECK_ACCUM_DATA : begin
	    assert (i3.ACCUM_DATA1[9:0] == i3.ACCUM_DATA2[14:5]) begin
	       $display ("CEHCK_ACCUM_DATA PASS %0t", $time);
	    end
	    else begin
	       current_time = $time;
	       #1 $error ("CHECK_ACCUM_DATA FAIL %0t\n", current_time);
	    end
	 end
      end // if (i3.OP2 == WRITE)
   end // always @ (posedge i3.CLK)
   
endmodule // MEMORY
