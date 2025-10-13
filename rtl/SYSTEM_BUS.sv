interface SYSTEM_BUS (
		      input logic CLK,
		      input logic [2:0] MAIN_TRAFFIC,
		      input logic [2:0] COUNTRY_TRAFFIC,
		      output logic [1:0] COUNTRYLIGHT,
		      output logic [1:0] MAINLIGHT
		      );

   logic 				 COUNTRY_PULSE = 0;
   logic [1:0] 				 MAIN_LIGHT;
   logic [2:0] 				 CURRENT_TRAFFIC_AMOUNT;
   logic [2:0] 				 COUNTRY_CAR_NUM;
   bit [4:0] 				 HOUR, LIGHT_RANK;
   bit [5:0] 				 MINUTE, SECOND;
   bit	 [14:0] 			 ACCUM_DATA1, ACCUM_DATA2;
   bit	 [9:0] 				 TRAFFIC_RANKED_DATA [23:0];
   bit	 [14:0] 				 TRAFFIC_DATA [23:0];
   MEM_OP OP1;
   MEM_OP OP2;

   modport CLOCK (
		  input CLK,
		  output HOUR, MINUTE, SECOND
		  );

   modport CONTROLLER (
		       input MAIN_LIGHT, CURRENT_TRAFFIC_AMOUNT, COUNTRY_CAR_NUM, ACCUM_DATA2, HOUR, CLK, OP2,
		       output COUNTRY_PULSE, LIGHT_RANK, ACCUM_DATA1, OP1
		       );

   modport TRAFFIC_LIGHT (
			  input COUNTRY_PULSE, LIGHT_RANK, MAIN_TRAFFIC, COUNTRY_TRAFFIC, CLK,
			  output MAINLIGHT, MAIN_LIGHT, COUNTRYLIGHT, CURRENT_TRAFFIC_AMOUNT, COUNTRY_CAR_NUM
			  );

   modport MEM (
		 input HOUR, ACCUM_DATA1, TRAFFIC_RANKED_DATA, CLK, OP1, OP2,
		 output TRAFFIC_DATA, ACCUM_DATA2
		 );

   modport RANK_CAL (
		 input TRAFFIC_DATA, HOUR, MINUTE, SECOND, CLK, OP1,
		 output TRAFFIC_RANKED_DATA, OP2
		 );

endinterface // SYSTEM_BUS
