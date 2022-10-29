// =============================================================================
// Filename: FIR_filter.v
// Author: XIE BAOHUI
// Email: bxieaf@connect.ust.hk
// Affiliation: Hong Kong University of Science and Technology
// -----------------------------------------------------------------------------
//
// This file implements an 6 tap FIR_filter.
// The FIR_filter accepts 6 coefficient, and user can control the number of tap in the range of
// 2 to 6 by sending 3 bit control word. The relation of input operands with output
// results can be expressed as follows:
//
//                y[n] = a0*x[n]+a1*x[n-1]+a2*x[n-2]+a3*x[n-3]+a4*x[n-4]+a5*x[n-5]
//
// =============================================================================
`timescale 1ns/1ps
module FIR_filter#(parameter width = 16)(
	output wire signed [2*width-1:0] outData,
	input wire signed [width-1:0] inData,
	input wire [2:0] tap_control,
	input wire reset,
	input wire clk
);

wire signed [width-1:0] ai[5:0];	//filter coefficient ai
reg signed [width-1:0] xi[5:0];	//register for input data
reg signed [2*width-1:0] product[5:0];
reg signed [2*width-1:0] sum;
integer i;
assign ai[0]  =  16'd6;
assign ai[1]  =  16'd5;
assign ai[2]  =  16'd4;
assign ai[3]  =  16'd3;
assign ai[4]  =  16'd2;
assign ai[5]  =  16'd1;
always @(posedge clk or negedge reset) begin
	if(!reset) begin
		for (i=0; i<6; i=i+1) begin: resetData
			xi[i] <= 16'b0000000000000000;
			product[i] <= 32'b00000000000000000000000000000000;
		end
		sum <= 32'b00000000000000000000000000000000;
	end else begin
		xi[0] <= inData;
		for (i=0; i<5; i=i+1) begin: RegisterShift_inData
			xi[i+1] <= xi[i];
		end
		case(tap_control)
		3'b010: begin
			product[0] <= ai[0] * xi[0];
			product[1] <= ai[1] * xi[1];
			sum <= product[0] + product[1];
 		end
		3'b011: begin
			product[0] <= ai[0] * xi[0];
			product[1] <= ai[1] * xi[1];
			product[2] <= ai[2] * xi[2];
			sum <= product[0] + product[1] + product[2];
		end
		3'b100: begin
			product[0] <= ai[0] * xi[0];
			product[1] <= ai[1] * xi[1];
			product[2] <= ai[2] * xi[2];
			product[3] <= ai[3] * xi[3];
			sum <= product[0] + product[1] + product[2] + product[3];
		end
		3'b101: begin
			product[0] <= ai[0] * xi[0];
			product[1] <= ai[1] * xi[1];
			product[2] <= ai[2] * xi[2];
			product[3] <= ai[3] * xi[3];
			product[4] <= ai[4] * xi[4];
			sum <= product[0] + product[1] + product[2] + product[3] + product[4];
		end
		3'b110: begin
			product[0] <= ai[0] * xi[0];
			product[1] <= ai[1] * xi[1];
			product[2] <= ai[2] * xi[2];
			product[3] <= ai[3] * xi[3];
			product[4] <= ai[4] * xi[4];
			product[5] <= ai[5] * xi[5];
			sum <= product[0] + product[1] + product[2] + product[3] + product[4] + product[5];
		end
		default: begin
			product[0] <= ai[0] * xi[0];
			product[1] <= ai[1] * xi[1];
			sum <= product[0] + product[1];
		end
	endcase
	end
end


assign outData = sum;
endmodule
