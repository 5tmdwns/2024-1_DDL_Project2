module TB_TOP(/*AUTOARG*/
	      // Outputs
	      COUNTRYLIGHT, MAINLIGHT,
	      // Inputs
	      MAIN_TRAFFIC, COUNTRY_TRAFFIC
	      );
   input bit [2:0] MAIN_TRAFFIC;
   input bit [2:0] COUNTRY_TRAFFIC;
   output logic [1:0] COUNTRYLIGHT;
   output logic [1:0] MAINLIGHT;

   logic 	      CLK;
   logic [2:0] 	      PREV_TB_M_TRAFFIC = 3'b000;
   logic [2:0] 	      PREV_TB_COUNTRY_TRAFFIC = 3'b000;

   TOP
     DUT
       (/*AUTOINST*/
	// Outputs
	.COUNTRYLIGHT			(COUNTRYLIGHT[1:0]),
	.MAINLIGHT			(MAINLIGHT[1:0]),
	// Inputs
	.CLK				(CLK),
	.MAIN_TRAFFIC			(MAIN_TRAFFIC[2:0]),
	.COUNTRY_TRAFFIC		(COUNTRY_TRAFFIC[2:0]));

   SYSTEM_BUS
     SYS_B
       (/*AUTOINST*/
	// Outputs
	.COUNTRYLIGHT			(COUNTRYLIGHT[1:0]),
	.MAINLIGHT			(MAINLIGHT[1:0]),
	// Inputs
	.CLK				(CLK),
	.MAIN_TRAFFIC			(MAIN_TRAFFIC[2:0]),
	.COUNTRY_TRAFFIC		(COUNTRY_TRAFFIC[2:0]));

   always #1 CLK=~CLK;

   initial begin
      CLK = 0;
      MAIN_TRAFFIC = 3'b010;
      COUNTRY_TRAFFIC = 0;
      #10;
      for (int j = 0; j < 120; j ++) begin
	 for (int i = 0; i < 120; i ++) begin
	    COUNTRY_TRAFFIC = (PREV_TB_COUNTRY_TRAFFIC + 3'b001 + i) % 8;
	    if (COUNTRY_TRAFFIC == PREV_TB_COUNTRY_TRAFFIC)
	      COUNTRY_TRAFFIC = (COUNTRY_TRAFFIC + 3'b001) % 8;
	    PREV_TB_COUNTRY_TRAFFIC = COUNTRY_TRAFFIC;
	    #60;
	 end
	 MAIN_TRAFFIC = (PREV_TB_M_TRAFFIC + 3'b001 + j) % 5;
	 if (MAIN_TRAFFIC == PREV_TB_M_TRAFFIC)
	   MAIN_TRAFFIC = (MAIN_TRAFFIC + 3'b001) % 5;
	 PREV_TB_M_TRAFFIC = MAIN_TRAFFIC;
      end
      #1000
	$finish();
   end
endmodule
