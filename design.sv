// Code your design here
module fifo_fsm #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH= 8,
    parameter PTR_WIDTH = 3,
    parameter CNT_WIDTH = 4

)( input clk,rst,wr_en,rd_en,
    input [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,
    output empty,full
);
// FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Read / Write pointers
  reg [PTR_WIDTH-1:0] wr_ptr;
  reg [PTR_WIDTH-1:0] rd_ptr;

    // Number of elements currently in FIFO
   reg [CNT_WIDTH-1:0] count;


    // FSM states
    parameter EMPTY= 2'b00;
    parameter PARTIAL = 2'b01;
    parameter FULL = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;


    // Flags
    assign empty= (state == EMPTY);
    assign full= (state == FULL);


    // NEXT STATE LOGIC
    always @(*) begin

        next_state = state;
      case (state)

            EMPTY: begin

                if (wr_en && !rd_en)
                    next_state = PARTIAL;

                else if (wr_en && rd_en)
                    next_state = PARTIAL;

                else
                    next_state = EMPTY;

            end


            PARTIAL: begin

                // Write only
                if (wr_en && !rd_en) begin

                    if (count == DEPTH-1)
                        next_state = FULL;
                    else
                        next_state = PARTIAL;

                end

                // Read only
                else if (rd_en && !wr_en) begin

                    if (count == 1)
                        next_state = EMPTY;
                    else
                        next_state = PARTIAL;
                end

               else
                    next_state = PARTIAL;

            end


            FULL: begin

                if (rd_en)
                    next_state = PARTIAL;

                else
                    next_state = FULL;

            end


            default:
                next_state = EMPTY;

        endcase

    end

    // SEQUENTIAL LOGIC
    always @(posedge clk) begin

        if (rst) begin

            state    <= EMPTY;
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            count    <= 0;
            data_out <= 0;

        end

        else begin

            state <= next_state;


            // WRITE
            if (wr_en && !full) begin

              mem[wr_ptr] <= data_in;
              wr_ptr <= wr_ptr + 1;

            end

            // READ
            if (rd_en && !empty) begin

               data_out <= mem[rd_ptr];
              rd_ptr <= rd_ptr + 1;

            end


            // COUNT
            case ({wr_en && !full, rd_en && !empty})

              2'b10: count <= count + 1'b1; // write only
              2'b01: count <= count - 1'b1; // read only
              2'b11: count <= count;        // both
              default: count <= count;      // neither

            endcase

        end
    end

endmodule