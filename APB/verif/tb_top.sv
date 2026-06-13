`include "uvm_macros.svh"
import uvm_pkg::*;
import tb_pkg::*;

module tb_top;

  logic PCLK;
  parameter int unsigned ADDR_WIDTH = 8;
  parameter int unsigned DATA_WIDTH = 32;
  parameter int unsigned DEPTH = 1 << ADDR_WIDTH;
  parameter int unsigned WAIT_STATES = 2;
  always #5 PCLK = ~PCLK;

  apb_interface vif (PCLK);

  apb_slave #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .DEPTH(DEPTH),
      .WAIT_STATES(WAIT_STATES)
  ) dut (
      .PCLK(PCLK),
      .PRESETn(vif.PRESETn),
      .PSEL(vif.PSEL),
      .PENABLE(vif.PENABLE),
      .PWRITE(vif.PWRITE),
      .PADDR(vif.PADDR),
      .PWDATA(vif.PWDATA),
      .PRDATA(vif.PRDATA),
      .PREADY(vif.PREADY)
  );

  initial begin
    PCLK = 0;
    vif.PRESETn = 0;
    #10;
    vif.PRESETn = 1;
  end

  initial begin
    uvm_config_db#(virtual apb_interface.DRIVER)::set(null, "uvm_test_top.env.agnt.drv", "vif",
                                                      vif);
    $display("TB_TOP: setting apb_interface vif = %p", vif);
    uvm_config_db#(virtual apb_interface.MONITOR)::set(null, "uvm_test_top.env.agnt.mon", "vif",
                                                       vif);
    $display("TB_TOP: setting apb_interface vif = %p", vif);

    run_test("apb_test");
  end

endmodule : tb_top
