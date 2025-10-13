module CLOCK (SYSTEM_BUS.CLOCK i0);

   logic S_CLK = 1;
   logic M_CLK = 1;

   always_ff @(posedge i0.CLK) begin
      if (i0.SECOND == 29) begin
	 S_CLK <= ~S_CLK;
	 i0.SECOND <= i0.SECOND + 1;
      end
      else if (i0.SECOND == 59) begin
	 i0.SECOND <= 0;
	 S_CLK <= ~S_CLK;
      end
      else begin
	 i0.SECOND <= i0.SECOND + 1;
      end
   end // always_ff @ (posedge i0.CLK or negedge rstn)

   always_ff @(posedge S_CLK) begin
      if (i0.MINUTE == 29) begin
	 M_CLK <= ~M_CLK;
	 i0.MINUTE <= i0.MINUTE + 1;
      end
      else if (i0.MINUTE == 59) begin
	 i0.MINUTE <= 0;
	 M_CLK <= ~M_CLK;
      end
      else begin
	 i0.MINUTE <= i0.MINUTE + 1;
      end
   end // always_ff @ (posedge S_CLK or negedge i0.rstn)

   always_ff @(posedge M_CLK) begin
      if (i0.HOUR == 23) begin
	 i0.HOUR <= 0;
      end
      else begin
	 i0.HOUR <= i0.HOUR + 1;
      end
   end // always_ff @ (posedge M_CLK or negedge i0.rstn)
   
endmodule // clock
