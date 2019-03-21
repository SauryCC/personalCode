// Part 2 skeleton
`timescale 1ns/1ns

module Project
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		GPIO_0,KEY,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	input [11:0]GPIO_0;//9-7clr, 
	input [3:0]KEY;
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	//______________counter
	reg CLOCK_Q;
	
	reg [2:0]counter;
	 always @(posedge CLOCK_50)
	begin
	counter <= counter + 1'b1;
	
	if(counter>=(3'b111))
		begin
		counter <= 3'b000;
		CLOCK_Q = 1;
		end
	else
		CLOCK_Q = 0;
	end//end of counter


	//=======================================================================================
	//Need a 1Hz counter
	reg [26:0]hzcounter;
	reg [5:0]secondcount; //Stores the number of seconds passed since the last clear
	always @(posedge CLOCK_50)
	begin
		hzcounter <= hzcounter + 1'b1;

		if (hzcounter >= (8'd50000000))
		//When the 50MHz clock switches 5e7 times (takes 1 second)
		begin
			hzcounter <= 26'b00000000000000000000000000;
			secondcount <= hzcounter + 1'b1;
		end
	end//End of 1Hz counter

	reg onecycle;
	//Has value 1 if the sensor goes around 1 time
	always @(posedge CLOCK_50)
	begin
		if (secondcount >= (2'd30)) begin //The time for 1 revolution can be reset here
			onecycle <= 1;
		end

		else begin
			onecycle <= 0;
		end
	end
	//=================================================================================================

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(3’b100),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
	
	
	wire Xenable,Yenable;//from fsm to datpath
	wire[3:0] counterwire;
	wire VGAblank;
	
	
	FSM machine (.black(~KEY[2]),
			.plot(~KEY[1]),
			.endX(~KEY[3]),
			.resetN(KEY[0]), 
			.Xenable(Xenable),
			.Yenable(Yenable),
			.plotout(writeEn),
			.counter(counterwire[3:0]),
			.clockQ(CLOCK_Q),
			.VGAblank(VGAblank),
			.onecycle(onecycle),
			);
			
			
	datapath path(.colour(3'b100),
				.resetN(KEY[0]),
				.switchinX(GPIO_0[6:0]),
				.switchinY(GPIO_0[11:7]),
				.Xenable(Xenable),
				.Yenable(Yenable),
				.counter(counterwire[3:0]),
				.Xout(x[7:0]),
				.Yout(y[6:0]),
				.Cout(colour[2:0]),
				.VGAblank(VGAblank),
				.clock_Q(CLOCK_Q)
				);
	
	
	
	
endmodule//=========== end of top module ==============





module FSM (black,plot,endX,resetN, Xenable,Yenable,plotout,counter,clockQ,VGAblank,onecycle);
	input black,plot,resetN,endX,clockQ,onecycle;
	output reg Xenable;
    output reg Yenable;
	output reg [3:0]counter;
	output reg plotout;
	output reg VGAblank;
	localparam loadX = 2'b00, loadY = 2'b01, clear = 2'b10, draw = 2'b11;
	
	reg [1:0] curS,nxtS;//state
	
	
	reg [15:0] counterB;
	
	always @(posedge clockQ)
	begin
		case(curS)
		default:begin curS = loadX; 
					nxtS = loadX;
					
					end
					
		loadX: begin
					VGAblank <= 0;
					plotout = 0;
					Xenable = 1;
					
					if (endX == 1)
					nxtS = loadY;
					else if (black == 1)
					nxtS = clear;
					else
					nxtS = loadX;
					
				end
				
		loadY: begin
				Xenable = 0;
				Yenable = 1;
				if(plot == 1)
					begin
					nxtS = draw;
					Yenable = 0;
					end
				else if (black == 1)
					nxtS = clear;
				else
				nxtS = loadY;
				end
				
		clear: begin
				VGAblank <= 1;
				plotout = 1;
				if(counterB[15:0] <= 16'd38400)
					nxtS = clear;
				else if (onecycle == 1) begin      // Clears the screen if the sensor finishes rotating 1 cycle
					nxtS = clear;
				end
				else
					begin
					nxtS = loadX;
					plotout = 0;
					end
				end
				
		draw: begin
				if(counter[3:0] !=4'b1111)
					begin
					plotout = 1;
					nxtS = draw;
					end
					
				else 
					begin
				plotout = 0;
				nxtS = loadX;
				//counter[3:0] = 3'b000;
					end
				end//draw
	endcase
	end
	

	
	always @ (negedge clockQ)
		begin
		
		if(resetN == 0)
		curS = loadX;
		else
		curS = nxtS;
		if(plotout == 1)
		begin
		counter <= counter+1;
		counterB <= counterB +1;
		end
		else
		begin
		counter = 4'b0000;
		counterB = 16'd0;
	   end
	end
		

endmodule// end of FSM

module datapath(colour,resetN,switchinX,switchinY,Xenable,Yenable,counter,VGAblank,Xout,Yout,Cout,clock_Q);
	input [2:0]colour ;
	input resetN;
	input [6:0]switchinX;
	input [6:0]switchinY;
	input Xenable, Yenable;
	input [3:0]counter;
	input VGAblank,clock_Q;
	output [7:0]Xout;
	output [6:0]Yout;
	output [2:0]Cout;
	reg [7:0]Xreg;
	reg [6:0]Yreg;
	reg [2:0]Creg;
	
	always@(*)
		begin
		
		if (VGAblank ==1)
			begin
			Xreg[7:0]=blackX[7:0];
			Yreg[6:0]=blackY[6:0];
			end
		
		else if (Xenable == 1)
			begin
			Xreg[6:0] = switchinX[6:0];
			Xreg[7] = 0;
			end
			
		else if(Yenable == 1)
		begin
			Yreg[6:0] = switchinY[6:0];
			Creg[2:0] = colour[2:0];
		end
	
	end
	
	assign Xout[7:0] = (VGAblank == 0)? (Xreg[7:0]+counter[1:0]):Xreg[7:0];
	assign Yout[6:0] = (VGAblank == 0)? (Yreg[6:0]+counter[3:2]):Yreg[6:0];
	assign Cout[2:0] = (VGAblank == 0)? Creg[2:0]:3'b000;
		
		
	
	wire [7:0]blackX;
	wire [6:0]blackY;
	//==================black============
	
	clear_to_black u0 (.VGAblank(VGAblank),
							.reset(resetN), 
							.clock(clock_Q), 
							.xout(blackX[7:0]), 
							.yout(blackY[6:0]),
							);	
	
	
	//end of black
	
endmodule


module clear_to_black (VGAblank, reset, clock, xout, yout, plot);
    input VGAblank, reset, clock;
output reg[7:0] xout;
output reg[6:0] yout;
output reg plot;
 
reg[15:0] counter;
 
always@(posedge clock)
begin
 /*   if (!reset)
 begin
 counter = 15'b0;
 end
 else*/ if (VGAblank == 1 & counter <= 16'd38400)
 begin
     xout = counter[7:0];
yout = counter[15:8];
counter = counter + 1;
//colour = 3'b000;
plot = 1;
 end
 else if (counter >16'd38400)
     counter = 16'd0;
end
 
endmodule
