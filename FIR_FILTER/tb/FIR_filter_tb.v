// =============================================================================
// Filename: FIR_filter_tb.v
// Author: XIE BAOHUI
// Email: bxieaf@connect.ust.hk
// Affiliation: Hong Kong University of Science and Technology
// -----------------------------------------------------------------------------
//
// This file exports the testbench for FIR_filter module.
// =============================================================================
`timescale 1ns/1ps
module FIR_filter_tb;
// ----------------------------------
// Interface of the FIR filter module
// ----------------------------------
//input
reg clk ;
reg reset ;
reg [2:0] tap_control;
reg signed [15:0] inData;
//output
wire signed [31:0] outData;
//inputSignal file
reg [15:0] signal[0:350];
integer i;
integer outputSignal;
// ----------------------------------
// Instantiate the FIR filter
// ----------------------------------
FIR_filter uut (outData[31:0], inData[15:0], tap_control[2:0], reset, clk);

`ifdef SDF_FILE
initial begin
$sdf_annotate(`SDF_FILE, uut);
end
`endif

//=====================================
//clk generating
initial begin
   clk = 1'b0 ;
   forever begin
    #50;
    clk = ~clk;
    end
end
 
//============================
//  reset 
initial begin
   reset = 1'b1 ;
   #10 reset = 1'b0 ;
   #10 reset =1'b1;
end
initial $readmemb("/afs/ee.ust.hk/staff/ee/bxieaf/eesm5020/FIR_FILTER/matlab/inputSignal.txt", signal);
//====================================================
//open the target file before writing
initial begin
	outputSignal=$fopen("/afs/ee.ust.hk/staff/ee/bxieaf/eesm5020/FIR_FILTER/matlab/outputSignal.txt");
end

//=======================================
// read signal data into register
    
initial begin: inputSin
	tap_control = 3'b110;	//define number of tab
	for(i=0;i<350;i=i+1) begin: inputData
		inData=signal[i];
		#50;
		$fwrite(outputSignal,"%d\n",outData);
		#50;
	end
	$fclose(outputSignal);
	$finish;
end
 
endmodule