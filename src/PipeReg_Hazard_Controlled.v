module PipeReg_Hazard_Controlled #(parameter WIDTH=8)(
    input clk, reset,
    input flush, stall,
    input [(WIDTH-1):0] d,
	
    output reg [(WIDTH-1):0] q
    );
    
    always @(posedge clk or posedge reset) begin   
        if (reset) q <= 0; 
        else if (flush) q <= 0;
        else if (~stall) q <= d;  
    end  
endmodule