module apb_slave #(
    parameter int unsigned ADDR_WIDTH = 8,
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned DEPTH      = 1 << ADDR_WIDTH,
    parameter int unsigned WAIT_STATES = 2
) (
    input  logic                  PCLK,
    input  logic                  PRESETn,
    input  logic                  PSEL,
    input  logic                  PENABLE,
    input  logic                  PWRITE,
    input  logic [ADDR_WIDTH-1:0] PADDR,
    input  logic [DATA_WIDTH-1:0] PWDATA,
    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic                  PREADY
);

  logic [DATA_WIDTH-1:0] mem [DEPTH];
  logic                  transfer_complete;
  int unsigned           wait_count;

  assign PREADY = PRESETn && PSEL && PENABLE &&
                  (wait_count >= WAIT_STATES);
  assign transfer_complete = PSEL && PENABLE && PREADY;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      wait_count <= 0;

      foreach (mem[i]) begin
        mem[i] <= '0;
      end
    end else begin
      if (!PSEL || !PENABLE) begin
        wait_count <= 0;
      end else if (wait_count < WAIT_STATES) begin
        wait_count <= wait_count + 1;
      end

      if (transfer_complete && PWRITE) begin
        mem[PADDR] <= PWDATA;
      end
    end
  end

  always_comb begin
    PRDATA = '0;

    if (PRESETn && transfer_complete && !PWRITE) begin
      PRDATA = mem[PADDR];
    end
  end

endmodule : apb_slave
