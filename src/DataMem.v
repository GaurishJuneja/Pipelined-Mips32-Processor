
module DataMem(
    input clk,
    input mem_read_en, mem_write_en,
    input [31:0] mem_addr, mem_write_data,
	
    output [31:0] mem_read_data
	);
    
    integer i;
    reg [31:0] ram [255:0];  
    wire [7:0] ram_addr = mem_addr[9:2];  
    
	
    initial begin  
        for(i = 0; i < 256; i = i + 1) ram[i] <= 32'd0;  
    end
	
	always @(posedge clk) begin  
		if (mem_write_en) ram[ram_addr] <= mem_write_data;  
	end  
      
    assign mem_read_data = (mem_read_en==1'b1) ? ram[ram_addr]: 32'd0;
      
endmodule