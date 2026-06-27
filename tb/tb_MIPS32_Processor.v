`timescale 1ns/1ps
module tb_MIPS32_Processor;

reg clk;
reg reset;
wire [31:0] result;

integer pass_count=0;
integer fail_count=0;

MIPS32_Processor uut(
    .clk(clk),
    .reset(reset),
    .result(result)
);

// Clock
initial begin
    clk=0;
    forever #10 clk=~clk;
end

// VCD
initial begin
    $dumpfile("mips32_processor.vcd");
    $dumpvars(0,tb_MIPS32_Processor);
end

task check_mem;
input integer addr;
input [31:0] expected;
input [256*8-1:0] name;
begin
    if(uut.Data_Mem.ram[addr]===expected) begin
        pass_count=pass_count+1;
        $display("[PASS] %0s : MEM[%0d]=%h",name,addr,uut.Data_Mem.ram[addr]);
    end else begin
        fail_count=fail_count+1;
        $display("[FAIL] %0s",name);
        $display("       Expected=%h Actual=%h",expected,uut.Data_Mem.ram[addr]);
    end
end
endtask

initial begin
    reset=1;
    #100;
    reset=0;

    // Initialize data memory exactly as original TB
    uut.Data_Mem.ram[0]=32'h00000001;
    uut.Data_Mem.ram[1]=32'h0fd76e10;
    uut.Data_Mem.ram[2]=32'h5a00429b;
    uut.Data_Mem.ram[3]=32'h14333ffc;
    uut.Data_Mem.ram[4]=32'h321fedcb;
    uut.Data_Mem.ram[5]=32'h80000000;
    uut.Data_Mem.ram[6]=32'h9012fd65;
    uut.Data_Mem.ram[7]=32'habc00237;
    uut.Data_Mem.ram[8]=32'hb54bc031;
    uut.Data_Mem.ram[9]=32'hc187a606;

    // Wait for program completion (fixed deterministic delay)
    #1500;

    // Functional checks
    check_mem(11,32'h0fd76e00,"No Hazard ANDI");
    check_mem(12,32'hf02891ee,"No Hazard NOR");
    check_mem(13,32'h00000001,"No Hazard SLT");
    check_mem(14,32'h7ebb7080,"No Hazard SLL");
    check_mem(15,32'h00000000,"No Hazard SRL");
    check_mem(16,32'hfe000000,"No Hazard SRA");
    check_mem(17,32'h00000000,"No Hazard XOR");
    check_mem(18,32'h0fd76e10,"No Hazard MULT");
    check_mem(19,32'h0fd76e10,"No Hazard DIV");

    check_mem(20,32'h00000d61,"Forward Test 1");
    check_mem(21,32'hf028908e,"Forward Test 2");
    check_mem(22,32'h00000001,"Forward Test 3");
    check_mem(23,32'h5faca000,"Forward Test 4");
    check_mem(24,32'h00bf5940,"Forward Test 5");
    check_mem(25,32'h17eb2800,"Forward Test 6");
    check_mem(26,32'h9fc59375,"Forward Test 7");
    check_mem(27,32'he4e43c50,"Forward Test 8");
    check_mem(28,32'h00000000,"Forward Test 9");

    check_mem(29,32'hd15f1416,"Load Stall RS");
    check_mem(30,32'hb54bc032,"Load Stall RT");
    check_mem(31,32'hc187a606,"Branch Hazard");
    check_mem(32,32'hb54bc031,"Jump Hazard");

    $display("");
    $display("====================================");
    $display("Tests Passed : %0d",pass_count);
    $display("Tests Failed : %0d",fail_count);
    if(fail_count==0)
        $display("RESULT : ALL TESTS PASSED");
    else
        $display("RESULT : TEST FAILED");
    $display("====================================");

    #50;
    $finish;
end

endmodule
