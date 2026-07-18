module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/soc_top.fst");
    $dumpvars(0, soc_top);
end
endmodule
