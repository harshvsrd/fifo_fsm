// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module fifo_fsm_tb;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8;
    parameter PTR_WIDTH  = 3;
    parameter CNT_WIDTH  = 4;

    reg clk;
    reg rst;

    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire empty;
    wire full;

    // DUT

    fifo_fsm #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .PTR_WIDTH(PTR_WIDTH),
        .CNT_WIDTH(CNT_WIDTH)
    ) dut (

        .clk(clk),
        .rst(rst),

        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),

        .data_out(data_out),
        .empty(empty),
        .full(full)
    );


    // CLOCK

    always #5 clk = ~clk;

    // TEST
    initial begin

        clk    = 0;
        rst    = 1;
        wr_en  = 0;
        rd_en  = 0;
        data_in = 0;

        // RESET

        #12;

        rst = 0;

        #10;


        // ---------------------------------------------
        // TC1: FIFO should be EMPTY
        // ---------------------------------------------

        $display("TC1: Check EMPTY");

        if (empty == 1 && full == 0)
            $display("PASS: FIFO is EMPTY");
        else
            $display("FAIL: FIFO is not EMPTY");


        // ---------------------------------------------
        // TC2: WRITE DATA
        // ---------------------------------------------

        $display("TC2: Write 10");

        wr_en  = 1;
        data_in = 8'd10;

        #10;

        wr_en = 0;

        if (empty == 0)
            $display("PASS: FIFO is no longer EMPTY");
        else
            $display("FAIL");


        // ---------------------------------------------
        // TC3: WRITE MORE DATA
        // ---------------------------------------------

        $display("TC3: Write 20,30,40");

        wr_en = 1;

        data_in = 8'd20;
        #10;

        data_in = 8'd30;
        #10;

        data_in = 8'd40;
        #10;

        wr_en = 0;

        $display("FIFO contains 4 elements");


        // ---------------------------------------------
        // TC4: READ
        // ---------------------------------------------

        $display("TC4: Read");

        rd_en = 1;

        #10;

        rd_en = 0;

        $display("DATA OUT = %d", data_out);

        if (data_out == 8'd10)
            $display("PASS: Correct data read");
        else
            $display("FAIL: Incorrect data");


        // ---------------------------------------------
        // TC5: SIMULTANEOUS READ + WRITE
        // ---------------------------------------------

        $display("TC5: Simultaneous READ + WRITE");

        wr_en  = 1;
        rd_en  = 1;
        data_in = 8'd50;

        #10;

        wr_en = 0;
        rd_en = 0;

        $display("DATA OUT = %d", data_out);


        // ---------------------------------------------
        // TC6: FILL FIFO COMPLETELY
        // ---------------------------------------------

        $display("TC6: Filling FIFO");

        wr_en = 1;

        data_in = 8'd60;
        #10;

        data_in = 8'd70;
        #10;

        data_in = 8'd80;
        #10;

        data_in = 8'd90;
        #10;

        wr_en = 0;

        #5;

        if (full)
            $display("PASS: FIFO is FULL");
        else
            $display("FAIL: FIFO should be FULL");


        // ---------------------------------------------
        // TC7: TRY WRITE WHEN FULL
        // ---------------------------------------------

        $display("TC7: Write while FULL");

        wr_en = 1;
        data_in = 8'd100;

        #10;

        wr_en = 0;

        if (full)
            $display("PASS: FIFO remained FULL");
        else
            $display("FAIL");


        // ---------------------------------------------
        // TC8: READ UNTIL EMPTY
        // ---------------------------------------------

        $display("TC8: Emptying FIFO");

        rd_en = 1;

        repeat(8) begin

            #10;

            $display("DATA OUT = %d", data_out);

        end

        rd_en = 0;

        #5;

        if (empty)
            $display("PASS: FIFO is EMPTY again");
        else
            $display("FAIL: FIFO should be EMPTY");


        // ---------------------------------------------
        // TC9: TRY READ WHEN EMPTY
        // ---------------------------------------------

        $display("TC9: Read while EMPTY");

        rd_en = 1;

        #10;

        rd_en = 0;

        if (empty)
            $display("PASS: FIFO remained EMPTY");
        else
            $display("FAIL");


        // ---------------------------------------------
        // END
        // ---------------------------------------------

        #20;

        $display("--------------------------------");
        $display("      TESTBENCH COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule