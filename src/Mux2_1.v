module Mux2_1 #(parameter mux_width=32)
(   input [(mux_width-1):0] a, b,
    input sel,
	
    output [(mux_width-1):0] y
    );
    
    assign y = sel ? b : a;
	
endmodule