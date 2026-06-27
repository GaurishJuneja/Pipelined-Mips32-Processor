module Hazard_Detection(

    input branch_sel, jump_sel, ID_EX_mem_read_en,
    input [4:0] IF_ID_rs_addr, IF_ID_rt_addr, ID_EX_reg_dest,

    output reg flush, stall
    );
    
    always @(*) begin
        
        /** Load-Use Read after Write (RAW) Data Hazard **/
        
        if ( (ID_EX_mem_read_en == 1'b1) &
            ( (ID_EX_reg_dest == IF_ID_rs_addr) | (ID_EX_reg_dest == IF_ID_rt_addr) ) )
            stall = 1'b1;
        
        else stall = 1'b0;
	
	
	/** Control Hazard **/
        
        flush = (branch_sel | jump_sel);
	
    end
endmodule