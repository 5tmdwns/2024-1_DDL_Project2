`timescale 1ns/1ps

module tb_project2(/*AUTOARG*/
	      // Outputs
	      countryLight, mainLight,
	      // Inputs
	      clk, main_traffic, country_traffic
	      );
   input logic clk;
   input bit [2:0] main_traffic;
   input bit [2:0] country_traffic;
   output logic [1:0] countryLight;
   output logic [1:0] mainLight;

   logic [2:0]	      prev_tb_m_traffic = 3'b000;
   logic [2:0]	      prev_tb_country_traffic = 3'b000;

   top
     k0
       (/*AUTOINST*/
	// Outputs
	.countryLight			(countryLight[1:0]),
	.mainLight			(mainLight[1:0]),
	// Inputs
	.clk				(clk),
	.main_traffic			(main_traffic[2:0]),
	.country_traffic		(country_traffic[2:0]));

   system_bus
     sys_b
       (/*AUTOINST*/
	// Outputs
	.countryLight			(countryLight[2:0]),
	.mainLight			(mainLight[2:0]),
	// Inputs
	.clk				(clk),
	.main_traffic			(main_traffic[2:0]),
	.country_traffic		(country_traffic[2:0]));

   always #1 clk=~clk;

   initial begin
      clk = 0;
      main_traffic = 3'b010;
      country_traffic = 0;
      #10;
      for (int j = 0; j < 120; j ++) begin
	 for (int i = 0; i < 120; i ++) begin
	    country_traffic = (prev_tb_country_traffic + 3'b001 + i) % 8;
	    if (country_traffic == prev_tb_country_traffic)
	      country_traffic = (country_traffic + 3'b001) % 8;
	    prev_tb_country_traffic = country_traffic;
	 end
	 main_traffic = (prev_tb_m_traffic + 3'b001 + j) % 5;
	 prev_tb_m_traffic = main_traffic;
      end
      #1000
	$finish();
   end
endmodule
